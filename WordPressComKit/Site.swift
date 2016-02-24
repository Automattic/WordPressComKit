import Foundation

public class Site {
    public var ID: Int!
    public var name: String?
    public var description: String?
    public var URL: NSURL!
    public var icon: String?
    public var jetpack = false
    public var postCount = 0
    public var subscribersCount = 0
    public var language = "en"
    public var visible = true
    public var isPrivate = false
    public var timeZone: NSTimeZone!
    
    //    "icon": {"img": "https://secure.gravatar.com/blavatar/6f0ad402b5cbfe40cef23c63488742a7", "ico": "https://secure.gravatar.com/blavatar/1de1e43955ffc6998dbd037cb6fb0440"}
    //    "logo": {"id": 0, "sizes": [], "url": ""}
    //    "options": {"timezone": "America/Chicago", "gmt_offset": -6, "videopress_enabled": true, "upgraded_filetypes_enabled": true, "login_url": "https://astralbodiesnet.wordpress.com/wp-login.php", "admin_url": "https://astralbodiesnet.wordpress.com/wp-admin/" …}
    //    "meta": {"links": {"self": "https://public-api.wordpress.com/rest/v1.1/sites/66592863", "help": "https://public-api.wordpress.com/rest/v1.1/sites/66592863/help", "posts": "https://public-api.wordpress.com/rest/v1.1/sites/66592863/posts/" …} …}
    //    "capabilities": {"edit_pages": true, "edit_posts": true, "edit_others_posts": true, "edit_others_pages": true, "edit_theme_options": true, "edit_users": false, "list_users": true, "manage_categories": true, "manage_options": true …}
    //    "plan": {"product_id": 1003, "product_slug": "value_bundle", "product_name_short": "Premium"}
}