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
        
        tf_userName.text = "khalfan";
        tf_password.text = "123456";
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
        
        let query = "mutation {User {login(username: \"\(tf_userName.text!)\", password: \"\(tf_password.text!)\"){username _id,username,firstName,lastName,email,mobileNumber}}}";
        
       // var inputParam = [String:Any]()
       // inputParam["userName"] = User.userName;
        
        var parameter = [String:Any]();
        parameter["query"] = query;
      //  parameter["variables"] = NetworkManager.sharedInstance.getJsonStringForVariable(inputParam);
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true);
        
        NetworkManager.sharedInstance.asynchronousWorkWithURL(baseUrl, ServiceType.POST, parameter, self, needToGetCookie: true) { (result, errorTitle, errorDescp) in
            
            if let result = result
            {
                //User.userID = "0";
                
                print(result)
                DispatchQueue.main.async {
                    
                    MBProgressHUD.hide(for: self.view, animated: false);
                    
                    if let data = result["data"] as? [String:Any]
                    {
                        if let user = data["User"] as? [String:Any]
                        {
                            if let login = user["login"] as? [String:Any]
                            {
                                if let fName = login["username"] as? String
                                {
                                    User.userName = fName
                                }
                                if let fName = login["firstName"] as? String
                                {
                                    User.firstName = fName;
                                    if let lName = login["lastName"] as? String
                                    {
                                        User.lastName = lName;
                                    }
                                }
                                if let email = login["email"] as? String
                                {
                                    User.email = email
                                }
                                if let mobileNumber = login["mobileNumber"] as? String
                                {
                                    User.phoneNumber = mobileNumber
                                }
                                
                                if let userid = login["userid"] as? String
                                {
                                    User.userID = userid
                                }
                                
                                // getUserRoles
                                
                                if(ReachUTIL.sharedInstance.hasValidText(User.userName))
                                {
                                    self.getUserRoles();
                                }
                            }
                        }
                    }
                }
                
            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: false);
                ReachUTIL.sharedInstance.displayAlert(withTitle: errorTitle, andMessage: errorDescp, self);
            }
        }
        
        
    }
    
    func getUserRoles()
    {
        var inputParam = [String:Any]()
        inputParam["userName"] = User.userName;
        
        let userRoleQuery = "query{Data{reach{userRoles(username:\"\(User.userName)\") {username,roles,driverId,isAvailable,driverPhoto}}}}";
        
        var parameter = [String:Any]();
        parameter["query"] = userRoleQuery;// UserRoles;
       //parameter["variables"] = NetworkManager.sharedInstance.getJsonStringForVariable(inputParam);
        
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
                                
                                if (userRoless.count < 1)
                                {
                                    ReachUTIL.sharedInstance.displayAlert(withTitle: "", andMessage: "User roles not found", self);
                                    
                                    return;
                                }
                                
                                let reqDat = userRoless.filter({ (dicVal) -> Bool in
                                    if dicVal["username"] as! String == User.userName
                                        
                                    {
                                       // print(dicVal["roles"] as! String);
                                        
                                        let role = dicVal["roles"] as! String;
                                        uRoleseArr.append(role);
                                        User.driverId = String(dicVal["driverId"] as! Int);
                                       // print(String(dicVal["driverId"] as! Int));
                                        
                                        if (role == kDriver)
                                        {
                                            ReachUTIL.sharedInstance.changeStatusAllowed = true;
                                        }

                                        if (role == kCorresponder || role == kVehicleCoordinator)
                                        {
                                            ReachUTIL.sharedInstance.acceptBtnAllowed = true;
                                        }
                                        
                                        if let isavil = dicVal["isAvailable"] as? Bool
                                        {
                                            User.isAvailable = isavil;
                                        }
                                        
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
                                    ReachUTIL.sharedInstance.updateDeviceToken();                                    self.dismiss(animated: true, completion: nil);
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


