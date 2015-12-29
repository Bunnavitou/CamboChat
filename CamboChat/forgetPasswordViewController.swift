//
//  forgetPasswordViewController.swift
//  CamboChat
//
//  Created by Yoman on 11/19/15.
//  Copyright © 2015 Yoman. All rights reserved.
//

import UIKit

class forgetPasswordViewController: YomanViewController {

    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Server Method Area
    func SendTrat(API_NAME:String){
        let dataDicSend = NSMutableDictionary()
    
        if(API_NAME == "CAMCHAT_FRGTPWD"){
            dataDicSend.setValue(API_NAME,          forKey: "KEY")
            dataDicSend.setValue(txtUserName.text,  forKey: "USR_ID")
            dataDicSend.setValue(txtEmail.text,     forKey: "USR_EMAIL")
            
        }else if(API_NAME == "CAMCHAT_CHCKUSRID"){
            dataDicSend.setValue(API_NAME,          forKey: "KEY")
            dataDicSend.setValue(txtUserName.text,     forKey: "USR_ID")
            
        }else if(API_NAME == "CAMCHAT_CHECKMAIL"){
            dataDicSend.setValue(API_NAME,        forKey: "KEY")
            dataDicSend.setValue(txtEmail.text, forKey: "USR_EMAIL")
            
        }
   
        
        super.sendTransaction(dataDicSend as [NSObject : AnyObject])
    }
    
    override func returnTransaction(responseDictionary: [NSObject : AnyObject]!, success: Bool) {
        if(success){
            if(responseDictionary == nil){
                return
            }
            if(responseDictionary["KEY_API"] as! String == "CAMCHAT_FRGTPWD"){
                if(responseDictionary["COUNT"] as! String  == "1"){
                    dismissViewControllerAnimated(true, completion: nil)
                }
                SysUtils.showMessage(responseDictionary["RSTL_MSG"] as! String)
                
            }else if(responseDictionary["KEY_API"] as! String == "CAMCHAT_CHCKUSRID"){
                if(responseDictionary["COUNT"] as! String  == "1"){
                    SysUtils.showMessage("Already Have")
                }else{
                    SysUtils.showMessage("Ok Move on")
                }
            }else if(responseDictionary["KEY_API"] as! String == "CAMCHAT_CHECKMAIL"){
                if(responseDictionary["COUNT"] as! String  == "1"){
                    SysUtils.showMessage("Already Have")
                }else{
                    SysUtils.showMessage("Ok Move on")
                }
            }
            
        }else{
            SysUtils.showMessage("Check your information Again")
        }
    }
    
    // MARK: - Button Method Area
    @IBAction func btnSummitAction(sender: UIButton) {
        SendTrat("CAMCHAT_FRGTPWD")
    }
    
    @IBAction func btnCloseAction(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func checkUserName(sender: UIButton) {
         SendTrat("CAMCHAT_CHCKUSRID")
        
    }
    
    @IBAction func checkEmail(sender: UIButton) {
         SendTrat("CAMCHAT_CHECKMAIL")
        
    }

}
