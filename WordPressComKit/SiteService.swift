import Foundation

public class SiteService {
    private var urlSession: NSURLSession!
    
    public init() {
        urlSession = NSURLSession.sharedSession()
    }
    
    public init(urlSession: NSURLSession) {
        self.urlSession = urlSession
    }
    
    public func fetchSite(siteID: Int, completion: (Site?, NSError?) -> Void) {
        let baseURL = NSURL(string: "https://public-api.wordpress.com/rest/v1.1/")!
        let url = NSURL(string: "sites/\(siteID)", relativeToURL: baseURL)!
        
        let urlRequest = NSMutableURLRequest(
            URL: url,
            cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0 * 1000)
        urlRequest.HTTPMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
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
            
            let site = Site()
            site.ID = json!["ID"] as! Int
            site.name = json!["name"] as? String
            site.description = json!["description"] as? String
            site.URL = NSURL(string: json!["URL"] as! String)
            site.jetpack = json!["jetpack"] as! Bool
            site.postCount = json!["post_count"] as! Int
            site.subscribersCount = json!["subscribers_count"] as! Int
            site.language = json!["lang"] as! String
            site.visible = json!["visible"] as! Bool
            site.isPrivate = json!["is_private"] as! Bool
            
            let options = json!["options"] as? [String: AnyObject]
            if let timeZoneName = options?["timezone"] as? String {
                site.timeZone = NSTimeZone(name: timeZoneName)
            }
            
            completion(site, nil)
        }
        
        task.resume()
    }
    
    func fetchSitesForUserID(userID: Int, completion:([Site], NSError?) -> Void) {
    }
}