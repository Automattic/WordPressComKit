import Foundation
import Alamofire


open class PostService {
    public init() { }
    
    public init(configuration: URLSessionConfiguration) {
        manager = Alamofire.SessionManager(configuration: configuration)
    }
    
    open func fetchPost(_ postID: Int, siteID: Int, completion: @escaping (_ post: Post?, _ error: Error?) -> Void) {
        manager
            .request(RequestRouter.post(postID: postID, siteID: siteID))
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    completion(nil, response.result.error)
                    return
                }
                
                let json = response.result.value as! [String: AnyObject]
                
                let post = self.mapJSONToPost(json)
                
                completion(post, nil)
        }
    }
    
    open func createPost(siteID: Int, status: String, title: String, body: String, attachedImageJPEGData: Data? = nil, requestEqueued: ((Void) -> ())? = nil, completion: @escaping (_ post: Post?, _ error: Error?) -> Void) {
        let request = RequestRouter.postNew(siteID: siteID, status: status, title: title, body: body, attachedImageJPEGData: attachedImageJPEGData)
        manager.encodedMultipartRequest(request) { (request, error) in
            guard let request = request else {
                completion(nil, error)
                return
            }

            request
                .validate()
                .responseJSON { response in
                    guard response.result.isSuccess else {
                        completion(nil, response.result.error)
                        return
                    }
                    
                    let json = response.result.value as! [String: AnyObject]
                    
                    let post = self.mapJSONToPost(json)
                    
                    completion(post, nil)
            }

            requestEqueued?()
        }
    }
    
    func mapJSONToPost(_ json: [String: AnyObject]) -> Post {
        let post = Post()
        post.ID = json["ID"] as? Int
        post.siteID = json["site_ID"] as! Int
        post.created = convertUTCWordPressComDate(json["date"] as! String)
        if let modifiedDate = json["modified"] as? String {
            post.updated = convertUTCWordPressComDate(modifiedDate)
        }
        post.title = json["title"] as? String
        if let postURL = json["URL"] as? String {
            post.URL = URL(string: postURL)!
        }
        if let postShortURL = json["short_URL"] as? String {
            post.shortURL = URL(string: postShortURL)!
        }
        post.content = json["content"] as? String
        post.guid = json["guid"] as? String
        post.status = json["status"] as? String
        
        return post
    }
    
    fileprivate var manager = Alamofire.SessionManager.default
}
