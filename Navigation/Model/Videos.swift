
import Foundation

struct Videos {
    var name: String
    var videoCode: String
    
    static func load() -> [Videos] {
        var videos: [Videos] = []
        videos.append(Videos(name: "Star Wars Outlaws: World - Trailer", videoCode: "XF0kMT39GNY"))
        videos.append(Videos(name: "Star Wars IV - Trailer", videoCode: "XHk5kCIiGoM"))
        videos.append(Videos(name: "The Acolyte (2024) - Teaser", videoCode: "ZlncRXJf2so"))
        return videos
    }
    
    static func load1() -> [Videos] {
        var videos: [Videos] = []
        videos.append(Videos(name: "Star Wars Ashoka - Trailer", videoCode: "ashoka"))
        videos.append(Videos(name: "Star Wars: The Clone Wars - Trailer", videoCode: "clonewars"))
        return videos
    }
}
