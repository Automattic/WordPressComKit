import Foundation
import Alamofire

public enum RequestRouter: URLRequestConvertible {
    static let baseURLString = "https://public-api.wordpress.com/rest/v1.1/"
    // FIXME: This needs to go somewhere better
    public static var bearerToken = ""

    case me()
    case mediaNew(siteID: Int, attachedImageJPEGData: Data)
    case post(postID: Int, siteID: Int)
    case postNew(siteID: Int, status: String, title: String, body: String, attachedImageJPEGData: Data?)
    case site(siteID: Int)
    case sites(showActiveOnly: Bool)

    public func asURLRequest() throws -> URLRequest {
        let result: (path: String, method: Alamofire.HTTPMethod, parameters: [String: Any]) = {
            switch self {
            case .me():
                return ("me", .get, [String: Any]())
            case .mediaNew(let siteID, _):
                return ("sites/\(siteID)/media/new", .post, [String: Any]())
            case .post(let postID, let siteID):
                return ("sites/\(siteID)/posts/\(postID)", .get, [String: Any]())
            case .postNew(let siteID, let status, let title, let body, _):
                return ("sites/\(siteID)/posts/new", .post, ["title": title, "content": body, "status": status])
            case .site(let siteID):
                return ("sites/\(siteID)", .get, [String: Any]())
            case .sites(let showActiveOnly):
                return ("me/sites", .get, ["site_visibility" : showActiveOnly ? "visible" : "all"])
            }
        }()

        let URL = Foundation.URL(string: RequestRouter.baseURLString)!
        var request = URLRequest(url: URL.appendingPathComponent(result.path))
        request.httpMethod = result.method.rawValue
        request.addValue("Bearer \(RequestRouter.bearerToken)", forHTTPHeaderField: "Authorization")
        let encoding: ParameterEncoding = result.method == .post ? Alamofire.JSONEncoding.default : Alamofire.URLEncoding.default

        return try encoding.encode(request, with: result.parameters)
    }

    public func loadMultipartFields(_ multipartFormData: MultipartFormData) {
        switch self {
        case .mediaNew(_, let attachedImageJPEGData):
            multipartFormData.append(attachedImageJPEGData, withName: "media[]", fileName: MediaSettings.filename, mimeType: MediaSettings.mimeType)
        case .postNew(_, let status, let title, let body, let attachedImageJPEGData):
            if let attachedImageData = attachedImageJPEGData {
                multipartFormData.append(attachedImageData, withName: "media[]", fileName: MediaSettings.filename, mimeType: MediaSettings.mimeType)
            }
            if let body = body.data(using: String.Encoding.utf8) {
                multipartFormData.append(body, withName: "content")
            }
            if let title = title.data(using: String.Encoding.utf8) {
                multipartFormData.append(title, withName: "title")
            }
            if let status = status.data(using: String.Encoding.utf8) {
                multipartFormData.append(status, withName: "status")
            }
        default:
            break
        }
    }


    fileprivate enum MediaSettings {
        static let filename = "image.jpg"
        static let mimeType = "image/jpeg"
    }
}
