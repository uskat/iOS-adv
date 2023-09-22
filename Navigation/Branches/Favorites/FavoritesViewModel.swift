
import Foundation

class FavoritesViewModel: ViewModelProtocol {
    
    weak var coordinator: CoordinatorProtocol?
    
    func load(to page: Branch.BranchName.FeedBranch) {
        coordinator?.push(to: page)
    }

}
