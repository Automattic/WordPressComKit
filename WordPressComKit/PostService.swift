import Foundation
import Alamofire

public class PostService {
    public init() { }
    
    public init(configuration: NSURLSessionConfiguration) {
        manager = Alamofire.Manager(configuration: configuration)
    }
    
    public func fetchPost(postID: Int, siteID: Int, completion: (post: Post?, error: NSError?) -> Void) {
        manager
            .request(RequestRouter.Post(postID: postID, siteID: siteID))
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    completion(post: nil, error: response.result.error)
                    return
                }
                
                let json = response.result.value as! [String: AnyObject]
                
                let post = self.mapJSONToPost(json)
                
                completion(post: post, error: nil)
        }
    }
    
    public func createPost(siteID siteID: Int, status: String, title: String, body: String, completion: (post: Post?, error: NSError?) -> Void) {
        manager
            .request(RequestRouter.PostNew(siteID: siteID, status: status, title: title, body: body))
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    completion(post: nil, error: response.result.error)
                    return
                }
                
                let json = response.result.value as! [String: AnyObject]
                
                let post = self.mapJSONToPost(json)
                
                completion(post: post, error: nil)
        }
    }
    
    func mapJSONToPost(json: [String: AnyObject]) -> Post {
        let post = Post()
        post.ID = json["ID"] as? Int
        post.siteID = json["site_ID"] as! Int
        post.created = convertUTCWordPressComDate(json["date"] as! String)
        if let modifiedDate = json["modified"] as? String {
            post.updated = convertUTCWordPressComDate(modifiedDate)
        }
        post.title = json["title"] as? String
        if let postURL = json["URL"] as? String {
            post.URL = NSURL(string: postURL)!
        }
        if let postShortURL = json["short_URL"] as? String {
            post.shortURL = NSURL(string: postShortURL)!
        }
        post.content = json["content"] as? String
        post.guid = json["guid"] as? String
        post.status = json["status"] as? String
        
        return post
    }
    
    private var manager = Alamofire.Manager.sharedInstance
}
