//
//  User.swift
//  Kadir
//
//  Created by Waqas on 10/11/2017.
//  Copyright © 2017 Waqas Rasheed. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static var userID:String {
        get{
            if ( UserDefaults.standard.object(forKey: "userID") != nil)
            {
                return UserDefaults.standard.object(forKey: "userID") as! String
            }
            else
            {
                return " "
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "userID")
        }
    }
    
    static var userResidentCardNo:String {
        get{
            if ( UserDefaults.standard.object(forKey: "residentCardNo") != nil)
            {
                return UserDefaults.standard.object(forKey: "residentCardNo") as! String
            }
            else
            {
                return " "
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "residentCardNo")
        }
    }
    
    
    static var userName:String {
        get{
            if ( UserDefaults.standard.object(forKey: "userName") != nil)
            {
                return UserDefaults.standard.object(forKey: "userName") as! String
            }
            else
            {
                return " "
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "userName")
        }
    }
    
    
    static var recentCookie:HTTPCookie? {
        get{
            if ( UserDefaults.standard.object(forKey: "recentCookie") != nil)
            {
                
                return HTTPCookie(properties: (UserDefaults.standard.object(forKey: "recentCookie") as? [HTTPCookiePropertyKey:Any])!)
            }
            else
            {
                return nil
            }
        }
        set{
            UserDefaults.standard.set(newValue?.properties, forKey: "recentCookie")
        }
    }
    
    static var deviceToken:String {
        get{
            if ( UserDefaults.standard.object(forKey: "deviceToken") != nil)
            {
                return UserDefaults.standard.object(forKey: "deviceToken") as! String
            }
            else
            {
                return " "
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "deviceToken")
        }
    }
    
    static var profileImgUrl:String {
        get{
            if ( UserDefaults.standard.object(forKey: "profileImgUrl") != nil)
            {
                return UserDefaults.standard.object(forKey: "profileImgUrl") as! String
            }
            else
            {
                return " "
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "profileImgUrl")
        }
    }
    
    
    static var firstName:String {
        get{
            if ( UserDefaults.standard.object(forKey: "firstName") != nil)
            {
                return UserDefaults.standard.object(forKey: "firstName") as! String
            }
            else
            {
                return " "
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "firstName")
        }
    }
    
    static var lastName:String {
        get{
            if ( UserDefaults.standard.object(forKey: "lastName") != nil)
            {
                return UserDefaults.standard.object(forKey: "lastName") as! String
            }
            else
            {
                return " "
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "lastName")
        }
    }
    
    static var email:String {
        get{
            if ( UserDefaults.standard.object(forKey: "email") != nil)
            {
                return UserDefaults.standard.object(forKey: "email") as! String
            }
            else
            {
                return " "
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "email")
        }
    }
    
    static var phoneNumber:String {
        get{
            if ( UserDefaults.standard.object(forKey: "phoneNumber") != nil)
            {
                return UserDefaults.standard.object(forKey: "phoneNumber") as! String
            }
            else
            {
                return " "
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "phoneNumber")
        }
    }
    
    static var countryCode:String {
        get{
            if ( UserDefaults.standard.object(forKey: "countryCode") != nil)
            {
                return UserDefaults.standard.object(forKey: "countryCode") as! String
            }
            else
            {
                return " "
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "countryCode")
        }
    }
    
    static var password:String {
        get{
            if ( UserDefaults.standard.object(forKey: "password") != nil)
            {
                return UserDefaults.standard.object(forKey: "password") as! String
            }
            else
            {
                return " "
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "password")
        }
    }
    
    static var driverId:String {
        get{
            if ( UserDefaults.standard.object(forKey: "driverId") != nil)
            {
                return UserDefaults.standard.object(forKey: "driverId") as! String
            }
            else
            {
                return " "
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "driverId")
        }
    }
    
    
    
    static var userRoles:[String] {
        get{
            if ( UserDefaults.standard.object(forKey: "userRoles") != nil)
            {
                return UserDefaults.standard.object(forKey: "userRoles") as! Array
            }
            else
            {
                return [];
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "userRoles")
        }
    }

    static var userSpecialization:Array<String> {
        get{
            if ( UserDefaults.standard.object(forKey: "Specialization") != nil)
            {
                return UserDefaults.standard.object(forKey: "Specialization") as! Array
            }
            else
            {
                return [];
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "Specialization")
        }
    }
    
    
    static var userAccessToken:AccessTokenModel = AccessTokenModel()
    
    static var userRefreshAccessToken:RefreshAccessTokenModel = RefreshAccessTokenModel()
    
    static func removeSaveData()
    {
        let arrUserInfoKeys = ["userName","firstName","lastName","password","driverId","userRoles","userID"];
        
        for keys in arrUserInfoKeys {
            UserDefaults.standard.removeObject(forKey: keys)
        }
        UserDefaults.standard.synchronize()
    }
    
    
    static var isAvailable:Bool {
        get{
            
            return UserDefaults.standard.bool(forKey: "isAvailable")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isAvailable")
            
        }
    }
    
    
    
}

class AccessTokenModel:NSObject {
    var accessToken:String {
        get{
            if ( UserDefaults.standard.object(forKey: "accessToken") != nil)
            {
                return UserDefaults.standard.object(forKey: "accessToken") as! String
            }
            else
            {
                return " "
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "accessToken")
        }
    }
    
    var accessTokenID:String {
        get{
            if ( UserDefaults.standard.object(forKey: "accessTokenID") != nil)
            {
                return UserDefaults.standard.object(forKey: "accessTokenID") as! String
            }
            else
            {
                return " "
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "accessTokenID")
        }
    }
    
    var expireDate:String {
        get{
            if ( UserDefaults.standard.object(forKey: "expireDate") != nil)
            {
                return UserDefaults.standard.object(forKey: "expireDate") as! String
            }
            else
            {
                return " "
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "expireDate")
        }
    }
    
    
    static func removeSaveData()
    {
        let arrUserInfoKeys = ["expireDate","accessTokenID","accessToken"];
        
        for keys in arrUserInfoKeys {
            UserDefaults.standard.removeObject(forKey: keys)
        }
        UserDefaults.standard.synchronize()
    }
    
    
}




class RefreshAccessTokenModel:NSObject {
    var refreshAccessToken:String {
        get{
            if ( UserDefaults.standard.object(forKey: "refreshAccessToken") != nil)
            {
                return UserDefaults.standard.object(forKey: "refreshAccessToken") as! String
            }
            else
            {
                return " "
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "refreshAccessToken")
        }
    }
    
    var refreshAccessTokenID:String {
        get{
            if ( UserDefaults.standard.object(forKey: "refreshAccessTokenID") != nil)
            {
                return UserDefaults.standard.object(forKey: "refreshAccessTokenID") as! String
            }
            else
            {
                return " "
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "refreshAccessTokenID")
        }
    }
    
    var expireDateRefreshToken:String {
        get{
            if ( UserDefaults.standard.object(forKey: "expireDateRefreshToken") != nil)
            {
                return UserDefaults.standard.object(forKey: "expireDateRefreshToken") as! String
            }
            else
            {
                return " "
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "expireDateRefreshToken")
        }
    }
    
    static func removeSaveData()
    {
        let arrUserInfoKeys = ["expireDateRefreshToken","refreshAccessTokenID","refreshAccessToken"];
        
        for keys in arrUserInfoKeys {
            UserDefaults.standard.removeObject(forKey: keys)
        }
        UserDefaults.standard.synchronize()
    }
    
    
}

