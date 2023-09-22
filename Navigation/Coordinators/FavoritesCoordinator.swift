
import UIKit

class FavoritesCoordinator: CoordinatorProtocol {
    
    let branchName: Branch.BranchName
    private let factory: BranchesFactory
    private(set) var branch: Branch?
    private(set) var childCoordinators: [CoordinatorsProtocol] = []
    
    init(branchName: Branch.BranchName, factory: BranchesFactory) {
        self.branchName = branchName
        self.factory = factory
    }
        
    func start() -> UIViewController {
        let branch = factory.createBranch(name: branchName)
        let vc = branch.view
        vc.tabBarItem = branchName.tabBatItem
        (branch.viewModel as? FavoritesViewModel)?.coordinator = self
        self.branch = branch
        return vc
    }
    
    func push(to page: CoordinatorsEnumProtocol) {
        switch page {
        case .favorites as Branch.BranchName.FavoritesBranch:
            (branch?.view as? UINavigationController)?.popToRootViewController(animated: true)
        default:
            return
        }
    }
}


/*
 FEED
 switch page {
 case .feed as Branch.BranchName.FeedBranch:
     (branch?.view as? UINavigationController)?.popToRootViewController(animated: true)
 case .post as Branch.BranchName.FeedBranch:
     let view = PostViewController(viewModel: (branch?.viewModel as! FeedViewModel))
     let post = Post(title: "Post")
     view.post = post
     (branch?.view as? UINavigationController)?.pushViewController(view, animated: true)
 
 PROFILE
 switch page {
 case .login as Branch.BranchName.ProfileBranch:
     let view = LogInViewController(viewModel: branch?.viewModel as! ProfileViewModel)
     (branch?.view as? UINavigationController)?.pushViewController(view, animated: true)
     factory.runLoginInspector(to: view)
 case .profile as Branch.BranchName.ProfileBranch:
     let view = ProfileViewController(viewModel: ((branch?.viewModel as! ProfileViewModel)))
     (branch?.view as? UINavigationController)?.pushViewController(view, animated: true)
 */
