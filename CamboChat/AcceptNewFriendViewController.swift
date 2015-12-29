//
//  AcceptNewFriendViewController.swift
//  CamboChat
//
//  Created by Yoman on 11/23/15.
//  Copyright © 2015 Yoman. All rights reserved.
//

import UIKit

class AcceptNewFriendViewController: YomanViewController {
    
    var dicData = NSDictionary()
    var strREP_USR : String!
    
    @IBOutlet var mainTableView: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Accept Friend"
        
        let buttonRigt: UIButton = UIButton(type: .Custom)
        buttonRigt.frame = CGRectMake(0, 0, 23, 23)
        buttonRigt.setImage(UIImage(named:"Previous.png"), forState: UIControlState.Normal)
        buttonRigt.addTarget(self, action: "btnBackAction:", forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarButtonItemClose: UIBarButtonItem = UIBarButtonItem(customView: buttonRigt)
        self.navigationItem.setLeftBarButtonItems([rightBarButtonItemClose], animated: true)
        

    }
    override func viewWillAppear(animated: Bool) {
        SendTrat("CAMCHAT_PENDINGFRND")
        
    }
    // MARK: - Server Action Area
    func SendTrat(API_NAME:String){
        
        let dataDicSend = NSMutableDictionary()
        if(API_NAME == "CAMCHAT_PENDINGFRND"){
            dataDicSend.setValue(API_NAME,            forKey: "KEY")
            dataDicSend.setValue(SingleTonManager.ShareSingleTonManager().userID,   forKey: "USR_ID")
            
        }else if(API_NAME == "CAMCHAT_ACCEPTFRI"){
            dataDicSend.setValue(API_NAME,            forKey: "KEY")
            dataDicSend.setValue(SingleTonManager.ShareSingleTonManager().userID,   forKey: "REP_USR_ID")
            dataDicSend.setValue(strREP_USR,            forKey: "REQ_USR_ID")
   
        }else if(API_NAME == "CAMCHAT_CANCELFRI"){
            dataDicSend.setValue(API_NAME,            forKey: "KEY")
            dataDicSend.setValue(SingleTonManager.ShareSingleTonManager().userID,   forKey: "REP_USR_ID")
            dataDicSend.setValue(strREP_USR,            forKey: "REQ_USR_ID")
        }
        
        super.sendTransaction(dataDicSend as [NSObject : AnyObject])
    }
    override func returnTransaction(responseDictionary: [NSObject : AnyObject]!, success: Bool) {
        if(success){
            if(responseDictionary == nil){
                return
            }
            if(responseDictionary["KEY_API"]  as! String == "CAMCHAT_PENDINGFRND"){
                dicData = responseDictionary
                mainTableView.reloadData()
            }else if(responseDictionary["KEY_API"]  as! String == "CAMCHAT_ACCEPTFRI"){
                SendTrat("CAMCHAT_PENDINGFRND")
                
            }else if(responseDictionary["KEY_API"]  as! String == "CAMCHAT_CANCELFRI"){
//                SendTrat("CAMCHAT_PENDINGFRND")
            }
        }else{
            SysUtils.showMessage("Check your information Again")
        }
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
        let cell = tableView.dequeueReusableCellWithIdentifier("AcceptNewFriendCell", forIndexPath: indexPath) as! AcceptNewFriendCellView
        
        if(dicData.count == 0){
            
            cell.lblName.hidden         = true
            cell.imgView.hidden         = true
            cell.btnCancel.hidden       = true
            cell.btnAccept.hidden       = true
            cell.lblNoFriend.hidden     = false
            
        }else{
            cell.lblName.hidden         = false
            cell.imgView.hidden         = false
            cell.btnCancel.hidden       = false
            cell.btnAccept.hidden       = false
            cell.lblNoFriend.hidden     = true
            
            if(dicData["COUNT"] as! Int == 0){
                cell.lblName.hidden         = true
                cell.imgView.hidden         = true
                cell.btnCancel.hidden       = true
                cell.btnAccept.hidden       = true
                cell.lblNoFriend.hidden     = false
            }else{
                cell.lblName.text = dicData["RECORDS"]![indexPath.row]["USR_ID"] as? String
                if(SysUtils.isNull(dicData["RECORDS"]![indexPath.row]["FILE_NM"])){
                    cell.imgView.sd_setImageWithURL(NSURL(string: ""), placeholderImage: UIImage(named: "person_icon.png"))
                }else{
                    cell.imgView.sd_setImageWithURL(NSURL(string: "\(KServerURLImage)\(dicData["RECORDS"]![indexPath.row]["FILE_NM"] as! NSString)"), placeholderImage: UIImage(named: "person_icon.png"))
                }
                cell.btnAccept.addTarget(self, action: "btnAcceptAction:", forControlEvents: UIControlEvents.TouchUpInside)
                cell.btnCancel.addTarget(self, action: "btnCancelAction:", forControlEvents: UIControlEvents.TouchUpInside)
                
            }
        }
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)                  {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }

    // MARK: - Button Action
    func btnBackAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    func btnAcceptAction(sender: UIButton) {
        let touchPoint = sender.convertPoint(CGPointZero, toView: mainTableView)
        let IndexPath = mainTableView.indexPathForRowAtPoint(touchPoint)
        strREP_USR = dicData["RECORDS"]![IndexPath!.row]["USR_ID"] as? String
        SendTrat("CAMCHAT_ACCEPTFRI")
    }
    func btnCancelAction(sender: UIButton) {
        let touchPoint = sender.convertPoint(CGPointZero, toView: mainTableView)
        let IndexPath = mainTableView.indexPathForRowAtPoint(touchPoint)
        strREP_USR = dicData["RECORDS"]![IndexPath!.row]["USR_ID"] as? String
        SendTrat("CAMCHAT_CANCELFRI")
    }
}

class AcceptNewFriendCellView: UITableViewCell {

    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblNoFriend: UILabel!
    @IBOutlet var btnCancel: UIButton!
    
    @IBOutlet var btnAccept: UIButton!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
}
