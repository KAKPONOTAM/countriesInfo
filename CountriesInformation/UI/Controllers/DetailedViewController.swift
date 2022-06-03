import UIKit

class DetailedViewController: UIViewController {
    private lazy var countryImagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
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
        return tableView
    }()
    
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

extension DetailedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension DetailedViewController: UIScrollViewDelegate, UICollectionViewDelegate  {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let count = scrollView.contentOffset.x / UIScreen.main.bounds.size.width
        pageControl.currentPage = Int(count)
    }
}
