import Foundation
import Alamofire


open class MediaService {
    public init() { }

    public init(configuration: URLSessionConfiguration) {
        manager = Alamofire.SessionManager(configuration: configuration)
    }

    open func createMedia(_ attachedImageJPEGData: Data, siteID: Int, completion: @escaping ((_ media: Media?, _ error: Error?) -> Void)) {
        let request = RequestRouter.mediaNew(siteID: siteID, attachedImageJPEGData: attachedImageJPEGData)
        manager.encodedMultipartRequest(request) { (request, error) in
            guard let request = request else {
                completion(nil, error)
                return
            }

            request.responseJSON { response in
                guard response.result.isSuccess else {
                    completion(nil, response.result.error)
                    return
                }

                let json = response.result.value as! [String: AnyObject]
                let media = self.mapJSONToMedia(json)

                completion(media, nil)
            }
        }
    }

    fileprivate func mapJSONToMedia(_ json: [String: AnyObject]) -> Media? {
        guard let rawMediaList = json["media"] as? [[String: AnyObject]],
            let rawMedia = rawMediaList.first,
            let mediaID = rawMedia["ID"] as? Int,
            let mediaURL = rawMedia["URL"] as? String,
            let width = rawMedia["width"] as? Int,
            let height = rawMedia["height"] as? Int else
        {
            return nil
        }

        let size = CGSize(width: width, height: height)
        return Media(mediaID: mediaID, remoteURL: mediaURL, size: size)
    }

    fileprivate var manager = Alamofire.SessionManager.default
}
