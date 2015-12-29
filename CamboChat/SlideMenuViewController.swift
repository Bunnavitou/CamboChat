//
//  SlideMenuViewController.swift
//  CamboChat
//
//  Created by Yoman on 10/2/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//


class SlideMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - UITableView Method Area
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int           {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SlideCellTable", forIndexPath: indexPath) as! SlideCellView
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)      {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        
    }
    
    // MARK: - Button Action
    func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
class SlideCellView: UITableViewCell {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    
}
