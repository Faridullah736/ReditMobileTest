//
//  WebServiceManager.swift


import UIKit
import Alamofire
import SwiftyJSON
import ReachabilitySwift

#if DEBUG

    let serverBaseURL:String = "https://api.github.com/"

#else
    let serverBaseURL:String = "https://api.github.com/search/"
#endif


let apiVersion = "v3/"

enum Endpoint {
    case GithubSearch
    case GithubSearchbyuser(searchStr:String)
    case userfollower(userStr:String)
    case useremail(userStr:String)
    case userfollowing(userStr:String)
    
    func urlString() -> String {
        switch self {
        case .GithubSearch:
            return serverBaseURL + "search/users?q=a"
            
        case .GithubSearchbyuser(searchStr: let userStr):
            return serverBaseURL + "search/users?q=\(userStr)"
            
        case .useremail(userStr: let userStr):
            return serverBaseURL + "search/users?q=\(userStr)"
        case .userfollower(userStr: let userStr):
            return serverBaseURL + "users/\(userStr)/followers"
        case .userfollowing(userStr: let userStr):
            return serverBaseURL + "users/\(userStr)/following"
            
        default:
            fatalError("URL endpoint undefined")
        }
    }
}


class WebServiceManager: NSObject {
    
    typealias ServiceResult = (_ responseData:DataResponse<Any>?, _ error:Error?) -> ()
    
    
    class func call(requestMethod:HTTPMethod, serviceURL:String, params:[String: AnyObject]?, includeAccessToken:Bool = true, completion:@escaping ServiceResult) -> DataRequest? {
        
        let reachability = Reachability()
        if reachability?.isReachable == false {
            let userInfo: [NSObject : AnyObject] =
                [
                    NSLocalizedDescriptionKey as NSObject :  NSLocalizedString("Reachability error", value: "Network unavailable", comment: "") as AnyObject,
                    NSLocalizedFailureReasonErrorKey as NSObject : NSLocalizedString("Reachability Error", value: "Network unavailable", comment: "") as AnyObject
            ]
            let err = NSError(domain: "Error Description", code: 3000, userInfo: userInfo as? [String : Any])
            completion(nil, err)
            return nil
        }
        
        let headers : HTTPHeaders? = nil
    
       
        
        return Alamofire.request(serviceURL, method: requestMethod, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseData) in
            completion(responseData, nil)
        }
    }
    
    class func call(requestMethod:HTTPMethod, serviceURL:String, params:[String: AnyObject]?, multipartData:[String: AnyObject], includeAccessToken:Bool = true, completion:@escaping ServiceResult) {
        
        let reachability = Reachability()
        if reachability?.isReachable == false {
            let userInfo: [NSObject : AnyObject] =
                [
                    NSLocalizedDescriptionKey as NSObject :  NSLocalizedString("Reachability error", value: "Network unavailable", comment: "") as AnyObject,
                    NSLocalizedFailureReasonErrorKey as NSObject : NSLocalizedString("Reachability Error", value: "Network unavailable", comment: "") as AnyObject
            ]
            let err = NSError(domain: "Error Description", code: 3000, userInfo: userInfo as? [String : Any])
            completion(nil, err)

            return
        }
        
        let headers : HTTPHeaders? = nil
     
        let URL = try! URLRequest(url: serviceURL, method: requestMethod, headers: headers)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            // code
            for (key, value) in multipartData {
                if let imageData = value as? Data {
                    multipartFormData.append(imageData, withName: key, fileName: "file.jpeg", mimeType: "image/jpeg")
                }
            }
            
            for (key, value) in params! {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
        }, with: URL, encodingCompletion: { (result) in
            // code
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    completion(response, nil)
                }
                
                case .failure(let encodingError):
                    completion(nil, encodingError)
            }
        })
    }
    
    class func cancel(request:Any?) {
        if let obj = request as? DataRequest {
            obj.cancel()
        }
    }
}
