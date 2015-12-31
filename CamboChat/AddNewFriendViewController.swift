//
//  AddNewFriendViewController.swift
//  CamboChat
//
//  Created by Yoman on 11/3/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//

import UIKit

class AddNewFriendViewController: YomanViewController,UITableViewDataSource,UITableViewDelegate {
    
    var dicData = NSDictionary()
    
    @IBOutlet var txtSearchText: UITextField!
    
    @IBOutlet var mainTableView: UITableView!
    
    var strUserReq : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add New Friend"
        
        navigatorView()
        
    }
    
    func navigatorView(){
        let buttonClose: UIButton = UIButton(type: .Custom)
        buttonClose.frame = CGRectMake(0, 0, 23, 23)
        buttonClose.setImage(UIImage(named:"QRCode.png"), forState: UIControlState.Normal)
        buttonClose.addTarget(self, action: "QRCodeAction:", forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonClose)
        
        let buttonAFri: UIButton = UIButton(type: .Custom)
        buttonAFri.frame = CGRectMake(0, 0, 23, 23)
        buttonAFri.setImage(UIImage(named:"Scan.png"), forState: UIControlState.Normal)
        buttonAFri.addTarget(self, action: "ScanAction:", forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(customView: buttonAFri)
        self.navigationItem.setRightBarButtonItems([rightBarButtonItem,rightBarButton], animated: true)
        
        let buttonRigt: UIButton = UIButton(type: .Custom)
        buttonRigt.frame = CGRectMake(0, 0, 23, 23)
        buttonRigt.setImage(UIImage(named:"Previous.png"), forState: UIControlState.Normal)
        buttonRigt.addTarget(self, action: "btnBackAction:", forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarButtonItemClose: UIBarButtonItem = UIBarButtonItem(customView: buttonRigt)
        self.navigationItem.setLeftBarButtonItems([rightBarButtonItemClose], animated: true)
    }
    
    // MARK: - Server Action Area
    func SendTrat(API_NAME:String){
        
        let dataDicSend = NSMutableDictionary()

        if(API_NAME == "CAMCHAT_SRCHFRND"){
            dataDicSend.setValue(API_NAME,                          forKey: "KEY")
            dataDicSend.setValue(txtSearchText.text,                forKey: "SEARCH_KEY")
            dataDicSend.setValue(SingleTonManager.ShareSingleTonManager().userID,      forKey: "USR_ID")
        }else if(API_NAME == "CAMCHAT_ADDFRND"){
            dataDicSend.setValue(API_NAME,                          forKey: "KEY")
            dataDicSend.setValue(SingleTonManager.ShareSingleTonManager().userID,      forKey: "REQ_USR_ID")
            dataDicSend.setValue(strUserReq,                        forKey: "REP_USR_ID")
        }
      
        
        super.sendTransaction(dataDicSend as [NSObject : AnyObject])
    }
    override func returnTransaction(responseDictionary: [NSObject : AnyObject]!, success: Bool) {
        if(success){
            if(responseDictionary == nil){
                return
            }
            if(responseDictionary["KEY_API"] as! String == "CAMCHAT_SRCHFRND"){
                dicData = responseDictionary
                mainTableView.reloadData()
            }else if(responseDictionary["KEY_API"] as! String == "CAMCHAT_ADDFRND"){
                SysUtils.showMessage("Already ask for new friend !")
            }
        }else{
           SysUtils.showMessage("Check your information Again")
        }
    }
    // MARK: - Button Action
    func btnBackAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    func ScanAction(sender: UIButton) {
        self.performSegueWithIdentifier("CameraScanSegue", sender: nil)
        
    }
    func QRCodeAction(sender: UIButton) {
    
        self.performSegueWithIdentifier("QRcodeSegue", sender: nil)
    }
  
    @IBAction func btnSearchAction(sender: UIButton) {
        SendTrat("CAMCHAT_SRCHFRND")

    }
    func btnAddFriendAction(sender: UIButton)      {

        let touchPoint = sender.convertPoint(CGPointZero, toView: mainTableView)
        let IndexPath = mainTableView.indexPathForRowAtPoint(touchPoint)
        strUserReq = dicData["RECORDS"]![IndexPath!.row]["USR_ID"] as! String
        SendTrat("CAMCHAT_ADDFRND")
    }
    
    // MARK: - UITableView Method Area
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int                       {
        if(dicData.count == 0){
            return 1
        }else{
            if(dicData["COUNT"] as! Int == 0){
                return 1
            }else{
                return dicData["COUNT"] as! Int
            }
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat       {
        return 50
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addNewFriendCell", forIndexPath: indexPath) as! AddNewFriendCellView
        
        if(dicData.count == 0){
            
            cell.lblName.hidden         = true
            cell.imgView.hidden         = true
            cell.btnAddFriend.hidden    = true
            cell.lblNoFriend.hidden     = false
            
        }else{
            cell.lblName.hidden         = false
            cell.imgView.hidden         = false
            cell.btnAddFriend.hidden    = false
            cell.lblNoFriend.hidden     = true
            
            if(dicData["COUNT"] as! Int == 0){
                cell.lblName.hidden         = true
                cell.imgView.hidden         = true
                cell.btnAddFriend.hidden    = true
                cell.lblNoFriend.hidden     = false
            }else{
                cell.lblName.text = dicData["RECORDS"]![indexPath.row]["USR_ID"] as? String
                if(SysUtils.isNull(dicData["RECORDS"]![indexPath.row]["FILE_NM"])){
                    cell.imgView.sd_setImageWithURL(NSURL(string: ""), placeholderImage: UIImage(named: "person_icon.png"))
                }else{
                    cell.imgView.sd_setImageWithURL(NSURL(string: "\(KServerURLImage)\(dicData["RECORDS"]![indexPath.row]["FILE_NM"] as! NSString)"), placeholderImage: UIImage(named: "person_icon.png"))
                }
                cell.btnAddFriend.addTarget(self, action: "btnAddFriendAction:", forControlEvents: UIControlEvents.TouchUpInside)
            }
        }

        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)                  {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        let alert = UIAlertController(title: "Pending", message: "Do you add Yoman as friend", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "YES", style: .Default, handler: { action in
            print("Ok")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
            
            print("Cancel")
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
       

    }
    
}
class AddNewFriendCellView: UITableViewCell {
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnAddFriend: UIButton!
    @IBOutlet var lblNoFriend: UILabel!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
}