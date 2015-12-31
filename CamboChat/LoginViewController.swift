//
//  LoginViewController.swift
//  CamboChat
//
//  Created by Yoman on 10/29/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//

import UIKit


class LoginViewController: YomanViewController,UITableViewDataSource,UITableViewDelegate,FBSDKLoginButtonDelegate,GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet var btnSignup: UIButton!
    
    @IBOutlet var viewFB: UIView!
    @IBOutlet var viewGoolge: UIView!
    
    var yoLayer: CALayer {
        return btnSignup.layer
    }
    
    func setUpLayer() {
        yoLayer.shadowOpacity = 0.9
        yoLayer.shadowOffset  = CGSize(width: 4.0, height: 4.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayer()
        
        //=========FaceBook access info
        if (FBSDKAccessToken.currentAccessToken() != nil){
            FBSDKLoginManager().logOut()
            FBSDKAccessToken.setCurrentAccessToken(nil)
        }
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        loginView.frame  = CGRectMake(UIScreen.mainScreen().bounds.size.width/2 - 100, 0, 200, 40)
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
        viewFB.addSubview(loginView)
        
        
        //=========Google access info
        GIDSignIn.sharedInstance().signOut()
        let singin = GIDSignIn.sharedInstance()
        singin.delegate = self
        singin.uiDelegate = self
        
    }
    // MARK: - Goolge Delegate Method
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            print(user.profile.name)
        

//            let ImageURL = user.profile.imageURLWithDimension(200)
//            let data = NSData(contentsOfURL: ImageURL!) //make sure your image in this url does exist, otherwise unwrap in a if let check
//            imageView.image = UIImage(data: data!)
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    // MARK: - Facebook Delegate Methods
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil){
            // Process error
        }else if result.isCancelled {
            // Handle cancellations
        }else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email"){
                // Do work
            }
            
            let testPara = NSMutableDictionary()
            testPara.setObject("name,gender,first_name,last_name,email", forKey: "fields")
            
            //=====gender,first_name,last_name,id,age_range,devices,cover,email,locale
            
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: testPara as [NSObject : AnyObject])
            
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if ((error) != nil){
                    // Process error
                    print("Error: \(error)")
                }else{
                    print("fetched user: \(result)")
                    let userP : NSString = result.valueForKey("id") as! NSString
                    
                    print("https://graph.facebook.com/\(userP)/picture?type=large")
                    
                }
            })
        }
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    
    // MARK: - UITableView Method Area
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int           {
        return 1
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 200
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("loginViewCell", forIndexPath: indexPath) as! loginTableCell
        
        cell.btnLogn.addTarget(self, action: "btnLoginAction:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.btnLogn.layer.shadowOpacity = 0.9
        cell.btnLogn.layer.shadowOffset  = CGSize(width: 2.0, height: 2.0)
      
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)      {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
 
    }
     // MARK: - Button Method Area
    func btnLoginAction(sender: UIButton)      {
        SendTrat("CAMCHAT_LOGIN")

    }
    
    func SendTrat(API_NAME:String){
     
        let txtuserName = self.view.viewWithTag(111) as? UITextField
        let txtpassword = self.view.viewWithTag(112) as? UITextField
        txtuserName?.text="yoman"
        txtpassword?.text = "123"
        
        let dataDicSend = NSMutableDictionary()
        
        dataDicSend.setValue(API_NAME,                                          forKey: "KEY")
        dataDicSend.setValue(txtuserName?.text,                                 forKey: "USR_ID")
        dataDicSend.setValue("\(SysUtils.tempMd5String(txtpassword?.text))",    forKey: "USR_PWD")
        
        super.sendTransaction(dataDicSend as [NSObject : AnyObject])
    }
    
    override func returnTransaction(responseDictionary: [NSObject : AnyObject]!, success: Bool) {
        if(success){
            if(responseDictionary == nil){
                return
            }
            if(responseDictionary["KEY_API"] as! String == "CAMCHAT_LOGIN"){
                if(responseDictionary["USR_STS"] as! String == "D"){
                    SysUtils.showMessage("Please go and check your email .")
                }else if(responseDictionary["USR_STS"] as! String == "Z"){
                    SysUtils.showMessage("worng user information")
                }else{
                    SingleTonManager.ShareSingleTonManager().userID         = responseDictionary["USR_ID"] as! String
                    SingleTonManager.ShareSingleTonManager().user_file_name = responseDictionary["FILE_NM"] as! String
                    SingleTonManager.ShareSingleTonManager().user_fname     = responseDictionary["F_NAME"] as! String
                    SingleTonManager.ShareSingleTonManager().user_lname     = responseDictionary["L_NAME"] as! String
                    self.performSegueWithIdentifier("GOGO", sender: nil)
                }
            }
        }else{
            SysUtils.showMessage("Check your information Again")
        }
    }
    
    @IBAction func btnSignUpAction(sender: UIButton) {
        
        self.performSegueWithIdentifier("SignUpSegue", sender: nil)
    }

    @IBAction func btnForgotPasswordAction(sender: UIButton) {
        self.performSegueWithIdentifier("forgetPasswordSegue", sender: nil)
        
    }
}

class loginTableCell: UITableViewCell {
    
    @IBOutlet var btnLogn: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
     
    }
    
    
}