import UIKit

class CountryDescriptionTableViewCell: UITableViewCell {
    private let descriptionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let generalInformationDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let generalInformationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.textAlignment = .right
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addSubview() {
        contentView.addSubview(descriptionImageView)
        contentView.addSubview(generalInformationDescriptionLabel)
        contentView.addSubview(generalInformationLabel)
    }
    
    private func setupConstraints() {
        let offset: CGFloat = 10
        NSLayoutConstraint.activate([
            descriptionImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offset),
            descriptionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset),
            descriptionImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -offset),
            descriptionImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1 / 5)
        ])
        
        NSLayoutConstraint.activate([
            generalInformationDescriptionLabel.leadingAnchor.constraint(equalTo: descriptionImageView.trailingAnchor, constant: offset / 2),
            generalInformationDescriptionLabel.topAnchor.constraint(equalTo: descriptionImageView.topAnchor),
            generalInformationDescriptionLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1 / 3),
            generalInformationDescriptionLabel.bottomAnchor.constraint(equalTo: descriptionImageView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            generalInformationLabel.topAnchor.constraint(equalTo: generalInformationDescriptionLabel.topAnchor),
            generalInformationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offset),
            generalInformationLabel.leadingAnchor.constraint(equalTo: generalInformationDescriptionLabel.trailingAnchor),
            generalInformationLabel.bottomAnchor.constraint(equalTo: generalInformationDescriptionLabel.bottomAnchor)
        ])
    }
    
    func configure(with titles: DetailedViewControllerCellTypes ,with countryRealm: CountryRealm) {
        descriptionImageView.image = UIImage(systemName: "sunrise")
        generalInformationDescriptionLabel.text = titles.title
        switch titles {
        case .capital:
            generalInformationLabel.text = countryRealm.capital
        case .population:
            generalInformationLabel.text = "\(countryRealm.population)"
        case .continent:
            generalInformationLabel.text = countryRealm.continent
        default:
            break
        }
    }
}
