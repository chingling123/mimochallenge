//
//  Utils.swift
//  MimoiOSCodingChallenge
//
//  Created by Erik Nascimento on 4/8/17.
//  Copyright © 2017 Mimohello GmbH. All rights reserved.
//

import Foundation


var userDefault:User!

func removeUserNeededInformation(){
    let d = UserDefaults.standard
    
    d.removeObject(forKey: "userDefault")
    
    d.synchronize()
}

func saveUserNeededInformation(_ user:JSONDictionary){
    
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
