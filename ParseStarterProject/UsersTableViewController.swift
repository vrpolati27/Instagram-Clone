//
//  UsersTableTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Vinay Reddy Polati on 9/23/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit;
import  Parse;

class UsersTableViewController: UITableViewController {
    
    struct FollowerKeys{
        public static let userObjectId:String = "userId";
        public static let followeeId:String = "followeeId";
    }
    
    
    var usersList:[PFUser] = [PFUser] ();
    var followers = [String:String]();
    
    @IBOutlet weak var logoutBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var postBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var feedBarButtonItem: UIBarButtonItem!
    
    @IBAction func postButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "usersToPost", sender: self);
    }
    
    @IBAction func feedButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "usersToFeeds", sender: self)
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        PFUser.logOut();
        performSegue(withIdentifier: "appToLogin", sender: self);
    }
    
    func updateUsers(){
        let query = PFUser.query();
        query?.findObjectsInBackground(block: { (objects, error) in
            if let _error = error {
                print("Error retrieving users information. \(_error.localizedDescription)");
            } else if let users:[PFUser] = objects as? [PFUser] {
                /*self.usersList = users;*/
                for user in users {
                    if user.username != PFUser.current()?.username {
                        self.usersList.append(user);
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData();
                }
            }
        })
    }
    
    func updateFollowers(){
        let query = PFQuery(className: "Followers");
        query.whereKey(FollowerKeys.userObjectId, equalTo: PFUser.current()!.objectId!);
        query.findObjectsInBackground { (objects, error) in
            if let _error = error {
                print(" Error getting Followers information. \(_error.localizedDescription)");
            } else {
                if let followerRecords = objects {
                    for record in followerRecords {
                        self.followers[record[FollowerKeys.followeeId] as! String] =  record[FollowerKeys.userObjectId] as! String;
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*PFUser.logInWithUsername(inBackground: "user1@email.com", password: "password", block: {(user, error) in
            if let c1 = user as? PFUser {
                print(" Login successful. \(c1.username!)");
                self.usersList.append(c1);
                print(self.usersList);
                DispatchQueue.main.async {
                    self.tableView.reloadData();
                }
            }
        }); */
        logoutBarButtonItem.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "Avenir-Medium", size: 20.0)!,], for: .normal);
        postBarButtonItem.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "Avenir-Medium", size: 20.0)!,], for: .normal);
        feedBarButtonItem.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "Avenir-Medium", size: 20.0)!,], for: .normal);
        updateUsers();
        updateFollowers();
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  usersList.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "usercell") as? UserCellController {
            cell.objectIdLabel.text = usersList[indexPath.row].objectId!;
            cell.userNameLabel.text = usersList[indexPath.row].username!;
            if followers[usersList[indexPath.row].objectId! as! String] == PFUser.current()?.objectId! {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.none;
            }
            if let _c1 = usersList[indexPath.row]["mobile"] as? String {
                cell.mobileNumberLabel.text = _c1;
            }
            return cell;
        }
        return UITableViewCell(style: .default, reuseIdentifier: "usercell");
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(" user selected row # \(indexPath.row)");
        let currentCell = self.tableView.cellForRow(at: indexPath);
        if let _cell = currentCell {
            if _cell.accessoryType == UITableViewCellAccessoryType.checkmark {
                _cell.accessoryType = .none;
                let fquery = PFQuery(className: "Followers");
                fquery.whereKey(FollowerKeys.userObjectId, equalTo: PFUser.current()!.objectId!);
                fquery.whereKey(FollowerKeys.followeeId, equalTo: usersList[indexPath.row].objectId!);
                fquery.findObjectsInBackground(block: { (records, error) in
                    if let _error = error {
                        print(" Error m1. \(_error.localizedDescription)");
                    } else {
                        for record in records! {
                            do {
                                try record.delete();
                                try record.save();
                                self.updateFollowers();
                            } catch {
                                print(" Error deleting a record");
                            }
                        }
                    }
                })
            } else if _cell.accessoryType == UITableViewCellAccessoryType.none {
                _cell.accessoryType = .checkmark;
                let followersObject = PFObject(className: "Followers");
                followersObject[FollowerKeys.userObjectId] = PFUser.current()?.objectId!;
                followersObject[FollowerKeys.followeeId] = usersList[indexPath.row].objectId;
                followersObject.saveInBackground { (success, error) in
                    if let  __error = error {
                        print("Error saving Information, \(__error.localizedDescription )");
                    } else if success {
                        print(" information successfully saved.")
                        self.updateFollowers();
                    }
                }
            }
        }
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

    
     //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == "usersToFeeds" {
                if let vc = segue.destination as? FeedsViewController {
                    updateFollowers();
                    vc.followers = self.followers;
                }
            }
        }
    }

}
