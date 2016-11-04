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
                
                let me = self.meFrom(response.result.value)
                completion(me, nil)
        }
    }
}

//MARK: JSON Parsing
extension MeService {
    
    private func meFrom(jsonValue: AnyObject?) -> Me? {
        
        guard let json = jsonValue as? [String : AnyObject],
            let id = json["ID"] as? Int,
            let userName = json["username"] as? String,
            let verified = json["verified"] as? Bool,
            let emailVerified = json["email_verified"] as? Bool,
            let date = json["date"] as? String,
            let dateCreated = convertUTCWordPressComDate(date),
            let siteCount = json["site_count"] as? Int,
            let visibleSiteCount = json["visible_site_count"] as? Int,
            let hasUnseenNotes = json["has_unseen_notes"] as? Bool,
            let phoneAccount = json["phone_account"] as? Bool else {
                return nil;
        }
        
        let me = Me()
        me.ID = id
        me.username = userName
        me.verified = verified
        me.emailVerified = emailVerified
        me.dateCreated = dateCreated
        me.siteCount = siteCount
        me.visibleSiteCount = visibleSiteCount
        me.hasUnseenNotes = hasUnseenNotes
        me.phoneAccount = phoneAccount
        me.displayName = json["display_name"] as? String
        me.email = json["email"] as? String
        me.language = json["language"] as? String
        me.newestNoteType = json["newest_note_type"] as? String
        
        if let primaryBlogURLPath = json["primary_blog_url"] as? String {
            me.primaryBlogURL = NSURL(string: primaryBlogURLPath)
        }
        
        if let avatarURLPath = json["avatar_URL"] as? String {
            me.avatarURL = NSURL(string: avatarURLPath)
        }
        if let profileURLPath = json["profile_URL"] as? String {
            me.profileURL = NSURL(string: profileURLPath)
        }
        
        return me
    }
}
