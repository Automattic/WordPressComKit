import Foundation

public class MeService {
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
    
    public func fetchMe(completion: (Me?, NSError?) -> Void) {
        let url = NSURL(string: "me", relativeToURL: wordPressComBaseURL())!
        
        let urlRequest = NSMutableURLRequest(
            URL: url,
            cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0 * 1000)
        urlRequest.HTTPMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTaskWithRequest(urlRequest) { (data, response, error) -> Void in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            var json = try? NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String: AnyObject]
            
            guard json != nil else {
                completion(nil, NSError(domain: "com.automattic.WordPressKit", code: -1000, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Unexpected remote error preventing JSON parsing", comment: "JSON parsing error string")]))
                return
            }
            
            let me = Me()
            me.ID = json!["ID"] as! Int
            me.displayName = json!["display_name"] as? String
            me.username = json!["username"] as! String
            me.email = json!["email"] as? String
            me.primaryBlogID = json!["primary_blog"] as? Int
            if let primaryBlogURLPath = json!["primary_blog_url"] as? String {
                me.primaryBlogURL = NSURL(string: primaryBlogURLPath)
            }
            me.language = json!["language"] as! String
            if let avatarURLPath = json!["avatar_URL"] as? String {
                me.avatarURL = NSURL(string: avatarURLPath)
            }
            if let profileURLPath = json!["profile_URL"] as? String {
                me.profileURL = NSURL(string: profileURLPath)
            }
            me.verified = json!["verified"] as! Bool
            me.emailVerified = json!["email_verified"] as! Bool
            me.dateCreated = convertUTCWordPressComDate(json!["date"] as! String)
            me.siteCount = json!["site_count"] as! Int
            me.visibleSiteCount = json!["visible_site_count"] as! Int
            me.hasUnseenNotes = json!["has_unseen_notes"] as! Bool
            me.newestNoteType = json!["newest_note_type"] as? String
            me.phoneAccount = json!["phone_account"] as! Bool
            
            completion(me, nil)
        }
        
        task.resume()
    }
}