
import UIKit

final class FeedCoordinator: CoordinatorProtocol {

    let branchName: Branch.BranchName
    private let factory: BranchesFactory
    private(set) var branch: Branch?
    private(set) var childCoordinators: [CoordinatorsProtocol] = []

    init(branchName: Branch.BranchName, factory: BranchesFactory) {
        self.branchName = branchName
        self.factory = factory
    }

//    init() {
////        children = []
//        print("feed coord start")
////        feedNC = UINavigationController(rootViewController: feedVC)
////        feedNC.tabBarItem = UITabBarItem(title: "Feed",
////                                         image: UIImage(systemName: "text.bubble"),
////                                         selectedImage: UIImage(systemName: "text.bubble.fill"))
////        controller = feedNC
//        print("feed controller = \(controller)")
//    }

    struct Post {
        var title: String
    }
    
    func start() -> UIViewController {
        let branch = factory.createBranch(name: branchName)
        let vc = branch.view
        vc.tabBarItem = branchName.tabBatItem
        (branch.viewModel as? FeedViewModel)?.coordinator = self
        self.branch = branch
        return vc
    }
    
    func push(to page: CoordinatorsEnumProtocol) {
        switch page {
        case .feed as Branch.BranchName.FeedBranch:
            (branch?.view as? UINavigationController)?.popToRootViewController(animated: true)
        case .post as Branch.BranchName.FeedBranch:
            let view = PostViewController(viewModel: (branch?.viewModel as! FeedViewModel))
            let post = Post(title: "Post")
            view.post = post
            (branch?.view as? UINavigationController)?.pushViewController(view, animated: true)
        case .info as Branch.BranchName.FeedBranch:
            let view = InfoViewController()
            (branch?.view as? UINavigationController)?.present(view, animated: true)
        default:
            return
        }
    }
}
