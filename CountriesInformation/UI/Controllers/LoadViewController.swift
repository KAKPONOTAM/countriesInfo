import UIKit

class LoadViewController: UIViewController {
    private let activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        return spinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setupConstraints()
        transferData()
    }
    
    private func addSubview() {
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func transferData() {
        NetworkManager.shared.getCountriesData(by: .firstPageURL) { [unowned self] countriesData in
            let countriesViewController = CountriesViewController(countriesData: countriesData)
            let navigationController = UINavigationController(rootViewController: countriesViewController)
            navigationController.modalPresentationStyle = .overFullScreen
            self.present(navigationController, animated: true)
            self.activityIndicator.isHidden = true
        }
    }
}

