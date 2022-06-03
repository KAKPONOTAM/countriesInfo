import UIKit

class DetailedViewController: UIViewController {
    private var countryRealm: CountryRealm?
    private lazy var countryImagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.register(CountryImagesCollectionViewCell.self, forCellWithReuseIdentifier: CountryImagesCollectionViewCell.identifier)
        collectionView.backgroundColor = .green
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.backgroundColor = .red
        return pageControl
    }()
    
    private lazy var countryDescriptionTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CountryDescriptionTableViewCell.self, forCellReuseIdentifier: CountryDescriptionTableViewCell.identifier)
        return tableView
    }()
    
    init(countryRealm: CountryRealm?) {
        self.countryRealm = countryRealm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.countryRealm = nil
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setupConstraints()
    }
    
    private func addSubview() {
        view.addSubview(countryDescriptionTableView)
        view.addSubview(countryImagesCollectionView)
        //countryImagesCollectionView.addSubview(pageControl)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            countryImagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            countryImagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countryImagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countryImagesCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 2.5)
        ])
        
        NSLayoutConstraint.activate([
            countryDescriptionTableView.topAnchor.constraint(equalTo: countryImagesCollectionView.bottomAnchor),
            countryDescriptionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countryDescriptionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countryDescriptionTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


//MARK: -  UITableViewDataSource, UITableViewDelegate
extension DetailedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailedViewControllerCellTypes.getRowsAmount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let countryDetailsCell = tableView.dequeueReusableCell(withIdentifier: CountryDescriptionTableViewCell.identifier, for: indexPath) as? CountryDescriptionTableViewCell,
              let countryRealm = countryRealm else { return UITableViewCell() }
        
        let descriptionCell = DetailedViewControllerCellTypes.getRow(index: indexPath.row)
        
        switch descriptionCell {
        case .capital:
            countryDetailsCell.configure(with: .capital, with: countryRealm)
        case .population:
            countryDetailsCell.configure(with: .population, with: countryRealm)
        case .continent:
            countryDetailsCell.configure(with: .continent, with: countryRealm)
        case .description:
            countryDetailsCell.configure(with: .description, with: countryRealm)
        }
        
        return countryDetailsCell
    }
}

//MARK: -  UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource
extension DetailedViewController: UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imagesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryImagesCollectionViewCell.identifier, for: indexPath) as? CountryImagesCollectionViewCell else { return UICollectionViewCell() }
        return imagesCollectionViewCell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let count = scrollView.contentOffset.x / UIScreen.main.bounds.size.width
        pageControl.currentPage = Int(count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
