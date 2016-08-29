//
//  SettingsViewController.swift
//  GradeCheck
//
//  Created by Ivan Chau on 5/26/16.
//  Copyright © 2016 Ivan Chau. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var MHSButton : UIButton!
    @IBOutlet weak var SettingsTable : UITableView!
    let cellTitles = ["Update Password", "Change Student"]
    let url = "http://localhost:2800/"
    var objectID = "";

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 2;
        }else{
            return 1;
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "ACCOUNT"
        }else{
            return "STATISTICS"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell") as! SettingsTableViewCell
            cell.title.text = self.cellTitles[indexPath.row];
            cell.intention = self.cellTitles[indexPath.row];
            return cell;
        }else{
            let switchCell = tableView.dequeueReusableCellWithIdentifier("SettingsSwitchCell") as! SettingsSwitchTableViewCell
            switchCell.segmentControl.setTitle("Weighted GPA", forSegmentAtIndex: 0)
            switchCell.segmentControl.setTitle("Unweighted GPA", forSegmentAtIndex: 1)
            if (NSUserDefaults.standardUserDefaults().objectForKey("GPA") as! String == "Unweighted"){
                switchCell.segmentControl.selectedSegmentIndex = 1;
            }
            switchCell.segmentControl.tintColor = UIColor(red: 0.1574, green: 0.6298, blue: 0.2128, alpha: 1.0)
            return switchCell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(objectID)
        self.MHSButton.layer.cornerRadius = 10;
        self.MHSButton.clipsToBounds = true;
        self.SettingsTable.layer.cornerRadius = 10;
        // Do any additional setup after loading the view.
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 0){
            let cell = self.SettingsTable.cellForRowAtIndexPath(indexPath) as! SettingsTableViewCell
            if(cell.intention == "Update Password"){
                let alert = UIAlertController(title: "Update Password", message: "Enter your new password", preferredStyle: .Alert)
                let action = UIAlertAction(title: "Update", style: .Default, handler: { (alertAction) in
                    let passwordTextField = alert.textFields![0]
                    let newPassword = passwordTextField.text!
                    self.updateUser("preference",value: newPassword)
                })
                alert.addTextFieldWithConfigurationHandler { (textField) in
                    textField.placeholder = "New Password"
                    textField.secureTextEntry = true
                }
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }else if(cell.intention == "Change Student"){
                
            }
        }
    }
    func updateUser(field : String, value : String){
        print(field + " " + value);
        let headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        let string = field + "=" + value;
        print(string)
        
        let postData = NSMutableData(data: string.dataUsingEncoding(NSUTF8StringEncoding)!)
            let id = "&id=" + self.objectID
            postData.appendData(id.dataUsingEncoding(NSUTF8StringEncoding)!);
        
        let request = NSMutableURLRequest(URL: NSURL(string: url + "update")!,
                                          cachePolicy: .UseProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.HTTPBody = postData
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? NSHTTPURLResponse
                print(httpResponse)
                if(httpResponse?.statusCode == 200){
                    dispatch_async(dispatch_get_main_queue(), {
                    
                    })
                }else if (httpResponse?.statusCode == 1738){
                    dispatch_async(dispatch_get_main_queue(), {
                        let alert = UIAlertController(title: "Username Taken.", message: "It seems like you've logged on before. Please login with your student id and genesis password to regain access. Thanks!", preferredStyle: .Alert)
                        let action = UIAlertAction(title: "10/10", style: .Default, handler: nil)
                        alert.addAction(action);
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
            }
        })
        
        dataTask.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segueBack(sender:AnyObject){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
