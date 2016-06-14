import Foundation


public class Media {
    let mediaID: Int
    let remoteURL: String
    let size: CGSize

    init(mediaID: Int, remoteURL: String, size: CGSize) {
        self.mediaID = mediaID
        self.remoteURL = remoteURL
        self.size = size
    }
}
