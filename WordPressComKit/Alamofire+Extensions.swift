import Foundation
import Alamofire


/// Alamofire.Manager Helper Methods
///
extension Alamofire.Manager
{
    public func encodedMultipartRequest(request: RequestRouter, completion: ((request: Request?, error: ErrorType?) -> Void)) {
        upload(request, multipartFormData: { multipartFormData in
            request.loadMultipartFields(multipartFormData)

        }, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .Success(let upload, _, _):
                completion(request: upload, error: nil)
            case .Failure(let error):
                completion(request: nil, error: error)
            }
        })
    }
}
