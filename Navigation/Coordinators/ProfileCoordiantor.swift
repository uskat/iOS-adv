
import UIKit

class ProfileCoordinator: CoordinatorProtocol {
    
//    let loginInspector = MyLoginFactory.shared.makeLoginInspector() ///LogInDelegate
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
        (branch.viewModel as? ProfileViewModel)?.coordinator = self
        self.branch = branch
        return vc
    }
    
    func push(to page: CoordinatorsEnumProtocol) {
        switch page {
        case .login as Branch.BranchName.ProfileBranch:
            let view = LogInViewController(viewModel: branch?.viewModel as! ProfileViewModel)
            (branch?.view as? UINavigationController)?.pushViewController(view, animated: true)
            factory.runLoginInspector(to: view)
        case .profile as Branch.BranchName.ProfileBranch:
            let view = ProfileViewController(viewModel: ((branch?.viewModel as! ProfileViewModel)))
            (branch?.view as? UINavigationController)?.pushViewController(view, animated: true)
        case .postDetailed as Branch.BranchName.ProfileBranch:
            let view = DetailedPostViewController()
            (branch?.view as? UINavigationController)?.present(view, animated: true)
        case .photoCollection as Branch.BranchName.ProfileBranch:
            let view = PhotosViewController(viewModel: (branch?.viewModel as! ProfileViewModel))
            (branch?.view as? UINavigationController)?.present(view, animated: true)
        default:
            return
        }
    }

//    func start(authKey: Bool) -> UIViewController {
//        let vc = authKey ?
//        ProfileViewController(viewModel: viewModel, coordinator: self) :
//        LogInViewController(loginViewModel: loginViewModel, viewModel: viewModel, coordinator: self)
//
//        if !authKey {
//            let loginInspector = MyLoginFactory.shared.makeLoginInspector()
//            (vc as! LogInViewController).loginDelegate = loginInspector
//            vc.title = "Login"
//        } else {
//            vc.title = "Profile"
//        }
//
//        let nvc = UINavigationController(rootViewController: vc)
//        vc.tabBarItem.image = UIImage(systemName: "person.crop.circle")
//        UIApplication.shared.window?.rootViewController = nvc
//        return nvc
//    }
}
