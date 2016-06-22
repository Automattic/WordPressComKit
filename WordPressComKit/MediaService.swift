import Foundation
import Alamofire


public class MediaService {
    public init() { }

    public init(configuration: NSURLSessionConfiguration) {
        manager = Alamofire.Manager(configuration: configuration)
    }

    public func createMedia(imageURL: NSURL, siteID: Int, completion: ((media: Media?, error: ErrorType?) -> Void)) {

        multipartRequest(imageURL, name: "media[]", siteID: siteID) { (request, error) in
            guard let request = request else {
                completion(media: nil, error: error)
                return
            }

            request.responseJSON { response in
                guard response.result.isSuccess else {
                    completion(media: nil, error: response.result.error)
                    return
                }

                let json = response.result.value as! [String: AnyObject]
                let media = self.mapJSONToMedia(json)

                completion(media: media, error: nil)
            }
        }
    }

    private func mapJSONToMedia(json: [String: AnyObject]) -> Media? {
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

    private func multipartRequest(attachmentURL: NSURL, name: String, siteID: Int, completion: ((request: Request?, error: ErrorType?) -> Void)) {
        let unencodedRequest = RequestRouter.MediaNew(siteID: siteID)

        manager.upload(unencodedRequest, multipartFormData: { multipartFormData in
            multipartFormData.appendBodyPart(fileURL: attachmentURL, name: name)

        }, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .Success(let upload, _, _):
                completion(request: upload, error: nil)
            case .Failure(let error):
                completion(request: nil, error: error)
            }
        })
    }


    private var manager = Alamofire.Manager.sharedInstance
}
