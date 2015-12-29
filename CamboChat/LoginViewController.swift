//
//  LoginViewController.swift
//  CamboChat
//
//  Created by Yoman on 10/29/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//

import UIKit


class LoginViewController: YomanViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var btnSignup: UIButton!
    
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
        self.performSegueWithIdentifier("GOGO", sender: nil)
    
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
     // MARK: - UITableView Method Area
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