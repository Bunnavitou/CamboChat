//
//  ProfileInformation.swift
//  CamboChat
//
//  Created by Yoman on 10/15/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//



class ProfileInformation: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    @IBAction func BackAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - UITableView Method Area
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int         {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("profileInforCell", forIndexPath: indexPath) as! ProfileInformationCellView
        
        cell.imageView?.image = UIImage(named: "YomanDeveloper.png")
        cell.imageView?.layer.cornerRadius = 20
        cell.textLabel?.text = "Me"
        cell.detailTextLabel?.text = "Hello world"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)      {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        
    }
}

class ProfileInformationCellView: UITableViewCell {

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
}