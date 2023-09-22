
import UIKit

struct Photo {
    
    var imageName: UIImage
    
    static func addPhotos() -> [UIImage] {
        var photos: [UIImage] = []
        for index in 0..<21 {
            index < 9 ? photos.append(UIImage(named: "pic0\(index + 1)")!) : photos.append(UIImage(named: "pic\(index + 1)")!)
        }
        photos += photos
        photos += photos
        return photos
    }
}
