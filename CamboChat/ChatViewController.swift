//
//  ChatViewController.swift
//  CamboChat
//
//  Created by Yoman on 10/2/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//

import UIKit

class ChatViewController: YomanViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,SWTableViewCellDelegate   {
    
    @IBOutlet var txtSearch: UISearchBar!
    @IBOutlet var mainTableView: UITableView!

    var dicData = NSDictionary()
    
    var resultDicData : NSArray = []
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Chat"
    
        NavigatorSetUp()
        
        SendTrat("CAMCHAT_LSTCHTRM")

    }
    func NavigatorSetUp() {

        let buttonLeft : UIButton = UIButton(type:.Custom)
        buttonLeft.frame = CGRectMake(0, 0, 23, 23)
        buttonLeft.setImage(UIImage(named:"Add List.png"), forState: UIControlState.Normal)
        buttonLeft.addTarget(self, action: "btnAddAction:", forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarButtonItemLeft: UIBarButtonItem = UIBarButtonItem(customView: buttonLeft)
        self.navigationItem.setLeftBarButtonItems([rightBarButtonItemLeft], animated: true)
    }
    
    
    // MARK: - Server Action Area
    func SendTrat(API_NAME:String){
        
        let dataDicSend = NSMutableDictionary()
        
        if(API_NAME == "CAMCHAT_LSTCHTRM"){
            dataDicSend.setValue(API_NAME,                          forKey: "KEY")
            dataDicSend.setValue(SingleTonManager.ShareSingleTonManager().userID,      forKey: "USR_ID")
//            dataDicSend.setValue("mvsotso",      forKey: "USR_ID")
            
        }else if(API_NAME == ""){
            
            
        }
        super.sendTransaction(dataDicSend as [NSObject : AnyObject])
    }
    override func returnTransaction(responseDictionary: [NSObject : AnyObject]!, success: Bool) {
        if(success){
            if(responseDictionary == nil){
                return
            }
            if(responseDictionary["KEY_API"] as! String == "CAMCHAT_LSTCHTRM"){
                dicData = responseDictionary
                print(dicData)
                mainTableView.reloadData()
            }else {
                
            }
        }else{
            SysUtils.showMessage("Check your information Again")
        }
    }
    
    // MARK: - Search Delegate Method
    func searchDisplayControllerDidBeginSearch(controller: UISearchDisplayController){
        controller.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool{
        filterContentForSearchText(searchString!)
        return true
    }
    func filterContentForSearchText(searchText: String) {
        let arr:NSArray = dicData["RECORDS"] as! NSArray
        let pre : NSPredicate = NSPredicate(format: "PRF_FILE_NM CONTAINS[c] %@", searchText)
        resultDicData = arr.filteredArrayUsingPredicate(pre)
    }

    // MARK: - UITableView Method Area
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int           {
        if (tableView == self.searchDisplayController?.searchResultsTableView){
            if(section == 0){
                return resultDicData.count
            }
        }else{
            if(section == 0){
                return 1
            }else{
                if(dicData.count != 0){
                    if(dicData["COUNT"] as! Int == 0){
                        return 0
                    }else{
                        return dicData["COUNT"] as! Int
                    }
                }
            }
        }
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 75
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.mainTableView.dequeueReusableCellWithIdentifier("chatCellTable") as! ChatViewCell
        
        cell.setRightUtilityButtons(rightButtons() as [AnyObject], withButtonWidth: 60)
        cell.delegate = self
    
        if (tableView == self.searchDisplayController?.searchResultsTableView){
            
            let strDate = resultDicData[indexPath.row]["CVN_TYPE"] as? NSString
            cell.lblDate.text = strDate!.substringWithRange(NSMakeRange(0, 10))
            cell.lblNumberOfGroup.text = resultDicData[indexPath.row]["GRP_NM"] as? String
            cell.lblName.text = resultDicData[indexPath.row]["PRF_FILE_NM"] as? String
            cell.lblDetailText.text = resultDicData[indexPath.row]["CVN_DT"] as? String
 
        }else{
            cell.setRightUtilityButtons(rightButtons() as [AnyObject], withButtonWidth: 80)
            cell.delegate = self
            
            if(dicData.count != 0){
                if(dicData["COUNT"] as! Int != 0){
                    let strDate = dicData["RECORDS"]![indexPath.row]["CVN_TYPE"] as? NSString
                    cell.lblDate.text = strDate!.substringWithRange(NSMakeRange(0, 10))
                    cell.lblNumberOfGroup.text = dicData["RECORDS"]![indexPath.row]["GRP_NM"] as? String
                    cell.lblName.text = dicData["RECORDS"]![indexPath.row]["PRF_FILE_NM"] as? String
                    cell.lblDetailText.text = dicData["RECORDS"]![indexPath.row]["CVN_DT"] as? String
                }
            }
        }
        let hue = CGFloat(arc4random() % 256) / 256.0;
        let saturation = CGFloat(arc4random() % 128) / 256.0 + 0.5;
        let brightness = CGFloat(arc4random() % 128) / 256.0 + 0.5;
        cell.imageLineColor.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)      {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        
//        SysUtils.showMessage(dicData["RECORDS"]![indexPath.row]["GRP_ID"] as? String)
        self.performSegueWithIdentifier("chatroomSEGUE", sender: nil)
        
    }
    
   // MARK: - SWTableViewDelegate
    func rightButtons() ->NSArray {
        let rightUtilityButtons = NSMutableArray()
        rightUtilityButtons .sw_addUtilityButtonWithColor(UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1), title: "Edit")
        rightUtilityButtons .sw_addUtilityButtonWithColor(UIColor(red: 1.0, green: 0.231, blue: 0.188, alpha: 1), title: "Delete")
        return rightUtilityButtons
    }

    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        
        switch (index){
            case 0:
                print(" buttons 00")
                break
            case 1:
                print(" buttons 11")
                break
            default:
                break
        }
    }
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        return true
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, canSwipeToState state: SWCellState) -> Bool {
        
        return true
    }

    
    // MARK: - Button Action
    func btnAddAction(sender: UIButton) {
     
        self.performSegueWithIdentifier("AddNewChatSegue", sender: nil)
    }
}

class ChatViewCell: SWTableViewCell {
    
    @IBOutlet var lblDate: UILabel!

    @IBOutlet var lblNumberOfGroup: UILabel!
    @IBOutlet var imageLineColor: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDetailText: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    
}