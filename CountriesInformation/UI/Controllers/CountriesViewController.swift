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
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loadActivityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()
        return view
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
        view.addSubview(containerView)
        containerView.addSubview(loadActivityIndicator)
    }
    
    private func getCountriesDataFromNetwork(by urlString: URLStrings) {
        NetworkManager.shared.getCountriesData(by: urlString) { [weak self] countriesData  in
            self?.countriesTableView.tableFooterView = self?.createFooterViewWithLoadSpinner()
            DispatchQueue.global(qos: .userInitiated).async {
                let countryRealm: [CountryRealm] = countriesData.countries.map {
                    let images = List<String>()
                    images.append(objectsIn: $0.countryInfo.images.map { $0 })
                    let countryImageData = NetworkManager.shared.loadImage(from: $0.countryInfo.flag)
                    let countryRealmData = CountryRealm(name: $0.name, continent: $0.continent, capital: $0.capital, population: $0.population, smallDescription: $0.smallDescription, countryDescription: $0.smallDescription, image: $0.image, flag: $0.countryInfo.flag, countryImageData: countryImageData, images: images)
                    
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
        
        containerView.removeFromSuperview()
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
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loadActivityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loadActivityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
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
