import Foundation
import Alamofire

public enum RequestRouter: URLRequestConvertible {
    static let baseURLString = "https://public-api.wordpress.com/rest/v1.1/"
    // FIXME: This needs to go somewhere better
    public static var bearerToken = ""

    case Me()
    case MediaNew(siteID: Int, attachedImageJPEGData: NSData)
    case Post(postID: Int, siteID: Int)
    case PostNew(siteID: Int, status: String, title: String, body: String, attachedImageJPEGData: NSData?)
    case Site(siteID: Int)
    case Sites(showActiveOnly: Bool)
    
    public var URLRequest: NSMutableURLRequest {
        let result: (path: String, method: Alamofire.Method, parameters: [String: AnyObject]) = {
            switch self {
            case .Me():
                return ("me", .GET, [String: AnyObject]())
            case .MediaNew(let siteID, _):
                return ("sites/\(siteID)/media/new", .POST, [String: AnyObject]())
            case .Post(let postID, let siteID):
                return ("sites/\(siteID)/posts/\(postID)", .GET, [String: AnyObject]())
            case .PostNew(let siteID, let status, let title, let body, _):
                return ("sites/\(siteID)/posts/new", .POST, ["title": title, "content": body, "status": status])
            case .Site(let siteID):
                return ("sites/\(siteID)", .GET, [String: AnyObject]())
            case .Sites(let showActiveOnly):
                return ("me/sites", .GET, ["site_visibility" : showActiveOnly ? "visible" : "all"])
            }
        }()
        
        let URL = NSURL(string: RequestRouter.baseURLString)!
        let request = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(result.path)!)
        request.HTTPMethod = result.method.rawValue
        request.addValue("Bearer \(RequestRouter.bearerToken)", forHTTPHeaderField: "Authorization")
        let encoding = result.method == .POST ? Alamofire.ParameterEncoding.JSON : Alamofire.ParameterEncoding.URL
        
        return encoding.encode(request, parameters: result.parameters).0
    }

    public func loadMultipartFields(multipartFormData: MultipartFormData) {
        switch self {
        case .MediaNew(_, let attachedImageJPEGData):
            multipartFormData.appendBodyPart(data: attachedImageJPEGData, name: "media[]", fileName: MediaSettings.filename, mimeType: MediaSettings.mimeType)
        case .PostNew(_, let status, let title, let body, let attachedImageJPEGData):
            if let attachedImageData = attachedImageJPEGData {
                multipartFormData.appendBodyPart(data: attachedImageData, name: "media[]", fileName: MediaSettings.filename, mimeType: MediaSettings.mimeType)
            }
            if let body = body.dataUsingEncoding(NSUTF8StringEncoding) {
                multipartFormData.appendBodyPart(data: body, name: "content")
            }
            if let title = title.dataUsingEncoding(NSUTF8StringEncoding) {
                multipartFormData.appendBodyPart(data: title, name: "title")
            }
            if let status = status.dataUsingEncoding(NSUTF8StringEncoding) {
                multipartFormData.appendBodyPart(data: status, name: "status")
            }
        default:
            break
        }
    }


    private enum MediaSettings {
        static let filename = "image.jpg"
        static let mimeType = "image/jpeg"
    }
}
