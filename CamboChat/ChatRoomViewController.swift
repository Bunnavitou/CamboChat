//
//  ChatRoomViewController.swift
//  CamboChat
//
//  Created by Yoman on 10/3/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//

import UIKit

class ChatRoomViewController: YomanViewController {
    
    @IBOutlet var mainTableView: UITableView!

    @IBOutlet var textBoxHeigthConstraints: NSLayoutConstraint!
    @IBOutlet var textBoxChat: UITextView!
    
    
    ///=====Key Board up and down Constraints
    @IBOutlet var txtViewInputConst: NSLayoutConstraint!
    @IBOutlet var btnUploadConst: NSLayoutConstraint!
    @IBOutlet var btnSendConst: NSLayoutConstraint!
    
    
    
    var myArrayOfDict: NSMutableArray = [
        ["check":  "1", "name": "Yoman" , "SubMe" : ["img":"YomanDeveloper.png","Texts":"hellow where are you man"]]
        ,["check": "2", "name": ""               , "SubMe" : ["img":""  ,"Texts":"am at home nowaday fade me as normal i go where are you man ?"]]
        ,["check": "2", "name": ""               , "SubMe" : ["img":""  ,"Texts":"will be leave soon as possible to go somewhere on earth that can me me feeling good to go with man will be leave soon as possible to go somewhere on earth that"]]
        ,["check": "1", "name": "Lay Bunnavitou" , "SubMe" : ["img":"YomanDeveloper.png","Texts":"ohh sound nice to me, can i join man ?"]]
        ,["check": "2", "name": "1"              , "SubMe" : ["img":""   ,"Texts":"ok call me."]]
        ,["check": "2", "name": "1"              , "SubMe" : ["img":""   ,"Texts":"where are you man"]]
    ]

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Chat Room"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);

    }
    // MARK: - keyboard WillShow and WillHide Action
    func keyboardWillShow(sender: NSNotification) {
        
        let keyboardSizeBegin = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        let keyboardSizeEnd = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
   
        var sizeMe : CGFloat!
        
        if keyboardSizeBegin!.height == keyboardSizeEnd!.height {
            sizeMe = keyboardSizeBegin?.height
        } else {
             sizeMe = keyboardSizeEnd?.height
        }
        txtViewInputConst.constant  = sizeMe + 8
        btnUploadConst.constant     = sizeMe + 8
        btnSendConst.constant       = sizeMe + 8
        
    }
    func keyboardWillHide(sender: NSNotification) {
        if let _ = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            txtViewInputConst.constant = 8
            btnUploadConst.constant =  8
            btnSendConst.constant =  8
        }
    }

    
    // MARK: - UITableView Method Area
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int          {
        return myArrayOfDict.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        let TextMe = myArrayOfDict.objectAtIndex(indexPath.row).objectForKey("SubMe")!.objectForKey("Texts") as! String
        
        if(myArrayOfDict.objectAtIndex(indexPath.row).objectForKey("check") as! String == "1"){
            if(measureTextWidth(TextMe, constrainedToSize: CGSizeMake(UIScreen.mainScreen().bounds.size.width, 2000), fontSize: 14) > 240){
                return measureTextHeight(TextMe, constrainedToSize: CGSizeMake(240, 2000), fontSize: 14) + 25
            }else{
               return measureTextHeight(TextMe, constrainedToSize: CGSizeMake(UIScreen.mainScreen().bounds.size.width, 2000), fontSize: 14) + 25
            }
        }else{
            if(measureTextWidth(TextMe, constrainedToSize: CGSizeMake(UIScreen.mainScreen().bounds.size.width, 2000), fontSize: 14) > 240){
                return measureTextHeight(TextMe, constrainedToSize: CGSizeMake(240, 2000), fontSize: 14) + 7
            }else{
                return measureTextHeight(TextMe, constrainedToSize: CGSizeMake(UIScreen.mainScreen().bounds.size.width, 2000), fontSize: 14) + 7
            }
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatRoomHeadCellTable") as! ChatRoomHeadCellView
        cell.lblHeadDateName.text = "2015.07.22 (Monday) 23:00 PM"
        return cell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatRoomCellTable", forIndexPath: indexPath) as! ChatRoomCellView
        
        if(myArrayOfDict.objectAtIndex(indexPath.row).objectForKey("check") as! String == "1"){
            
            cell.maChatText.hidden   = true
            cell.maSiteImage.hidden  = true

            //========== Mate Chat Time
            let TextMe = myArrayOfDict.objectAtIndex(indexPath.row).objectForKey("SubMe")!.objectForKey("Texts") as! String
            
            if(measureTextWidth(TextMe, constrainedToSize: CGSizeMake(cell.contentView.frame.size.width, 2000), fontSize: 14) > 240){
                cell.mateTextWidth.constant  = 240
                cell.mateTextHeight.constant = measureTextHeight(TextMe, constrainedToSize: CGSizeMake(240, 2000), fontSize: 14) + 2
            }else{
                cell.mateTextHeight.constant = measureTextHeight(TextMe, constrainedToSize: CGSizeMake(cell.contentView.frame.size.width, 2000), fontSize: 14) + 2
                cell.mateTextWidth.constant  = measureTextWidth(TextMe, constrainedToSize: CGSizeMake(cell.contentView.frame.size.width, 2000), fontSize: 14) + 5
            }
            cell.mateChatText.text = TextMe
            cell.mateChatText.hidden = false
            
            //========== Mate UIImage Profile
            let imageMe = myArrayOfDict.objectAtIndex(indexPath.row).objectForKey("SubMe")!.objectForKey("img") as! String
            cell.mateImagePic.image  = UIImage(named: imageMe)
            cell.mateImagePic.hidden = false
            
            //========== Mate Name User
            let lblName = myArrayOfDict.objectAtIndex(indexPath.row).objectForKey("name") as! String
            cell.mateNameText.text = lblName
            
            cell.mateNameText.hidden = false
            cell.mateSiteImage.hidden = false
        }else{
            let TextMe = myArrayOfDict.objectAtIndex(indexPath.row).objectForKey("SubMe")!.objectForKey("Texts") as! String
            
            if(measureTextWidth(TextMe, constrainedToSize: CGSizeMake(cell.contentView.frame.size.width, 2000), fontSize: 14) > 240){
                cell.maTextWidth.constant  = 240
                cell.maTextHeight.constant = measureTextHeight(TextMe, constrainedToSize: CGSizeMake(240, 2000), fontSize: 14) + 2
            }else{
                cell.maTextHeight.constant = measureTextHeight(TextMe, constrainedToSize: CGSizeMake(cell.contentView.frame.size.width, 2000), fontSize: 14) + 2
                cell.maTextWidth.constant  = measureTextWidth(TextMe, constrainedToSize: CGSizeMake(cell.contentView.frame.size.width, 2000), fontSize: 14) + 5
            }
            cell.maChatText.text = TextMe
            cell.maChatText.hidden = false
            cell.maSiteImage.hidden = false
            
            cell.mateChatText.hidden = true
            cell.mateImagePic.hidden = true
            cell.mateNameText.hidden = true
            cell.mateSiteImage.hidden = true
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)      {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    
    // MARK: - UITextView Method Area
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        
    

        if(textView.text.characters.count >= 90){
            textBoxHeigthConstraints.constant = 65
        }else{
            textBoxHeigthConstraints.constant = 45
        }
        
        return true
    }
    
    // MARK: - Button Method Action
    @IBAction func btnSendAction(sender: UIButton) {
        
        if(!textBoxChat.text.isEmpty){
            let myArray = ["check":  "1", "name": "Yoman" , "SubMe" : ["img":"YomanDeveloper.png","Texts":"\(textBoxChat.text)"]]
    
            myArrayOfDict.addObject(myArray)
            
            mainTableView.reloadData()
            scrollToNewestMessage()
        }else{
            let alertView = UIAlertView();
            alertView.addButtonWithTitle("Understand");
            alertView.title = "Alert";
            alertView.message = "No Text Input";
            alertView.show();
        }
        
        mainTableView.reloadData()
    }
    
    @IBAction func BackAction(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func btnHandSakeAction(sender: UIButton) {

        print("TigerTiger")
    }
    // MARK: - Method Action
    func scrollToNewestMessage(){
        let indexPath = NSIndexPath(forRow: myArrayOfDict.count - 1 , inSection: 0)
        self.mainTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    

}

class ChatRoomCellView: UITableViewCell {
    ///=======Ma
    @IBOutlet var maTextHeight: NSLayoutConstraint!
    @IBOutlet var maTextWidth: NSLayoutConstraint!
    @IBOutlet var maChatText: UILabel!
    @IBOutlet var maSiteImage: UIImageView!

    //=======Mate
    @IBOutlet var mateChatText: UILabel!
    @IBOutlet var mateImagePic: UIImageView!
    @IBOutlet var mateNameText: UILabel!
    @IBOutlet var mateSiteImage: UIImageView!
    @IBOutlet var mateTextHeight: NSLayoutConstraint!
    @IBOutlet var mateTextWidth: NSLayoutConstraint!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
}

class ChatRoomHeadCellView: UITableViewCell {
    @IBOutlet var lblHeadDateName: UILabel!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }

}

class ChatRoomDAO: NSObject {

    var messageId : String?
    var senderId : String?
    var timestamp : NSDate?
    var header : NSDictionary?
    var text : String?
    
}
