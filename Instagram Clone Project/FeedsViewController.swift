//
//  FeedsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Vinay Reddy Polati on 9/24/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit;
import Parse;

class FeedsViewController: UITableViewController {
    
    struct PostKeys {
        public static let userObjectId:String = "userObjectId";
        public static let message:String = "message";
        public static let image:String = "image";
    }
    
    var posts = [Post]();
     var followers = [String:String]();
   
    @IBAction func refreshButtonAction(_ sender: Any) {
        self.tableView.reloadData();
    }
    
    private func updatePosts() {
        let postsQuery = PFQuery(className: "Posts");
        postsQuery.whereKey(PostKeys.userObjectId, containedIn: Array(followers.keys));
        postsQuery.findObjectsInBackground { (objects, error) in
            if let _error = error {
                print(" Error getting required posts, \(_error.localizedDescription)");
            } else {
                if let posts = objects {
                    for post in posts {
                        if let _m1 = post[PostKeys.image] as? PFFile {
                            _m1.getDataInBackground(block: { (imgData, error) in
                                if let _error = error {
                                    print("Error getting image data, \(_error.localizedDescription)");
                                } else if let _imgData = imgData {
                                    let _c9 = Post(withUserId: post[PostKeys.userObjectId] as! String, image: _imgData, message: post[PostKeys.message] as! String);
                                    self.posts.append(_c9);
                                }
                            })
                        }
                    }
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updatePosts();
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.posts.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let feedCell = tableView.dequeueReusableCell(withIdentifier: "feedcell", for: indexPath)  as? FeedsTableViewCell{
            feedCell.usernameLabel.text = self.posts[indexPath.row].userId;
            feedCell.imageview.image = UIImage(data: self.posts[indexPath.row].image);
            if let _c1 = posts[indexPath.row].message {
                feedCell.messageLabel.text = _c1;
            }
            return feedCell;
        }
        return tableView.dequeueReusableCell(withIdentifier: "feedcell", for: indexPath) ;
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
