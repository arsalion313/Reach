//
//  ReachUTIL.swift
//  ReachApp
//
//  Created by Waqas on 27/12/2017.
//  Copyright © 2017 Waqas. All rights reserved.
//

import UIKit

class ReachUTIL: NSObject {

    @objc static let sharedInstance = ReachUTIL()
    let reachability = Reachability()!
    @objc var isRightToLeftLayout:Bool = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override init() {
        
        print("ReachUTIL Init");
       
    }
    
    func hasValidText(_ text:String?) -> Bool
    {
        //func hasValidText(_ text:String?, ValidTextWithwhitespacesAndNewlines whitespacesAndNewline: Bool) -> Bool
        
        if let data = text
        {
            let str = data.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            if (str.count > 0)
            {
                return true
            }
            else
            {
                return false
            }
        }
        else
        {
            return false
        }
        
    }
    
    static func LocalizeString(key: String) -> String
    {
        return Bundle.main.localizedString(forKey: key, value: "", table: "KadirLocalizeFile")
    }
    
    func isEmail(_ email:AnyObject  ) -> Bool
    {
        let strEmailMatchstring = "\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"
        let regExPredicate = NSPredicate(format: "SELF MATCHES %@", strEmailMatchstring)
        
        if(!isEmpty(email) && regExPredicate.evaluate(with: email))
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    func isEmpty(_ thing : AnyObject? )->Bool {
        
        
        if(thing as? Data == nil)
        {
            return false;
        }
        else if (thing == nil)
        {
            return false
        }
        else if ((thing as! Data).count == 0)
        {
            return false
        }
        else if((thing! as! NSArray).count == 0)
        {
            return false
        }
        return true;
        
        
    }
    
    func displayAlert(withTitle title: String?, andMessage message: String!,_ delegate:UIViewController!) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil));
        DispatchQueue.main.async {
            delegate.present(alert, animated: true, completion: nil);
        }
    }
    
    
    func setNavHeightForIPhoneX(navHightRef navRef: NSLayoutConstraint)
    {
        if(ReachUTIL.sharedInstance.isIPhoneX() == true)
        {
            navRef.constant = 88;
        }
    }
    
    func isIPhoneX() -> Bool
    {
        if (UIDevice().userInterfaceIdiom == .phone)
        {
            let screenHight =  UIScreen.main.nativeBounds.height;
            
            if(screenHight >= 2436)
            {
                return true;
            }
        }
        return false;
    }
    
    func showLoginController(delegateController: UIViewController?) {
        
        let controller = LoginViewController(nibName: "LoginViewController", bundle: nil)
        
        
        if ((delegateController?.presentingViewController) != nil) {
            
            delegateController?.dismiss(animated: false, completion: {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    
                    User.removeSaveData();
                    AccessTokenModel.removeSaveData();
                    RefreshAccessTokenModel.removeSaveData();
                    
                }
                
//                if(self.jobUnLocked == true)
//                {
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DismissedLauncher"), object: nil);
//                }
                
                
                let rootController = UIApplication.shared.delegate?.window!?.rootViewController as! UINavigationController
                
                rootController.popToRootViewController(animated: true)
                rootController.present(controller, animated: true, completion: nil)
                
                
                
            });
        }
        else{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                
                User.removeSaveData();
                AccessTokenModel.removeSaveData();
                RefreshAccessTokenModel.removeSaveData();
                
            }
            
//            if(self.jobUnLocked == true)
//            {
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DismissedLauncher"), object: nil);
//            }
            
            let rootController = UIApplication.shared.delegate?.window!?.rootViewController as! UINavigationController
            
            rootController.popToRootViewController(animated: true)
            
            rootController.present(controller, animated: true, completion: nil)
        }
    }
}
