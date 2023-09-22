//import StorageService
import UIKit

class ProfileTableViewCell: UITableViewCell {

//MARK: - PROPs
    var indexPath: IndexPath?
    var post: Post?
    weak var delegate: ProfileVCDelegate?
    var isFavorites: Bool?
    let viewModel = ProfileViewModel()
    
//MARK: - ITEMs
    private let postView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    let postName: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    let postDescription: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .systemGray
        $0.backgroundColor = .clear
        $0.isEditable = false
        $0.isSelectable = false
        $0.isScrollEnabled = false
        return $0
    }(UITextView())

    let postImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    let likes: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.isUserInteractionEnabled = true
        return $0
    }(UILabel())
    
    let views: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .right
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return $0
    }(UILabel())
    
    private var addedPostLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Papyrus", size: 24)
        $0.textColor = UIColor.AccentColor.normal
        $0.text = "Added to Favorites"
        $0.alpha = 0.0
        return $0
    }(UILabel())
    
//MARK: - INITs
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        addSingleAndDoubleTapGesture()
        setupLikesGestures()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - METHODs
    private func addSingleAndDoubleTapGesture() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        singleTapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTapGesture)

        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)

        singleTapGesture.require(toFail: doubleTapGesture)
    }

    @objc private func handleSingleTap(_ tapGesture: UITapGestureRecognizer) {
        print("ONE")
        guard let indexPath = indexPath else { return }
        delegate?.openController(for: indexPath)
    }

    @objc private func handleDoubleTap(_ tapGesture: UITapGestureRecognizer) {
        print("TWO")
        guard let indexPath = indexPath else { return }
        delegate?.addPostToFavorites(withIndex: indexPath)
        flyingLabel()
    }
    
    private func setupLikesGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLike))
        likes.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapLike (){
        if let indexPath = indexPath { delegate?.addLike(indexPath, "Profile") }
        if let post = post { likes.text = "Likes: \(post.likes)" }
    }
    
    private func flyingLabel() {
        contentView.addSubview(addedPostLabel)
        self.addedPostLabel.alpha = 1.0
        let labelXconstraint = self.addedPostLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6)
        let labelYconstraint = self.addedPostLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6)
        NSLayoutConstraint.activate([labelXconstraint, labelYconstraint])
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut) { [weak self] in
//            labelXconstraint.constant += 100
//            labelYconstraint.constant += -150
            self?.addedPostLabel.alpha = 0.5
            self?.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) { [weak self] in
                self?.addedPostLabel.alpha = 0.0
            } completion: { _ in
                NSLayoutConstraint.deactivate([labelXconstraint, labelYconstraint])
                self.addedPostLabel.removeFromSuperview()
            }
        }
    }
    
    func setupUI() {
        [postView, postName, postDescription, postImage, likes, views].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            postView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            postView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            postView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0),
            postView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0),

            postName.topAnchor.constraint(equalTo: postView.topAnchor, constant: 16),
            postName.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 16),
            postName.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -16),
            postName.heightAnchor.constraint(equalToConstant: 26),

            postImage.topAnchor.constraint(equalTo: postName.bottomAnchor, constant: 12),
            postImage.leadingAnchor.constraint(equalTo: postView.leadingAnchor),
            postImage.trailingAnchor.constraint(equalTo: postView.trailingAnchor),
            postImage.heightAnchor.constraint(equalToConstant: absoluteWidth),

            postDescription.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 16),
            postDescription.leadingAnchor.constraint(equalTo: postName.leadingAnchor),
            postDescription.trailingAnchor.constraint(equalTo: postName.trailingAnchor),

            likes.topAnchor.constraint(equalTo: postDescription.bottomAnchor, constant: 16),
            likes.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 16),
            likes.trailingAnchor.constraint(equalTo: postView.centerXAnchor, constant: 0),
            likes.bottomAnchor.constraint(equalTo: postView.bottomAnchor, constant: -16),
            
            views.topAnchor.constraint(equalTo: postDescription.bottomAnchor, constant: 16),
            views.leadingAnchor.constraint(equalTo: postView.centerXAnchor, constant: 0),
            views.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -16),
            views.bottomAnchor.constraint(equalTo: postView.bottomAnchor, constant: -16)
        ])
    }

    func setupCell(_ post: Post) {
        postImage.image = UIImage(named: post.imageName)
        postName.text = post.author
        postDescription.text = post.postDescription
        likes.text = "Likes: \(post.likes)"
        views.text = "Views: \(post.views)"
    }
}
