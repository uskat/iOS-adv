
import UIKit
import AVFoundation
import AVKit
import WebKit

class PostViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    var post: FeedCoordinator.Post?
    var viewModel: FeedViewModel
    
    private var player: AVPlayer!
    private var videoLayer: AVPlayerLayer!

    private lazy var webView: WKWebView = {
        $0.uiDelegate = self
        $0.navigationDelegate = self
        $0.allowsBackForwardNavigationGestures = true
        $0.allowsLinkPreview = true
        return $0
    }(WKWebView())
    
    private lazy var videoView: UIView = {
        $0.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 220)
        $0.backgroundColor = .systemGray5
        return $0
    }(UIView())
    
    lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        return $0
    }(UITableView(frame: .zero, style: .grouped))
    
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
        videoView.addSubview(webView)
        videoView = webView
        showPostTable()
        showBarButton()
        if let post = post {
            title = post.title
        }
    }


//MARK: - METHODs
    private func showBarButton() {
        let button = UIBarButtonItem(title: "Info...", style: .plain, target: self, action: #selector(tapAction))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func tapAction() {
        let forthVC = InfoViewController()
        present(forthVC, animated: true)
    }
    
    private func showPostTable() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func streamVideoPlayer(videoCode: String) {
        let videoURL = URL(string: "https://www.youtube.com/embed/\(videoCode)")!
        let myRequest = URLRequest(url: videoURL)
        webView.load(myRequest)
    }
}

extension PostViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.videos.count
        } else {
            return viewModel.videos1.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            cell.setupCell(viewModel.videos[indexPath.row].name)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            cell.setupCell(viewModel.videos1[indexPath.row].name)
            return cell
        }
    }
}

extension PostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 1:
                return "AVPlayer like Layer"
            default:
                return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return videoView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 220
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let player = player {
                player.pause()
            }
            streamVideoPlayer(videoCode: viewModel.videos[indexPath.row].videoCode)
        } else {
            if let player = player {
                player.pause()
            }
            setupVideoPlayer(video: viewModel.videos1[indexPath.row].videoCode)
        }
    }
}

extension PostViewController {
    func setupVideoPlayer(video: String) {
        // retrive video from project files, type "mp4"
        let videoURL = Bundle.main.url(forResource: video, withExtension: "mp4")
//        let asset = AVAsset(url: videoURL!)

        // configure player
//        playerItem = AVPlayerItem(asset: asset)
//        observePlayer(playerItem)
        
        // Создаём AVPlayer со ссылкой на видео.
        player = AVPlayer(url: videoURL!)

        // Создаём AVPlayerViewController и передаём ссылку на плеер.
        videoLayer = AVPlayerLayer(player: player)
        
        videoLayer.frame = videoView.bounds
        videoLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(videoLayer)
        player.play()
        
        
        // handle video end
//        center.addObserver(self, selector: #selector(videoEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
//    @objc private func videoEnded() {
//        playerItem?.seek(to: CMTime.zero) { (finished) in
//            if finished {
//                OperationQueue.main.addOperation { [weak self] in
//                    self?.player.play()
//                }
//            }
//        }
//    }
}
