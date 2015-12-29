//
//  signupViewController.swift
//  CamboChat
//
//  Created by Yoman on 10/29/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//



class signupViewController: YomanViewController,UITextFieldDelegate {

    @IBOutlet var btnCreateDownConstraint: NSLayoutConstraint!
    @IBOutlet var btncreate: UIButton!
    @IBOutlet var btnCheckEmail: UIButton!
    @IBOutlet var btnCheckUserName: UIButton!
    
    //=====For TextField
    @IBOutlet var lblFname: UITextField!
    @IBOutlet var lblLname: UITextField!
    @IBOutlet var lblEmailAddress: UITextField!
    @IBOutlet var lblUserName: UITextField!
    @IBOutlet var lblPassword: UITextField!
    @IBOutlet var lblComfrimPassword: UITextField!
    
    var yoLayer: CALayer {
        return btncreate.layer
    }
    
    func setUpLayer() {
        yoLayer.shadowOpacity = 0.9
        yoLayer.shadowOffset  = CGSize(width: 4.0, height: 4.0)
    }
    // MARK: - Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayer()
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        
        
        
        return true
    }

    // MARK: - Sever Method Area
    func SendTrat(API_NAME:String){
        
        let dataDicSend = NSMutableDictionary()

        if(API_NAME  == "CAMCHAT_SIGNUP"){
            dataDicSend.setValue(API_NAME,             forKey: "KEY")
            dataDicSend.setValue(lblUserName.text,     forKey: "USR_ID")
            dataDicSend.setValue("\(SysUtils.tempMd5String (lblPassword.text))",     forKey: "USR_PWD")
            dataDicSend.setValue(lblFname.text,        forKey: "F_NAME")
            dataDicSend.setValue(lblLname.text,        forKey: "L_NAME")
            dataDicSend.setValue(lblEmailAddress.text, forKey: "USR_EMAIL")
            
        }else if(API_NAME == "CAMCHAT_CHECKMAIL"){
            dataDicSend.setValue(API_NAME,        forKey: "KEY")
            dataDicSend.setValue(lblEmailAddress.text, forKey: "USR_EMAIL")
            
        }else if(API_NAME == "CAMCHAT_CHCKUSRID"){
            
            dataDicSend.setValue(API_NAME,        forKey: "KEY")
            dataDicSend.setValue(lblUserName.text,     forKey: "USR_ID")
            
        }
    
        super.sendTransaction(dataDicSend as [NSObject : AnyObject])
    }
    
    override func returnTransaction(responseDictionary: [NSObject : AnyObject]!, success: Bool) {

        if(success){
            if(responseDictionary == nil){
                return
            }
            
            print(responseDictionary)
        
            
            if(responseDictionary["KEY_API"] as! String == "CAMCHAT_SIGNUP"){
                UIView.animateWithDuration(1.0, delay: 9.0, options: .CurveEaseOut, animations: {
                    self.btnCreateDownConstraint.constant = 15
                    }, completion: { finished in
                        self.dismissViewControllerAnimated(true, completion: nil)
                })
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
   
    // MARK: - Button Area Method
    @IBAction func btnCloseAction(sender: UIButton) {
         dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func btnCreateAction(sender: UIButton) {
        SendTrat("CAMCHAT_SIGNUP")
    }
    
    @IBAction func btnCheckEmailAction(sender: UIButton) {
        SendTrat("CAMCHAT_CHECKMAIL")
    }
    @IBAction func btnCheckUserAction(sender: UIButton) {
         SendTrat("CAMCHAT_CHCKUSRID")

    }
    
    
    
    
}
