
import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController {

    let viewModel: ProfileViewModel
//    let coordinator: ProfileCoordinator
    let profileHeaderView = ProfileHeaderView()
//    let imagePublisherFacade = ImagePublisherFacade()
    let imageProcessor = ImageProcessor()

//MARK: - ITEMs
    private lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.createColor(lightMode: .black, darkMode: .systemGray6)
        $0.dataSource = self
        $0.delegate = self
        $0.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    
    private lazy var buttonX: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 12
        $0.backgroundColor = UIColor.createColor(lightMode: .AccentColor.normal, darkMode: .AccentColor.normal)
        $0.setImage(UIImage(systemName: "x.circle"), for: .normal)
        $0.tintColor = UIColor.createColor(lightMode: .black, darkMode: .lightGray)
        $0.alpha = 0.0
        $0.isHidden = true
        $0.addTarget(self, action: #selector(tapButtonX), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private var myImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .none
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private var myView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
//MARK: - INITs
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Photo Gallery"
        view.backgroundColor = .systemGray6
        showCollection()
        restylePhotos()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        imagePublisherFacade.subscribe(self)    ///оформляем подписку на отображение фотографий в контроллере
//        imagePublisherFacade.addImagesWithTimer(time: 0.5, repeat: viewModel.photos.count * 2, userImages: viewModel.photos) ///медленная загрузка фото
//    }
    
    override func viewWillLayoutSubviews() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        imagePublisherFacade.removeSubscription(for: self)   ///отменяем подписку на отображение фотографий
//        imagePublisherFacade.rechargeImageLibrary()    ///очищаем библиотеку загруженных фото
//    }
    
//MARK: - METHODs
    @objc private func tapButtonX() {
        print("tap x")
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut) { [self] in
            self.buttonX.alpha = 0.0
        } completion: { _ in
            self.buttonX.isHidden = true
        }
        UIView.transition(with: collectionView, duration: 1.0, options: .transitionFlipFromBottom, animations: { [self] in
            profileHeaderView.blurBackgroundEffect().removeFromSuperview()
            collectionView.isUserInteractionEnabled = true
            myView.removeFromSuperview()
        }, completion: nil)
    }
    
    private func showCollection() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //анимированное отображение окна с увеличенным фото
    func showViewWithPhotoOnTap(_ image: UIImage)  {
        UIView.transition(with: collectionView, duration: 1.0, options: .transitionFlipFromBottom, animations: { [self] in
            collectionView.addSubview(myView)
            myView.addSubview(profileHeaderView.blurBackgroundEffect())
            myImageView.image = image
            myView.addSubview(myImageView)
            myView.addSubview(buttonX)
            NSLayoutConstraint.activate([
                myView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                myView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                myView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                myView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
                
                myImageView.centerXAnchor.constraint(equalTo: myView.centerXAnchor),
                myImageView.centerYAnchor.constraint(equalTo: myView.centerYAnchor),
                myImageView.widthAnchor.constraint(equalToConstant: absoluteWidth),
                myImageView.heightAnchor.constraint(equalToConstant: absoluteWidth),
                
                buttonX.topAnchor.constraint(equalTo: myView.topAnchor, constant: 20),
                buttonX.trailingAnchor.constraint(equalTo: myView.trailingAnchor, constant: -20),
                buttonX.widthAnchor.constraint(equalToConstant: 24),
                buttonX.heightAnchor.constraint(equalToConstant: 24)
            ])
        }, completion: nil)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut) { [self] in
            self.buttonX.isHidden = false
            self.buttonX.alpha = 1.0
        } completion: { _ in  }
    }
}

//MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier, for: indexPath) as! PhotosCollectionViewCell
        cell.setupCell(viewModel.photos[indexPath.row])
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    private var inSpace: CGFloat { return 8 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (absoluteWidth - 4 * inSpace) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        inSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        inSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: inSpace, left: inSpace, bottom: inSpace, right: inSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = viewModel.photos[indexPath.row]
        showViewWithPhotoOnTap(image)
    }
}

//extension PhotosViewController: ImageLibrarySubscriber {
//    func receive(images: [UIImage]) {
//        print("images \(images) images")
//        viewModel.photos = images
//        collectionView.reloadData()
//    }
//}

extension PhotosViewController {
    private func restylePhotos() {
        let time1 = DispatchTime.now().uptimeNanoseconds
        imageProcessor.processImagesOnThread(sourceImages: viewModel.photos, filter: .chrome, qos: .background) { [weak self] images in
            self?.viewModel.photos = images
                .compactMap{ $0 }
                .map{ UIImage(cgImage: $0) }
            DispatchQueue.main.async {
                [weak self] in
                self?.collectionView.reloadData()
                let time2 = DispatchTime.now().uptimeNanoseconds
                print("Всего затрачено времени на обработку фотографий \((time2 - time1) / 1000000000) сек.")
            }
        }
    }
}

