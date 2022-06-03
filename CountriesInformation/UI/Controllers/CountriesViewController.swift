import UIKit
import RealmSwift

class CountriesViewController: UIViewController {
    private var countryRealmData: CountriesRealmData?
    private var notificationToken: NotificationToken?
    private let countriesProvider = CountriesProvider()
    
    private lazy var countriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: CountryTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        addSubview()
        setupConstraints()
        loadCountries()
        setupRealmDataSource()
    }
    
    private func addSubview() {
        view.addSubview(countriesTableView)
    }
    
    private func getCountriesDataFromNetwork(by urlString: URLStrings) {
        NetworkManager.shared.getCountriesData(by: urlString) { [weak self] countriesData  in
            self?.countriesTableView.tableFooterView = self?.createFooterViewWithLoadSpinner()
            DispatchQueue.global(qos: .userInitiated).async {
                
                let countryRealm: [CountryRealm] = countriesData.countries.map {
                    let images = List<String>()
                    images.append(objectsIn: $0.countryInfo.images.map { $0 })
                    let countryImagesData = List<Data>()
                    var countryImagesUrl = [URL]()
                    let imagesUrlStringArray = Array(images)
                    
                    countryImagesUrl = imagesUrlStringArray.map {
                        guard let url = URL(string: $0) else { return URL(fileURLWithPath: "") }
                        return url
                    }
                    
                    let data = countryImagesUrl.map { try? Data(contentsOf: $0) }
                    
                    for value in data {
                        countryImagesData.append(value ?? Data())
                    }
                    
                    let countryImageData = NetworkManager.shared.loadImage(from: $0.countryInfo.flag)
                    let countryRealmData = CountryRealm(name: $0.name, continent: $0.continent, capital: $0.capital, population: $0.population, smallDescription: $0.smallDescription, countryDescription: $0.smallDescription, image: $0.image, flag: $0.countryInfo.flag, countryImageData: countryImageData, images: images, imagesData: countryImagesData)
                    
                    return countryRealmData
                }
                
                DispatchQueue.main.async {
                    self?.countriesProvider.saveCountry(by: countryRealm)
                    let countriesRealmData = CountriesRealmData(next: countriesData.next)
                    
                    self?.countriesProvider.saveCountryRealmData(countryRealmData: countriesRealmData)
                    self?.countryRealmData = countriesRealmData
                    self?.countriesTableView.tableFooterView = nil
                }
            }
        }
    }
    
    private func loadCountries() {
        if let countryRealmData = countriesProvider.getCountriesFromRealm() {
            self.countryRealmData = countryRealmData
        } else {
            getCountriesDataFromNetwork(by: .firstPageURL)
        }
    }
    
    
    private func setupRealmDataSource() {
        let realm = try? Realm()
        self.notificationToken = realm?.objects(CountriesRealmData.self).observe({ [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial(let results), .update(let results, deletions: _, insertions: _, modifications: _):
                self?.countryRealmData = Array(results).first
                self?.countriesTableView.reloadData()
                
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            countriesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            countriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countriesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGray6
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        title = "Countries"
    }
    
    private func createFooterViewWithLoadSpinner() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        let loadSpinner = UIActivityIndicatorView()
        loadSpinner.center = footerView.center
        loadSpinner.startAnimating()
        
        footerView.addSubview(loadSpinner)
        return footerView
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension CountriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryRealmData?.countries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let countryCell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier, for: indexPath) as? CountryTableViewCell else { return UITableViewCell() }
        guard let country = countryRealmData?.countries?[indexPath.row] else { return UITableViewCell() }
        
        countryCell.accessoryType = .disclosureIndicator
        countryCell.configure(with: country)
        
        return countryCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let countryRealm = countryRealmData?.countries?[indexPath.row] else { return }
        let detailedViewController = DetailedViewController(countryRealm: countryRealm)
        navigationController?.pushViewController(detailedViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UIScrollViewDelegate
extension CountriesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > countriesTableView.contentSize.height - 100 - scrollView.frame.height {
            getCountriesDataFromNetwork(by: .nextPageURL(nextPageURL: countryRealmData?.next ?? ""))
        }
    }
}
