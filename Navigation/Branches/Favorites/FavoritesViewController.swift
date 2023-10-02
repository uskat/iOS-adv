
import UIKit

class FavoritesViewController: UIViewController {

    let viewModel: FavoritesViewModel
    private let profileTVCell = ProfileTableViewCell()
    private let detailedPostVC = DetailedPostViewController()
    private let coreDataService: CoreDataProtocol = CoreDataService.shared

//MARK: - ITEMs
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.createColor(lightMode: .clear, darkMode: .systemGray6)
        $0.dataSource = self
        $0.delegate = self
        $0.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        return $0
    }(UITableView(frame: .zero, style: .grouped))
    
//MARK: - INITs
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("favorites", comment: "")
        view.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .black)
        showBarButton()
        setupUI()
        self.fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

//MARK: - METHODs
    private func showBarButton() {
        let filterOnButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.on.rectangle.circle"),
            style: .plain,
            target: self,
            action: #selector(filterOn))
        let filterOffButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.on.rectangle.slash.circle"),
            style: .plain,
            target: self,
            action: #selector(filterOff))
        navigationItem.rightBarButtonItems = [filterOffButton, filterOnButton]
    }
    
    private func fetchPosts() {
        self.coreDataService.fetchPosts() { [weak self] fetchedPosts in
            favoritePosts = fetchedPosts.map { Post(postCoreDataModel: $0) }
            self?.tableView.reloadData()
        }
    }
    
    @objc private func filterOn() {
        alertOffilter()
    }
    
    @objc private func filterOff() {
        fetchPosts()
    }
    
    private func alertOffilter() {
        let alert = UIAlertController(title: "",
                                      message: "",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Type name"
        }
        let done = UIAlertAction(title: "Ok",
                                   style: .default) { [weak alert] _ in
            guard let textField = alert?.textFields else { return }
            if let name = textField[0].text {
                self.coreDataService.fetchPosts(predicate: NSPredicate(format: "author == %@", name)) { [weak self] fetchedPosts in
                    favoritePosts = fetchedPosts.map { Post(postCoreDataModel: $0) }
                    self?.tableView.reloadData()
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel",
                                   style: .destructive) { _ in
            print("Отмена")
        }
        alert.addAction(done)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    
    private func setupUI() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
        cell.isFavorites = true
        cell.selectionStyle = .none  // Убираем выделение ячейки при тапе
        cell.setupCell(favoritePosts[indexPath.row])
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
}

//MARK: высота ячейки в таблице.
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete") { _, _, _ in
                let post = favoritePosts[indexPath.row]
                self.coreDataService.deletePost(predicate: NSPredicate(format: "id == %@", post.id)) { [weak self] success in
                    if success {
                        favoritePosts.remove(at: indexPath.row)
                        self?.tableView.reloadData()
                    }
                }
            }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension FavoritesViewController: ProfileVCDelegate {
    func openController(for indexPath: IndexPath) {
        detailedPostVC.indexPath = indexPath
        profileTVCell.indexPath = indexPath
        detailedPostVC.delegate = self
//        favoritePosts[indexPath.row].views += 1
        present(detailedPostVC, animated: true)
        detailedPostVC.setupCell(favoritePosts[indexPath.row])
//        tableView.reloadData()
    }
    
    func addPostToFavorites(withIndex indexPath: IndexPath) {
    }
    
    func addLike(_ indexPath: IndexPath, _ from: String) {
    }
}
