//
//  ViewController.swift
//  Greenely Test
//
//  Created by Giwrgos Gens on 17/09/15.
//  Copyright © 2015 Rene Gens. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //setting up different arrays for each data type to access them globally at some point
    var JSONGameName: [String] = []
    var JSONViewers: [Int] = []
    var JSONGameImages: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAndDecodeJson()
        
    }
    
    
    //this functions uses the default way to implement json in swift. For more advanced data or multiple json files
    //the suggestions is to use an external library like SwiftyJson
    func loadAndDecodeJson(){
        
        //defining the url of the nsurl string to download
        //if not secure URL allow it in the plist file
        let url = NSURL(string: "https://api.twitch.tv/kraken/games/top")
        
        //create the task to handle the url
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) -> Void in
            
            //when task completes this will run
            //need to check if data is not nil
            if error == nil {
                
                //serialize the json to a dictionary
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    //loop through the data but first check if it hsa something in it
                    if jsonResult.count > 0 {
                        
                        if let items = jsonResult["top"] as? NSArray {
                            
                            for item in items {
                                
                                if let viewers = item["viewers"] as? NSInteger {
                                    print(viewers)
                                    self.JSONViewers.append(viewers)
                                }
                                
                                if let games = item["game"] as? NSDictionary {
                                    if let name = games["name"] as? NSString {
                                        print (name)
                                        self.JSONGameName.append(name as String)
                                        
                                    }
                                    if let logo = games["logo"] as? NSDictionary {
                                        if let small = logo["small"] as? NSString {
                                            print (small)
                                            self.JSONGameImages.append(small as String)
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    //reload table after json parsing is done
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                } catch {
                    
                    print("error: parsing json")
                    
                }
                
            } else {
                
                //Show error message that there is probably no connection
                let alert = UIAlertController(title: "Oopps..", message: "The was an error downloading data", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        //execute the async task
        task.resume()
    }
    
    //defining number os section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //function to determine the number of list items
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return JSONGameName.count
    }
    
    //the view of every cell of the list
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //custom cell identifier
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ViewControllerCell
        
        //setting up the images and casting them from strings to UIImages
        let imageURL = NSURL(string: JSONGameImages[indexPath.row])
        let data = NSData(contentsOfURL: imageURL!)
        
        //setting game name, images and viewers on cells
        cell.gameName?.text = JSONGameName[indexPath.row]
        cell.gameViewers?.text = String (JSONViewers[indexPath.row])
        cell.gameImage?.image = UIImage(data: data!)
        
        
        return cell
    }
}

