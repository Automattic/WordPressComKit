import Foundation


open class Media {
    open let mediaID: Int
    open let remoteURL: String
    open let size: CGSize

    init(mediaID: Int, remoteURL: String, size: CGSize) {
        self.mediaID = mediaID
        self.remoteURL = remoteURL
        self.size = size
    }
}
