
import UIKit

protocol CoordinatorsProtocol: AnyObject {
    var childCoordinators: [CoordinatorsProtocol] { get }
    func start() -> UIViewController
    func addChildCoordinator(_ coordinator: CoordinatorsProtocol)
    func removeChildCoordinator(_ coordinator: CoordinatorsProtocol)
}

protocol CoordinatorProtocol: CoordinatorsProtocol {
    var branch: Branch? { get }
    var branchName: Branch.BranchName { get }
    func push(to page: CoordinatorsEnumProtocol)
}

extension CoordinatorsProtocol {
    func addChildCoordinator(_ coordinator: CoordinatorsProtocol) {}
    func removeChildCoordinator(_ coordinator: CoordinatorsProtocol) {}
}
