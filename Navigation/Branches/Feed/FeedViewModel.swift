
import UIKit

protocol FeedViewModelProtocol: ViewModelProtocol {
    var coordinator: CoordinatorProtocol? { get set }
    func load(to page: Branch.BranchName.FeedBranch)
}

class FeedViewModel: FeedViewModelProtocol {
    
    var videos = Videos.load()
    var videos1 = Videos.load1()
//    lazy var streamURL = URL(string: "GoT")!

    lazy var localURL: URL = {
        let path = Bundle.main.path(forResource: "GoT", ofType: "mp4")!
        return URL(fileURLWithPath: path)
    }()
    
    weak var coordinator: CoordinatorProtocol?
    
    func load(to page: Branch.BranchName.FeedBranch) {
        coordinator?.push(to: page)
    }
}
