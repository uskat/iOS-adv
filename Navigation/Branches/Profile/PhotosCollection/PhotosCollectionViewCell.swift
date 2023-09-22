
import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
//MARK: - ITEMs
    private let imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
//MARK: - INITs
    override init(frame: CGRect) {
        super.init(frame: frame)
        showImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - METHODs
    func setupCell(_ image: UIImage) {
        imageView.image = image
    }

    func showImageView() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
