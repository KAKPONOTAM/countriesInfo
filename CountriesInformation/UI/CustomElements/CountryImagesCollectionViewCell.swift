import UIKit

class CountryImagesCollectionViewCell: UICollectionViewCell {
    private let countryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addSubview() {
        contentView.addSubview(countryImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            countryImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            countryImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            countryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            countryImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with countryImageData: Data) {
        countryImageView.image = UIImage(data: countryImageData)
    }
}
