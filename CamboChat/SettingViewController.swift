//
//  SettingViewController.swift
//  CamboChat
//
//  Created by Yoman on 10/2/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//



class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title="Setting"

        let buttonRigt: UIButton = UIButton(type: .Custom)
        buttonRigt.frame = CGRectMake(0, 0, 23, 23)
        buttonRigt.setImage(UIImage(named:"Shutdown.png"), forState: UIControlState.Normal)
        buttonRigt.addTarget(self, action: "btnExitAction:", forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarButtonItemClose: UIBarButtonItem = UIBarButtonItem(customView: buttonRigt)
        self.navigationItem.setRightBarButtonItems([rightBarButtonItemClose], animated: true)
        

        
        
    }

    // MARK: - Button Action
    func btnExitAction(sender: UIButton) {
        self.performSegueWithIdentifier("exitSegue", sender: nil)

    }
}
