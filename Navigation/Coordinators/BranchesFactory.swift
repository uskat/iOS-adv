
import UIKit

final class BranchesFactory {
    
    static let shared = BranchesFactory()
    weak var delegateFirebase: FirebaseServiceProtocol?
    
    private init () {}
//    private let networkService: NetworkServiceProtocol

//    init(networkService: NetworkServiceProtocol) {
//        self.networkService = networkService
//    }

    func createBranch(name branchName: Branch.BranchName) -> Branch {
        switch branchName {
        case .feed:
            let viewModel = FeedViewModel()
            let vc = FeedViewController(viewModel: viewModel)
            let view = UINavigationController(rootViewController: vc)
            return Branch(branchName: branchName, view: view, viewModel: viewModel)
        case .profile:
            let viewModel = ProfileViewModel()
            var vc = UIViewController()
            if viewModel.firebaseService.isAuthorized {
                vc = ProfileViewController(viewModel: viewModel)
            } else {
                vc = LogInViewController(viewModel: viewModel)
                runLoginInspector(to: vc)
            }
            let view = UINavigationController(rootViewController: vc)
            return Branch(branchName: branchName, view: view, viewModel: viewModel)
        case .favorites:
            let viewModel = FavoritesViewModel()
            let vc = FavoritesViewController(viewModel: viewModel)
            let view = UINavigationController(rootViewController: vc)
            return Branch(branchName: branchName, view: view, viewModel: viewModel)
        }
    }
    func runLoginInspector(to vc: UIViewController) {
        lazy var loginInspector = MyLoginFactory.shared.makeLoginInspector() ///LogInDelegate
        (vc as? LogInViewController)?.loginDelegate = loginInspector ///LogInDelegate
    }
}
