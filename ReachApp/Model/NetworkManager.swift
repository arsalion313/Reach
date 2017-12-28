//
//  NetworkManager.swift
//  Kadir
//
//  Created by Muhammad Arslan Khalid on 09/11/2017.
//  Copyright © 2017 Muhammad Arslan Khalid. All rights reserved.
//
import UIKit

import MobileCoreServices

public typealias serviceCompletionHandler = (_ result:[String:Any]?,_ errorTitle:String? ,_ errorDescription:String? ) ->Void
public typealias imgserviceCompletionHandler = (_ image:UIImage?,_ errorTitle:String? ,_ errorDescription:String? ) ->Void
public typealias imagePickerCompletionHandler = (_ image:UIImage?,_ errorTitle:String? ,_ errorDescription:String? ) ->Void
enum ServiceType:String {
    case POST = "POST"
    case GET = "GET"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

//let baseUrl = "http://meera.targetsfo.tk/graphql/debug"
//let imgbaseUrl = "http://meera.targetsfo.tk/rest"

let baseUrl = "https://reach.digitalenergycloud.com/graphql"


//import AlamofireImage
//import Alamofire
class NetworkManager: NSObject {
    
    static let sharedInstance = NetworkManager()
    var recentCookie:[String:Any]?
    var recentAppCookie:HTTPCookie!
    var reloginTry = 0;
    
    
    
    func asynchronousWorkWithURL(_ baseUrlStr:String,_ serviceType:ServiceType,_ parameters:[String:Any]?,_ delegate:UIViewController?,needToGetCookie isGetCookie:Bool,withCompletionhandler completion:@escaping serviceCompletionHandler) -> Void
    {
        
        let mainUrl:URL = URL(string: baseUrlStr)!
        var request = URLRequest(url: mainUrl)
        request.httpMethod = serviceType.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let reqCookie = User.recentCookie
        {
            HTTPCookieStorage.shared.setCookie(reqCookie)
        }
        
        if let parameters = parameters
        {
            
            do
            {
                let data = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
                let strData = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                
                print("Body: \(String(describing: strData))")
                request.httpBody =  data
                
            }
            catch
            {}
            
        }
        
        //let session  = URLSession(configuration: URLSessionConfiguration.default)
        
        if (User.recentCookie == nil)
        {
            let cookieStore = HTTPCookieStorage.shared
            for cookie in cookieStore.cookies ?? [] {
                cookieStore.deleteCookie(cookie)
            }
        }
        
        let session  = URLSession.shared;
        let task =  session.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                
                if let _  = error
                {
                    completion(nil,"Server Error",(error! as NSError).debugDescription)
                    
                    return
                }
                
                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode != 200
                {
                    print(httpResponse?.statusCode as Any);
                    
                    if httpResponse?.statusCode == 401
                    {
                        User.recentCookie = nil
                        
                        let cookieStore = HTTPCookieStorage.shared
                        for cookie in cookieStore.cookies ?? [] {
                            cookieStore.deleteCookie(cookie)
                        }
                        
                        if self.reloginTry < 2
                        {
                            self.reloginTry = self.reloginTry + 1
                            NetworkManager.sharedInstance.reLoginTechnique(WithServiceParameter: parameters, completionHandler: completion, WithServiceType: serviceType, WithDelegateControlelr: delegate)
                        }
                        else
                        {
                            ReachUTIL.sharedInstance.showLoginController(delegateController: delegate);
                        }
                    }
                    else if httpResponse?.statusCode == 500
                    {
                        ReachUTIL.sharedInstance.displayAlert(withTitle: "Error", andMessage: "Internal Server Error", delegate)
                        completion(nil,"Server Error","Internal Server Error")
                    }
                    else
                    {
                        // error other than 401
                        
                        //presetn login controller
                        ReachUTIL.sharedInstance.showLoginController(delegateController: delegate);
                    }
                    
                }
                else
                {
                    guard let _ = data else{
                        
                        completion(nil, "Server Error", "Got Response Nill");
                        
                        return
                    }
                    
                    if isGetCookie
                    {
                        self.reloginTry = 0
                        let fields = httpResponse?.allHeaderFields as? [String : String]
                        let cookies =  HTTPCookie.cookies(withResponseHeaderFields: fields!, for: response!.url!)
                        
                        if(cookies.count > 0)
                        {
                            User.recentCookie = cookies[0]
                            
                            //var cookieProperties = [String: Any]()
                            for cookie in cookies {
                                HTTPCookieStorage.shared.setCookie(cookie)
                            }
                        }
                        
                    }
                    
                    
                    
                    let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    
                    
                    print("Body: \(String(describing: strData))")
                    
                    do
                    {
                        var jsonResult:Any?
                        
                        jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                        
                        let parseJson = jsonResult as! [String:Any]
                        let graphQLError = parseJson["errors"] as? [String]
                        
                        if  let _ = graphQLError
                        {
                            if (graphQLError!.count > 0)
                            {
                                print(graphQLError![0])
                                
                                //KadirUTIL.sharedInstance.displayAlert(withTitle: "GraphQL Error", andMessage: graphQLError![0], delegate);
                                
                                completion(nil, "GraphQL Error", graphQLError![0]);
                                
                                return;
                            }
                        }
                        
                        
                        
                        
                        if let _ = jsonResult
                        {
                            completion(jsonResult as? [String:AnyObject], nil, nil)
                        }
                        else
                        {
                            completion(nil, "Json Parsin Error", "Json parsing issue")
                        }
                    }
                    catch
                    {
                        completion(nil, "Json Parsin Error", "Json parsing issue")
                    }
                }
            }
        }
        task.resume()
    }
    
    func reLoginTechnique(WithServiceParameter previousParameter:[String:Any]?, completionHandler:@escaping serviceCompletionHandler, WithServiceType serviceTypePrevious:ServiceType, WithDelegateControlelr delegateController:UIViewController?)
    {
        
        var  inputParam = [String:Any]()
        inputParam["name"] = "mohsin"
        inputParam["password"] = "123456"
        
        let query = "mutation {User {login(username: \(User.userName), password: \(User.password)){username _id,username,firstName,lastName,email,mobileNumber}}}";
        
        var parameter = [String:Any]();
        parameter["query"] = "";//LoginQuery;
        parameter["variables"] = NetworkManager.sharedInstance.getJsonStringForVariable(inputParam)
        
        NetworkManager.sharedInstance.asynchronousWorkWithURL(baseUrl, ServiceType.POST, parameter, nil, needToGetCookie: true) { (result, errorTitle, errorType) in
            
            
            NetworkManager.sharedInstance.asynchronousWorkWithURL(baseUrl, serviceTypePrevious, previousParameter ?? nil,delegateController , needToGetCookie: false, withCompletionhandler: completionHandler)
        }
    }
    
    func getJsonStringForVariable(_ parameter:[String:Any]) -> NSString
    {
        do{
            let data = try JSONSerialization.data(withJSONObject: parameter, options: JSONSerialization.WritingOptions.prettyPrinted)
            let strData = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            return strData!
        }
        catch
        {
            return NSString();
        }
        
    }
    
    
    
    
    func reLoginTechniqueForImg(_ baseUrlImg:URL, completionHandler:@escaping imgserviceCompletionHandler, WithServiceType serviceTypePrevious:ServiceType)
    {
        
        var  inputParam = [String:Any]()
        inputParam["name"] = User.userName
        inputParam["password"] = User.password
        
        var parameter = [String:Any]();
        parameter["query"] = ""//LoginQuery;
        parameter["variables"] = NetworkManager.sharedInstance.getJsonStringForVariable(inputParam)
        
        NetworkManager.sharedInstance.asynchronousWorkWithURL(baseUrl, ServiceType.POST, parameter, nil, needToGetCookie: true) { (result, errorTitle, errorType) in
            
            
           // NetworkManager.sharedInstance.asynchronousWorkWithURL(baseUrlImg, serviceTypePrevious, withCompletionhandler: completionHandler)
        }
        
        
    }
    
}






