//
//  Utils.swift
//  MimoiOSCodingChallenge
//
//  Created by Erik Nascimento on 4/8/17.
//  Copyright © 2017 Mimohello GmbH. All rights reserved.
//

import Foundation

@objc class Utils: NSObject{
    
    static let sharedInstance = Utils()
    
    func removeUserNeededInformation() -> Void{
        let d = UserDefaults.standard
        
        d.removeObject(forKey: "userDefault")
        d.removeObject(forKey: "DarkMode")
        
        d.synchronize()
    }
    
    func setDarkMode(_ isOn:Bool) -> Void{
        let d = UserDefaults.standard
        
        d.set(isOn, forKey: "DarkMode")
        
        d.synchronize()
    }

    func isOnDarkMode() -> Bool{
        let d = UserDefaults.standard
        
        if let hasData = d.object(forKey: "DarkMode") as? Bool{
            return hasData
        }else{
            return false
        }
    }
    
    func saveUserNeededInformation(_ user:JSONDictionary) -> Void{
        
        let d = UserDefaults.standard
        
        let userData = NSKeyedArchiver.archivedData(withRootObject: user)
        
        d.set(userData, forKey: "userDefault")
        
        d.synchronize()
    }
    
    func loadUserNeededInformation() -> User?{
        
        let d = UserDefaults.standard
        
        if let hasData = d.object(forKey: "userDefault") as? Data {
            if let hasUser = NSKeyedUnarchiver.unarchiveObject(with: hasData) as? JSONDictionary{
                return User(data: hasUser)
            }
        }
        return nil
    }
    
    func MD5(string: String) -> String {
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return "\(digestData.map { String(format: "%02hhx", $0) }.joined())"
    }
}
