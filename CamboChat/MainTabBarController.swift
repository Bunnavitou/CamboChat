//
//  MainTabBarController.swift
//  CamboChat
//
//  Created by Yoman on 10/29/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//



class MainTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true) //or animated: false
        
        
    }
    
    

}
