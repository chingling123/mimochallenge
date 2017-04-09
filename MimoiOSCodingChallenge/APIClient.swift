//
//  APIClient.swift
//  MimoiOSCodingChallenge
//
//  Created by Erik Nascimento on 4/8/17.
//  Copyright © 2017 Mimohello GmbH. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: AnyObject]

typealias JSONArray = Array<AnyObject>

struct ApiClient {
    
    fileprivate var serverUrl:String
    fileprivate var contentType:String
    fileprivate var client_id:String
    fileprivate var connection:String
    fileprivate var grant_type:String
    fileprivate var scope:String
    
    init(contentType:String, customUrl:String?){
        self.contentType = contentType
        self.client_id = "PAn11swGbMAVXVDbSCpnITx5Utsxz1co"
        self.connection = "Username-Password-Authentication"
        self.serverUrl = "https://mimo-test.auth0.com/"
        self.grant_type = "password"
        self.scope = "openid profile email"
        if customUrl != nil {
            self.serverUrl = customUrl!
        }
    }
    
    // MARK: private composition methods
    
    fileprivate func post(_ request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        DataTask(request, method: "POST", completion: completion)
    }
    
    fileprivate func put(_ request: NSMutableURLRequest, completion:@escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        DataTask(request, method: "PUT", completion: completion)
    }
    
    fileprivate func get(_ request: NSMutableURLRequest, completion:@escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        DataTask(request, method: "GET", completion: completion)
    }
    
    fileprivate func DataTask(_ request: NSMutableURLRequest, method: String, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        request.httpMethod = method
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        
        session.dataTask(with: request as URLRequest) { (data, response, error) in
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                        completion(true, json as AnyObject)
                    } else {
                        completion(false, json as AnyObject)
                    }
                }
            }.resume()
    }
    
    fileprivate func clientURLRequest(_ path: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: URL(string: serverUrl+path)!)
        print(request.url?.absoluteString as Any)
        if let params = params {
            var paramString = ""
            for (key, value) in params {
                
                let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let escapedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                paramString += "\(escapedKey!)=\(escapedValue!)&"
                
            }
            
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            request.httpBody = paramString.data(using: String.Encoding.utf8)
        }
        
        return request
    }
    
    fileprivate func clientURLRequestJSON(_ path: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: URL(string: serverUrl+path)!)
        if let params = params {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        }
        
        return request
    }
    
    // MARK: public methods
    
    internal func login(_ email: String, password: String, completion: @escaping (_ success: Bool, _ message: JSONDictionary?) -> ()) {
        let loginObject = ["username": email, "password": password, "client_id":client_id, "connection":connection, "grant_type":grant_type, "scope":scope]
        
        post(clientURLRequestJSON("oauth/ro", params: loginObject as Dictionary<String, AnyObject>)) { (success, object) -> () in
            DispatchQueue.main.async(execute: { () -> Void in
                completion(success, object as? JSONDictionary)
            })
        }
    }
    
    internal func signUp(_ email: String, password: String, completion: @escaping(_ success: Bool, _ message: JSONDictionary?) ->()){
        let signUpObject = ["email": email, "password": password, "client_id":client_id, "connection":connection]
        
        post(clientURLRequestJSON("dbconnections/signup", params: signUpObject as Dictionary<String, AnyObject>)) { (success, object) -> () in
            DispatchQueue.main.async(execute: { () -> Void in
                completion(success, object as? JSONDictionary)
            })
        }
    }
    
}
