//
//  GroupViewController.swift
//  CamboChat
//
//  Created by Yoman on 10/2/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//

class GroupViewController: YomanViewController,UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,UISearchDisplayDelegate,UISearchBarDelegate {
    
    @IBOutlet var txtSearch: UISearchBar!
    
    @IBOutlet var mainTableView: UITableView!
    
    var dicData = NSDictionary()
    
    var resultDicData : NSArray = []

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Group"
        
        NavigatorSetUp()

        SendTrat("CAMCHAT_LSTFRND")
    }
    
    // MARK: - Navigator Bar
    func NavigatorSetUp() {
        let buttonClose: UIButton = UIButton(type: .Custom)
        buttonClose.frame = CGRectMake(0, 0, 23, 23)
        buttonClose.setImage(UIImage(named:"AddNew"), forState: UIControlState.Normal)
        buttonClose.addTarget(self, action: "btnAddAction:", forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarButtonItemClose: UIBarButtonItem = UIBarButtonItem(customView: buttonClose)
   
        let buttonAFri: UIButton = UIButton(type: .Custom)
        buttonAFri.frame = CGRectMake(0, 0, 23, 23)
        buttonAFri.setImage(UIImage(named:"acceptFrined"), forState: UIControlState.Normal)
        buttonAFri.addTarget(self, action: "btnAcceptFriAction:", forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarButtonItemAFri: UIBarButtonItem = UIBarButtonItem(customView: buttonAFri)
        
        self.navigationItem.setRightBarButtonItems([rightBarButtonItemClose,rightBarButtonItemAFri], animated: true)
        
        ///==========Profile
        let buttonPro: UIButton = UIButton(type: .Custom)
        buttonPro.frame = CGRectMake(0, 0, 25, 25)
        buttonPro.tag = 11
        buttonPro.setImage(UIImage(named:"More_1.png"), forState: UIControlState.Normal)
        buttonPro.setImage(UIImage(named:"More_2.png"), forState: UIControlState.Highlighted)
        buttonPro.setImage(UIImage(named: "closeBtn.png"), forState: UIControlState.Selected )
        
        if self.revealViewController() != nil {
            buttonPro.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        self.revealViewController().rearViewRevealWidth = UIScreen.mainScreen().bounds.size.width - 60
        
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonPro)
        self.navigationItem.setLeftBarButtonItems([rightBarButtonItem], animated: true)
    }
    
    // MARK: - Server Action Area
    func SendTrat(API_NAME:String){
        
        let dataDicSend = NSMutableDictionary()
        
        if(API_NAME == "CAMCHAT_LSTFRND"){
            dataDicSend.setValue(API_NAME,                          forKey: "KEY")
            dataDicSend.setValue(SingleTonManager.ShareSingleTonManager().userID,      forKey: "USR_ID")
        }else if(API_NAME == ""){
    
            
        }
        super.sendTransaction(dataDicSend as [NSObject : AnyObject])
    }
    override func returnTransaction(responseDictionary: [NSObject : AnyObject]!, success: Bool) {
        if(success){
            if(responseDictionary == nil){
                return
            }
            if(responseDictionary["KEY_API"] as! String == "CAMCHAT_LSTFRND"){
                
                dicData = responseDictionary
                print(dicData)
                mainTableView.reloadData()
            }else {
                
            }
        }else{
            SysUtils.showMessage("Check your information Again")
        }
    }
    
    // MARK: - Search Bar Method Area
    func searchDisplayControllerDidBeginSearch(controller: UISearchDisplayController){
        controller.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
    }
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool{
        filterContentForSearchText(searchString!)
        return true
    }
    func filterContentForSearchText(searchText: String) {
        let arr:NSArray = dicData["RECORDS"] as! NSArray
        let pre : NSPredicate = NSPredicate(format: "FULL_NAME CONTAINS[c] %@", searchText)
        resultDicData = arr.filteredArrayUsingPredicate(pre)

    }
    
    // MARK: - UITableView Method Area
    func numberOfSectionsInTableView(tableView: UITableView) -> Int                                         {
        if (tableView == self.searchDisplayController?.searchResultsTableView){
            return 1
        }else{
            return 2
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat                {
        return 30
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?                  {
        let sectionView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 30))
        sectionView.backgroundColor = UIColor.lightGrayColor()
        let lbl = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 30))
        sectionView.addSubview(lbl)
        if(section == 0 ){
            if (tableView == self.searchDisplayController?.searchResultsTableView){
                lbl.text = "Search Friend"
            }else{
                lbl.text = "My Profile"
            }
        }else{
            lbl.text = "Friend"
        }
        return sectionView
        
    }
    
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
                        return 1
                    }else{
                        return dicData["COUNT"] as! Int
                    }
                }
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.mainTableView.dequeueReusableCellWithIdentifier("GroupCellTable") as! GroupViewCell
    
        if (tableView == self.searchDisplayController?.searchResultsTableView){
            cell.lblname.text = resultDicData[indexPath.row]["FULL_NAME"] as? String
            
            if(SysUtils.isNull(resultDicData[indexPath.row]["FILE_NM"])){
                cell.imageViewPerson.sd_setImageWithURL(NSURL(string: ""), placeholderImage: UIImage(named: "person_icon.png"))
            }else{
                cell.imageViewPerson.sd_setImageWithURL(NSURL(string: "\(KServerURLImage)\(resultDicData[indexPath.row]["FILE_NM"] as! NSString)"), placeholderImage: UIImage(named: "person_icon.png"))
            }
        }else{
            if(indexPath.section == 0){
                cell.lblname.text = SingleTonManager.ShareSingleTonManager().userID
                cell.imageViewPerson.sd_setImageWithURL(NSURL(string: "\(KServerURLImage)\(SingleTonManager.ShareSingleTonManager().user_file_name)"), placeholderImage: UIImage(named: "person_icon.png"))
                
                let buttonPro = UIButton(type: .Custom)
                buttonPro.frame = CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)
                buttonPro.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
                cell.contentView.addSubview(buttonPro)
            }else{
                cell.setRightUtilityButtons(rightButtons() as [AnyObject], withButtonWidth: 80)
                cell.delegate = self
                
                if(dicData.count != 0){
                    if(dicData["COUNT"] as! Int != 0){
                        cell.lblname.text = dicData["RECORDS"]![indexPath.row]["FULL_NAME"] as? String
                        if(SysUtils.isNull(dicData["RECORDS"]![indexPath.row]["FILE_NM"])){
                            cell.imageViewPerson.sd_setImageWithURL(NSURL(string: ""), placeholderImage: UIImage(named: "person_icon.png"))
                        }else{
                            cell.imageViewPerson.sd_setImageWithURL(NSURL(string: "\(KServerURLImage)\(dicData["RECORDS"]![indexPath.row]["FILE_NM"] as! NSString)"), placeholderImage: UIImage(named: "person_icon.png"))
                        }
                    }
                }
            }
            let hue = CGFloat(arc4random() % 256) / 256.0;
            let saturation = CGFloat(arc4random() % 128) / 256.0 + 0.5;
            let brightness = CGFloat(arc4random() % 128) / 256.0 + 0.5;
            cell.imageSlide.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        }
    
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)      {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.section==0){
            
            
        }else{
            self.performSegueWithIdentifier("profileInformationSegue", sender: nil)
        }
    }
    
    
    // MARK: - Button Action
    func btnAddAction(sender: UIButton) {

        self.performSegueWithIdentifier("addNewFriendSegue", sender: nil)
    }
    func btnAcceptFriAction(sender: UIButton) {

        self.performSegueWithIdentifier("acceptFriendSegue", sender: nil)
    }

    // MARK: - SWTableViewDelegate
    // MARK: -
    func rightButtons() ->NSArray {
        let rightUtilityButtons = NSMutableArray()
        rightUtilityButtons .sw_addUtilityButtonWithColor(UIColor(red: 1.0, green: 0.231, blue: 0.188, alpha: 1), title: "Block")
        return rightUtilityButtons
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        switch (index){
        case 0:
            print(" buttons -<>-")
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
}


class GroupViewCell: SWTableViewCell {

    @IBOutlet var imageSlide: UIImageView!
   
    @IBOutlet var viewNewPeople: UIView!
    
    @IBOutlet var lblname: UILabel!
    
    @IBOutlet var imageViewPerson: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        
    }

    
}