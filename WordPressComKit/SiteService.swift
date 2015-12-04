import Foundation

public class SiteService {
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
    
    public func fetchSite(siteID: Int, completion: (Site?, NSError?) -> Void) {
        let url = NSURL(string: "sites/\(siteID)", relativeToURL: wordPressComBaseURL())!
        
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
    
    public func fetchSites(completion:([Site]?, NSError?) -> Void) {
        let url = NSURL(string: "me/sites", relativeToURL: wordPressComBaseURL())!
        
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
            
            let sitesDictionary = json!["sites"] as! [[String: AnyObject]]

            let sites = sitesDictionary.map({ (siteDictionary) -> Site in
                let site = Site()
                site.ID = siteDictionary["ID"] as! Int
                site.name = siteDictionary["name"] as? String
                site.description = siteDictionary["description"] as? String
                site.URL = NSURL(string: siteDictionary["URL"] as! String)
                site.jetpack = siteDictionary["jetpack"] as! Bool
                site.postCount = siteDictionary["post_count"] as! Int
                site.subscribersCount = siteDictionary["subscribers_count"] as! Int
                site.language = siteDictionary["lang"] as! String
                site.visible = siteDictionary["visible"] as! Bool
                site.isPrivate = siteDictionary["is_private"] as! Bool
                
                let options = siteDictionary["options"] as? [String: AnyObject]
                if let timeZoneName = options?["timezone"] as? String {
                    site.timeZone = NSTimeZone(name: timeZoneName)
                }

                return site
            })
            
            completion(sites, nil)
        }
        
        task.resume()
    }
}