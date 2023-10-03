
import UIKit
import AVFoundation
import AVKit

class FeedViewController: UIViewController {
    
//MARK: - ITEMs
    private let viewModel: FeedViewModel
     var colorOfPassCheck: UIColor = .black
//    private let newPost = Post(title: "Post")

    private lazy var headline: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        $0.text = "feed.inputPassLabel".localized
        $0.adjustsFontSizeToFitWidth = true
        return $0
    }(UILabel())

    private lazy var guessTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        $0.placeholder = "feed.inputPassPlaceholder".localized
        $0.adjustsFontSizeToFitWidth = true         ///уменьшение шрифта, если введенный текст не помещается
        $0.minimumFontSize = 10                     ///до какого значения уменьшается шрифт
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0) ///сдвиг курсора на 5пт в textField (для красоты)
        return $0
    }(UITextField())
    
    private lazy var checkGuessButton: CustomButton = {
        let button = CustomButton(
            title: "feed.toGuessButtonN".localized,
            titleHighlighted: "feed.toGuessButtonH".localized,
            titleHighlightedColor: .lightGray,
            tapAction:  { [weak self] in
                            let feedModel = FeedModel()
                            self?.colorOfPassCheck = feedModel.check(word: self?.guessTextField.text ?? "")
                            self?.headline.textColor = self?.colorOfPassCheck
                        })
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        return button
    }()
    
    private let feedStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 10
        return $0
    }(UIStackView())
    
    private lazy var feedButton0: CustomButton = {
        let button = CustomButton(
            title: "feed.toInfoVCButtonN".localized,
            titleHighlighted: "feed.toInfoVCButtonH".localized,
            titleColor: .yellow,
            titleHighlightedColor: .lightGray,
            tapAction: { [weak self] in self?.tapFeedButton0() })
        return button
    }()
    
    private lazy var feedButton1: CustomButton = {
        let button = CustomButton(
            title: "feed.toListOfVideoN".localized,
            titleHighlighted: "feed.toListOfVideoH".localized,
            titleColor: .green,
            titleHighlightedColor: .lightGray,
            tapAction: { [weak self] in self?.tapFeedButton1() })
        return button
    }()
    
    private lazy var feedButton2: CustomButton = {
        let button = CustomButton(
            title: "feed.toVideoPlayerButtonN".localized,
            titleHighlighted: "feed.toVideoPlayerButtonN".localized,
            titleColor: .green,
            titleHighlightedColor: .lightGray,
            tapAction: { [weak self] in self?.tapFeedButton2() })
        return button
    }()
    
    private lazy var feedButton3: CustomButton = {
        let button = CustomButton(
            title: "feed.toMapButtonN".localized,
            titleHighlighted: "feed.toMapButtonN".localized,
            titleColor: .red,
            titleHighlightedColor: .lightGray,
            tapAction: { [weak self] in self?.tapFeedButton3() })
        return button
    }()
    
    //MARK: - INITs
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addTapGestureToHideKeyboard() /// скрываем клавиатуру при нажатии в любом месте экрана вне textField
        showItems()
    }

//MARK: - METHODs
    private func tapFeedButton0() {
        viewModel.load(to: .info)
    }
    
    private func tapFeedButton1() {
        viewModel.load(to: .post)
    }
    
    private func tapFeedButton2() {
        // Создаём AVPlayer со ссылкой на видео.
        let player = AVPlayer(url: viewModel.localURL)

        // Создаём AVPlayerViewController и передаём ссылку на плеер.
        let controller = AVPlayerViewController()
        controller.player = player

        // Показываем контроллер модально и запускаем плеер.
        present(controller, animated: true) {
            player.play()
        }
//        viewModel.load(to: .info)
    }
    
    private func tapFeedButton3() {
        viewModel.load(to: .map)
    }
    
    private func showItems() {
        [headline, guessTextField, checkGuessButton, feedStackView].forEach{ view.addSubview($0) }
        [feedButton0, feedButton1, feedButton2, feedButton3].forEach { feedStackView.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            //заголовок проверки значения
            headline.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headline.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headline.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            //поле для ввода проверяемого значения
            guessTextField.topAnchor.constraint(equalTo: headline.bottomAnchor, constant: 16),
            guessTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            guessTextField.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -16),
            guessTextField.heightAnchor.constraint(equalToConstant: 40),

            //кнопка для запуска проверки значения
            checkGuessButton.topAnchor.constraint(equalTo: headline.bottomAnchor, constant: 16),
            checkGuessButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 16),
            checkGuessButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            checkGuessButton.heightAnchor.constraint(equalToConstant: 40),
            
            feedStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            feedStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            feedStackView.widthAnchor.constraint(equalToConstant: screenWidth),
            feedStackView.heightAnchor.constraint(equalToConstant: 170)
        ])
    }
}
