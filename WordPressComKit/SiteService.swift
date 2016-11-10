import Foundation
import Alamofire

open class SiteService {
    public init() {}
    
    open func fetchSite(_ siteID: Int, completion: @escaping (Site?, NSError?) -> Void) {
        Alamofire
            .request(RequestRouter.site(siteID: siteID))
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    completion(nil, response.result.error as NSError?)
                    return
                }
                
                let json = response.result.value as? [String: AnyObject]
                let site = self.mapJSONToSite(json!)
                
                completion(site, nil)
        }
    }
    
    open func fetchSites(_ showActiveOnly: Bool = true, completion:@escaping ([Site]?, NSError?) -> Void) {
        Alamofire
            .request(RequestRouter.sites(showActiveOnly: showActiveOnly))
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    completion(nil, response.result.error as NSError?)
                    return
                }
                
                let json = response.result.value as? [String: AnyObject]
                let sitesDictionary = json!["sites"] as! [[String: AnyObject]]
                
                let sites = sitesDictionary.map(self.mapJSONToSite)
                
                completion(sites, nil)
        }
    }
    
    func mapJSONToSite(_ json: [String: AnyObject]) -> Site {
        let site = Site()
        
        let rawIcon = json["icon"] as? NSDictionary
        
        site.ID = json["ID"] as! Int
        site.name = json["name"] as? String
        site.description = json["description"] as? String
        site.URL = URL(string: json["URL"] as! String)
        site.icon = rawIcon?["img"] as? String
        site.jetpack = json["jetpack"] as! Bool
        site.postCount = json["post_count"] as! Int
        site.subscribersCount = json["subscribers_count"] as! Int
        site.language = json["lang"] as! String
        site.visible = json["visible"] as! Bool
        site.isPrivate = json["is_private"] as! Bool
        
        let options = json["options"] as? [String: AnyObject]
        if let timeZoneName = options?["timezone"] as? String {
            site.timeZone = TimeZone(identifier: timeZoneName)
        }
        
        return site
    }
}
