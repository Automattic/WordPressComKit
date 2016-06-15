import Foundation


public class Media {
    public let mediaID: Int
    public let remoteURL: String
    public let size: CGSize

    init(mediaID: Int, remoteURL: String, size: CGSize) {
        self.mediaID = mediaID
        self.remoteURL = remoteURL
        self.size = size
    }
}
