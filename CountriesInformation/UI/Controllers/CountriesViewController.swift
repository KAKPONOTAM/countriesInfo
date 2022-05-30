import UIKit

class CountriesViewController: UIViewController {
    private var countriesData: CountriesData?
    
    private lazy var countriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        return tableView
    }()
    
    init(countriesData: CountriesData) {
        self.countriesData = countriesData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        countriesData = nil
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        addSubview()
        setupConstraints()
    }
    
    private func addSubview() {
        view.addSubview(countriesTableView)
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
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension CountriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesData?.countries.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        return cell
    }
}
 
//MARK: - UIScrollViewDelegate
extension CountriesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
