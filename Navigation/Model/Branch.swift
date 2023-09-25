
import UIKit

protocol ViewModelProtocol: AnyObject {
    var coordinator: CoordinatorProtocol? { get set }
}

protocol CoordinatorsEnumProtocol {
}

struct Branch {
    enum BranchName {
        case feed(controller: FeedBranch)
        case profile(controller: ProfileBranch)
        case favorites(controller: FavoritesBranch)
        
        enum FeedBranch: CoordinatorsEnumProtocol {
            case feed
            case post
            case info
            case map
        }
        
        enum ProfileBranch: CoordinatorsEnumProtocol {
            case login
            case profile
            case postDetailed
            case photoCollection
//            case photoDetailed
        }
        
        enum FavoritesBranch: CoordinatorsEnumProtocol {
            case favorites
        }
    }
    
    let branchName: BranchName
    let view: UIViewController
    let viewModel: ViewModelProtocol
}

extension Branch.BranchName {
    var tabBatItem: UITabBarItem {
        switch self {
            case .feed:
                return UITabBarItem(title: "Feed", image: UIImage(systemName: "rectangle.grid.2x2"), tag: 0)
            case .profile:
                return UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 1)
            case .favorites:
                return UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.text.square.fill"), tag: 2)
        }
    }
}


