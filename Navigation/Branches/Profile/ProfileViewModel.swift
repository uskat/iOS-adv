
import UIKit

class ProfileViewModel: ViewModelProtocol {

    //MARK: LoginViewModel
    var statusEntry = true
    var firebaseService = FirebaseService.shared
    var photos = Photo.addPhotos()
    var posts: [Post] = Post.addPosts()
    weak var coordinator: CoordinatorProtocol?

#if DEBUG
//    let userService = TestUserService.shared
#else
    let userService = CurrentUserService.shared
#endif
    
    func load(to page: Branch.BranchName.ProfileBranch) {
        coordinator?.push(to: page)
    }
}
