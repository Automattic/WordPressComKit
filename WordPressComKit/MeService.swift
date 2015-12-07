import Foundation
import Alamofire

public class MeService {
    public init() {}
    
    public func fetchMe(completion: (Me?, NSError?) -> Void) {
        Alamofire
            .request(RequestRouter.Me())
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    completion(nil, response.result.error)
                    return
                }
                
                let json = response.result.value as? [String: AnyObject]
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
    }
}