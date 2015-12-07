import Foundation
import Alamofire

enum RequestRouter: URLRequestConvertible {
    static let baseURLString = "https://public-api.wordpress.com/rest/v1.1/"
    static var bearerToken = ""

    case Me()
    case Post(postID: Int, siteID: Int)
    case PostNew(siteID: Int, title: String, body: String)
    case Site(siteID: Int)
    case Sites()
    
    var URLRequest: NSMutableURLRequest {
        let result: (path: String, method: Alamofire.Method, parameters: [String: AnyObject]) = {
            switch self {
            case .Me():
                return ("me", .GET, [String: AnyObject]())
            case .Post(let postID, let siteID):
                return ("sites/\(siteID)/posts/\(postID)", .GET, [String: AnyObject]())
            case .PostNew(let siteID, let title, let body):
                return ("sites/\(siteID)/posts/new", .POST, ["title": title, "content": body])
            case .Site(let siteID):
                return ("sites/\(siteID)", .GET, [String: AnyObject]())
            case .Sites():
                return ("me/sites", .GET, [String: AnyObject]())
            }
        }()
        
        let URL = NSURL(string: RequestRouter.baseURLString)!
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
        URLRequest.HTTPMethod = result.method.rawValue
        URLRequest.addValue("Bearer \(RequestRouter.bearerToken)", forHTTPHeaderField: "Authentication")
        let encoding = result.method == .POST ? Alamofire.ParameterEncoding.JSON : Alamofire.ParameterEncoding.URL
        
        return encoding.encode(URLRequest, parameters: result.parameters).0
    }
}