//
//  WeeklyGoalsViewController.swift
//  PeakPerformance
//
//  Created by Bren on 24/07/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit


/**
    Class that controls the weekly goals view.
  */
class WeeklyGoalsViewController: UITableViewController {

    // MARK: - Properties

    /// The currently authenticated user.
    var currentUser: User?
    
    /// The user's weekly goals.
    var weeklyGoals = [WeeklyGoal]( )
    
    
    // MARK: - Actions
    
    @IBAction func editButtonPressed(sender: AnyObject)
    {
        self.tableView.setEditing(true, animated: true)
    }
    
   // @IBAction func addButtonPressed(sender: AnyObject)
   // {
   //     self.tableView.set
   // }
    
   // @IBAction func menuButtonPressed(sender: AnyObject) {
   // }
    
    
    // MARK: - Methods
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get data from tab bar view controller
        let tbvc = self.tabBarController as! TabBarViewController
        self.currentUser = tbvc.currentUser!
        self.weeklyGoals = tbvc.weeklyGoals
    
        print("WGVC: got user \(currentUser!.email) with \(weeklyGoals.count) weekly goals") //DEBUG
        
        //tableView.reloadData()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return (currentUser?.weeklyGoals.count)!
        return weeklyGoals.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("weeklyGoalCell", forIndexPath: indexPath)
        let goal = weeklyGoals[indexPath.row]
        
        // Configure the cell...
        cell.textLabel!.text = goal.wgid //whatever we want the goal to be called

        //set image as KLA icon
        /*
        //var klaIcon =
        let kla = goal.kla
        switch kla
        {
            case KLA_FAMILY:
                klaIcon = familyIcon
            
            etc.
            
        }
        */
        
        //add checkbox in here somewhere
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete
        {
            // Delete the row from the data source
            weeklyGoals.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        else if editingStyle == .Insert
        {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
