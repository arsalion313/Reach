//
//  LoginViewController.swift
//  Kadir
//
//  Created by Waqas on 09/11/2017.
//  Copyright © 2017 Muhammad Arslan Khalid. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var tf_userName: UITextField!
    
    @IBOutlet weak var tf_password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //GitHub branch
        // Do any additional setup after loading the view.
        
//        tf_userName.text = "55558"
//        tf_password.text = "Targetadmin";
//
//        tf_userName.text = "06422914"
//        tf_password.text = "1abcdefgh";
        tf_userName.text = "77777777";
        tf_password.text = "Godisone1";
        
//        tf_userName.text = "09090909";
//        tf_password.text = "123456789";
//        tf_userName.text = "05050505";
//        tf_password.text = "123456";
        
        //self.submitForms(result: false);
       //self.incrementLabel(to: 15000)
        
//        tf_userName.text = "10539156"
//        tf_password.text = "123456sh";
    }
    
    @IBAction func resignAction(_ sender: Any) {
        
        tf_password.resignFirstResponder();
        tf_userName.resignFirstResponder();
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        tf_password.resignFirstResponder();
        tf_userName.resignFirstResponder();
        return true;
    }
    
    func incrementLabel(to endValue: Int) {
        let duration: Double = 2 //seconds
        DispatchQueue.global().async {
            for i in 0 ..< (endValue + 1) {
                let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                usleep(sleepTime)
                DispatchQueue.main.async {
                    self.tf_userName.text = "\(i)"
                }
            }
        }
    }
    func submitForms(result:Bool) {
        guard result == true else {
            
            print("result is false")
            return
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        //let controller = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        //self.present(controller, animated: true, completion: nil);
        
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        if (!ReachUTIL.sharedInstance.hasValidText(tf_userName.text))
        {
            ReachUTIL.sharedInstance.displayAlert(withTitle: "", andMessage: "Please enter username", self);
            
            return;
        }
        
        if (!ReachUTIL.sharedInstance.hasValidText(tf_password.text))
        {
            ReachUTIL.sharedInstance.displayAlert(withTitle: "", andMessage: "Please enter password.", self);
            return;
        }
        MBProgressHUD.showAdded(to: self.view, animated: true);
        
        NetworkAppManager.asyncLoginApiUser(WithUsername: tf_userName.text!, WithPassword: tf_password.text!, WithDelegate: self) { (result, errorTitle, errorDescp) in
            if let result = result
            {
                //User.userID = "0";
                
                print(result)
                DispatchQueue.main.async {
                    
                    MBProgressHUD.hide(for: self.view, animated: false);
                    
                    if let data = result["data"] as? [String:Any]
                    {
                        if let login = data["logIn"] as? [String:Any]
                        {
                            if login["success"] as! Bool
                            {
                                if let profile = login["userProfile"] as? [String:Any]
                                {
                                    User.userID = profile["userID"] as! String
                                    print(User.userID);
                                    
                                    if let fName = profile["fullName"] as? String
                                    {
                                        User.firstName = fName
                                    }
                                    
                                    if let residentCardNoStr = profile["residentCardNo"] as? String
                                    {
                                        User.userResidentCardNo = residentCardNoStr
                                    }
                                    
                                    User.userName = self.tf_userName.text!
                                    
                                    if ( KadirUTIL.sharedInstance.hasValidText(User.userResidentCardNo))
                                    {
                                        self.dismiss(animated: true, completion: nil);
                                    }
                                    
                                }
                                
                            }
                            else
                            {
                                KadirUTIL.sharedInstance.displayAlert(withTitle: "Error", andMessage: "Unable to login", self);
                            }
                        }
                    }
                }
                
            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: false);
                KadirUTIL.sharedInstance.displayAlert(withTitle: errorTitle, andMessage: errorDescp, self);
            }
        }
        
        
    }
    
//    func isStringMatched(with mString: String) -> Bool
//    {
//        let comptenceName: NSString = NSString(string: mString)
//        
//        return  (comptenceName.range(of: KadirUTIL.sharedInstance.userSpecialization, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
//    }
    
    func getUserRoles()
    {
        var inputParam = [String:Any]()
        inputParam["userName"] = User.userName;
        
        var parameter = [String:Any]();
        parameter["query"] = ""// UserRoles;
        parameter["variables"] = NetworkManager.sharedInstance.getJsonStringForVariable(inputParam);
        
        MBProgressHUD.showAdded(to: self.view, animated: true);
        
        NetworkManager.sharedInstance.asynchronousWorkWithURL(baseUrl, ServiceType.POST, parameter, self, needToGetCookie: true) { (result,errorTitle , errorDescp) in
            if let result = result
            {
                print(result)
                
                MBProgressHUD.hide(for: self.view, animated: false);
                
                if let data = result["data"] as? [String:Any] {
                    
                    if let Data = data["Data"] as? [String:Any] {
                        
                        if let reachData = Data["reach"] as? [String:Any] {
                            
                            var uRoleseArr = [String]();
                            if let userRoless = reachData["userRoles"] as? [[String:Any]] {
                                
                                let reqDat = userRoless.filter({ (dicVal) -> Bool in
                                    if dicVal["username"] as! String == User.userName
                                        
                                    {
                                        //print(dicVal["roles"]!);
                                        uRoleseArr.append(dicVal["roles"] as! String);
                                        User.driverId = String(dicVal["driverId"] as! Int);
                                        return true
                                    }
                                    else
                                    {
                                        return false
                                    }
                                })
                                
                                User.userRoles = uRoleseArr;
                                print(reqDat)
                                
                                if(User.driverId.count > 0)
                                {
                                    self.dismiss(animated: true, completion: nil);
                                }
                                else{
                                    ReachUTIL.sharedInstance.displayAlert(withTitle: "", andMessage: "Driver Id not found", self);
                                }
                                
                            }
                            else{
                                ReachUTIL.sharedInstance.displayAlert(withTitle: "", andMessage: "User Roles not found", self);
                            }
                        }
                    }
                }
            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: false);
                
                if let erroDescrip = errorDescp
                {
                    ReachUTIL.sharedInstance.displayAlert(withTitle: "", andMessage: erroDescrip, self);
                    return;
                }
                ReachUTIL.sharedInstance.displayAlert(withTitle: "", andMessage: "User does not exist", self);
            }
        }
    }
}

/*
 guard let item = userRoless.first,
 
 let roles = item["roles"] as? String,
 let uName = item["username"] as? String,
 let driverId = item["driverId"] as? Int
 
 else{
 return;
 }
 
 if uName == User.userName
 {
 uRoleseArr.append(roles);
 User.driverId = String(driverId);
 }
 */


