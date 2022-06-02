import UIKit

class CountryTableViewCell: UITableViewCell {
    
    private let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let countryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let smallDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let capitalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray3
        label.numberOfLines = 0
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
        contentView.addSubview(flagImageView)
        contentView.addSubview(countryNameLabel)
        contentView.addSubview(smallDescriptionLabel)
        contentView.addSubview(capitalLabel)
    }
    
    private func setupConstraints() {
        let offset: CGFloat = 20
        let height: CGFloat = 60
        
        NSLayoutConstraint.activate([
            flagImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offset),
            flagImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset),
            flagImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1 / 4),
            flagImageView.heightAnchor.constraint(equalToConstant: height)
        ])
        
        NSLayoutConstraint.activate([
            countryNameLabel.topAnchor.constraint(equalTo: flagImageView.topAnchor),
            countryNameLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 10),
            countryNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offset),
            countryNameLabel.heightAnchor.constraint(equalTo: flagImageView.heightAnchor, multiplier: 1 / 2)
        ])
        
        NSLayoutConstraint.activate([
            capitalLabel.topAnchor.constraint(equalTo: countryNameLabel.bottomAnchor),
            capitalLabel.leadingAnchor.constraint(equalTo: countryNameLabel.leadingAnchor),
            capitalLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offset),
            capitalLabel.bottomAnchor.constraint(equalTo: flagImageView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            smallDescriptionLabel.topAnchor.constraint(equalTo: flagImageView.bottomAnchor, constant: offset),
            smallDescriptionLabel.leadingAnchor.constraint(equalTo: flagImageView.leadingAnchor),
            smallDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offset),
            smallDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -offset)
        ])
    }
    
    func configure(with country: CountryRealm) {
        flagImageView.image = UIImage(data: country.countryImageData)
        countryNameLabel.text = country.name
        capitalLabel.text = country.capital
        smallDescriptionLabel.text = country.smallDescription
    }
}

