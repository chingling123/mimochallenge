//
//  User.swift
//  MimoiOSCodingChallenge
//
//  Created by Erik Nascimento on 4/8/17.
//  Copyright © 2017 Mimohello GmbH. All rights reserved.
//

import Foundation

struct User {
    
    var token_type:String!
    var id_token:String!
    var access_token:String!
    var email:String!
    var email_verified:Bool?
    var _id:String?
    
    init(data:JSONDictionary){
        
        if let email_verified = data["email_verified"] as? Bool {
            self.email_verified = email_verified
        }
        
        if let _id = data["_id"] as? String {
            self._id = _id
        }
        
        if let token_type = data["token_type"] as? String {
            self.token_type = token_type
        }
        
        if let id_token = data["id_token"] as? String {
            self.id_token = id_token
        }
        
        if let access_token = data["access_token"] as? String {
            self.access_token = access_token
        }
        
        if let email = data["email"] as? String {
            self.email = email
        }
        
        saveUserNeededInformation(data)
        
    }
}
