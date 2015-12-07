import Foundation
import Alamofire

public class PostService {
    private var bearerToken: String
    private var urlSession: NSURLSession
    
    convenience public init() {
        self.init(bearerToken: "", urlSession: NSURLSession.sharedSession())
    }
    
    convenience public init(urlSession: NSURLSession) {
        self.init(bearerToken: "", urlSession: urlSession)
    }
    
    public init(bearerToken: String, urlSession: NSURLSession) {
        self.bearerToken = bearerToken
        self.urlSession = urlSession
    }
    
    public func fetchPost(postID: Int, siteID: Int, completion: (Post?, NSError?) -> Void) {
        Alamofire
            .request(RequestRouter.Post(postID: postID, siteID: siteID))
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    completion(nil, response.result.error)
                    return
                }
                
                let json = response.result.value as? [String: AnyObject]
                
                let post = Post()
                post.ID = json!["ID"] as? Int
                post.siteID = json!["site_ID"] as! Int
                post.created = convertUTCWordPressComDate(json!["date"] as! String)
                if let modifiedDate = json!["modified"] as? String {
                    post.updated = convertUTCWordPressComDate(modifiedDate)
                }
                post.title = json!["title"] as? String
                if let postURL = json!["URL"] as? String {
                    post.URL = NSURL(string: postURL)!
                }
                if let postShortURL = json!["short_URL"] as? String {
                    post.shortURL = NSURL(string: postShortURL)!
                }
                post.content = json!["content"] as? String
                post.guid = json!["guid"] as? String
                post.status = json!["status"] as? String
                
                completion(post, nil)
        }
    }
    
    public func createPost(siteID siteID: Int, title: String, body: String, completion: (post: Post?, error: NSError?) -> Void) {
        let url = NSURL(string: "sites/\(siteID)/posts/new", relativeToURL: wordPressComBaseURL())!
        
        let urlRequest = NSMutableURLRequest(
            URL: url,
            cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0 * 1000)
        urlRequest.HTTPMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let requestBody = ["title": title, "content": body]
        urlRequest.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(requestBody, options: [])
        
        let task = urlSession.dataTaskWithRequest(urlRequest) { (data, response, error) -> Void in
            guard error == nil else {
                completion(post: nil, error: error)
                return
            }
            
            var json = try? NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String: AnyObject]
            
            guard json != nil else {
                completion(post: nil, error: NSError(domain: "com.automattic.WordPressKit", code: -1000, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Unexpected remote error preventing JSON parsing", comment: "JSON parsing error string")]))
                return
            }
            
            let post = Post()
            post.ID = json!["ID"] as? Int
            post.siteID = json!["site_ID"] as! Int
            post.created = convertUTCWordPressComDate(json!["date"] as! String)
            if let modifiedDate = json!["modified"] as? String {
                post.updated = convertUTCWordPressComDate(modifiedDate)
            }
            post.title = json!["title"] as? String
            if let postURL = json!["URL"] as? String {
                post.URL = NSURL(string: postURL)!
            }
            if let postShortURL = json!["short_URL"] as? String {
                post.shortURL = NSURL(string: postShortURL)!
            }
            post.content = json!["content"] as? String
            post.guid = json!["guid"] as? String
            post.status = json!["status"] as? String
            
            completion(post: post, error: nil)
        }
        
        task.resume()
    }
}