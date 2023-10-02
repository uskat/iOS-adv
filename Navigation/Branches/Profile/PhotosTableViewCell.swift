
import UIKit

class PhotosTableViewCell: UITableViewCell {
    
    weak var delegate: ProfileVCDelegate?

//MARK: - ITEMs
    private let cellTitleName: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.text = NSLocalizedString("profile.photos", comment: "") 
        return $0
    }(UILabel())
    
    //просто картинка стрелки
    private let arrowToCollection: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "arrow.right")
        return $0
    }(UIImageView())
    
    private let fourPhotosView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.backgroundColor = .clear
        $0.spacing = 8
        return $0
    }(UIStackView())
    
    //делаем выборку из первых 4х фото в коллекции для размещения в stackView
    lazy var arrayOfFirstFourPhotos: [UIImageView] = {
        lazy var array = [UIImageView]()
        for index in 0...3 {
            let onePhoto: UIImageView = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.contentMode = .scaleAspectFill
                $0.backgroundColor = .black
                $0.layer.cornerRadius = 6
                $0.clipsToBounds = true
//                $0.image = photosVC.photos[index]
                return $0
            }(UIImageView())
            array.append(onePhoto)
        }
        return array
    }()
    
//MARK: - INITs
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        show()
        self.backgroundColor = .clear
        addTapGesture()
        showPhotos()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: - METHODs
    private func addTapGesture() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        self.addGestureRecognizer(singleTapGesture)
    }

    @objc private func handleSingleTap(_ tapGesture: UITapGestureRecognizer) {
        print("000")
        delegate?.openController(for: IndexPath(row: 0, section: 0))
    }
    
    private func show() {
        [cellTitleName, arrowToCollection, fourPhotosView].forEach({ contentView.addSubview($0) })
        arrayOfFirstFourPhotos.forEach({ fourPhotosView.addArrangedSubview($0) })
        
        let outSpace: CGFloat = 12  ///внешние отступы от фото до края экрана
        let inSpace: CGFloat = 8    ///внутренние отступы между фото
        let heightOfFourPhotos = (absoluteWidth - 2 * outSpace - 3 * inSpace) / 4
        
        NSLayoutConstraint.activate([
            cellTitleName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: outSpace),
            cellTitleName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: outSpace),
            cellTitleName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -outSpace),
            
            arrowToCollection.topAnchor.constraint(equalTo: contentView.topAnchor, constant: outSpace),
            arrowToCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -outSpace),
            arrowToCollection.centerYAnchor.constraint(equalTo: cellTitleName.centerYAnchor),
            
            fourPhotosView.topAnchor.constraint(equalTo: cellTitleName.bottomAnchor, constant: outSpace),
            fourPhotosView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: outSpace),
            fourPhotosView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -outSpace),
            fourPhotosView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -outSpace),
            fourPhotosView.heightAnchor.constraint(equalToConstant: heightOfFourPhotos)
        ])
    }
    
    func showPhotos() {
        let viewModel = ProfileViewModel()
        for index in 0...3 {
            arrayOfFirstFourPhotos[index].image = viewModel.photos[index]
        }
    }
}
