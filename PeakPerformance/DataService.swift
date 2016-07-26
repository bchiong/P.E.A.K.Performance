//
//  DataService.swift
//  PeakPerformance
//
//  Created by Bren on 18/07/2016.
//  Copyright © 2016 Bren. All rights reserved.
//

import Foundation
import Firebase

/**
    This class handles read/write to the Firebase realtime database.
  */
class DataService       //: SignUpDataService, LogInDataService
{
    // MARK: - Properties
    
    /// Base reference to the Firebase DB.
    let baseRef = FIRDatabase.database().reference()
    
    // MARK: - User Methods
    
    /**
        Saves a user's details to the database.

        - Parameters:
            - user: the user being saved.
    */
    func saveUser(user: User) {
        
        let usersRef = baseRef.child("users")
        let userRef = usersRef.child(user.uid)
        userRef.child("fname").setValue(user.fname)
        userRef.child("lname").setValue(user.lname)
        userRef.child("org").setValue(user.org)
        userRef.child("username").setValue(user.username)
        userRef.child("email").setValue(user.email)
        print("DS: user stored in database") //DEBUG
        
    }
    
    /**
        Loads a user from the database and creates a user object.

        - Parameters:
            - uid: the user's unique ID.

        - Returns: the user object.
    */
    func loadUser( uid: String, completion: ( user: User ) -> Void ) {
        
        let usersRef = baseRef.child("users")
        let userRef = usersRef.child(uid)
        
        userRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            print( "DS: fetching user" ) //DEBUG
            let fname = snapshot.value!["fname"] as! String
            let lname = snapshot.value!["lname"] as! String
            let org = snapshot.value!["org"] as! String
            let username = snapshot.value!["username"] as! String
            let email = snapshot.value!["email"] as! String
            //let weeklyGoalIDs = snapshot.value!["weeklyGoals"] as! [String]
            
            //for wgid in weeklyGoalIDs
            //{
            //    print( wgid )
            //}
            
            let user = User(fname: fname, lname: lname, org: org, email: email, username: username, uid: uid, weeklyGoals: [WeeklyGoal]())
            completion( user: user )
            print( "DS: user \(user.username) fetched" ) //DEBUG
        })
        /*if let wgIDs = weeklyGoalIDs
        {
            weeklyGoals = loadWeeklyGoals( wgIDs )
        }
        else
        {
            print("DS: no weekly goals found for user") //DEBUG
        }
        
        print("DS: user details fetched from database") //DEBUG
        return User(fname: fname, lname: lname, org: org, email: email, username: username, uid: uid, weeklyGoals: weeklyGoals )
        */
        
    }
    
    // MARK: - Weekly Goal Methods
    
    /**
        Loads a weekly goal from the database and creates a WeeklyGoal object.

        - Parameters:
            - weeklyGoalID: a weekly goal IDs.
     */
    func loadWeeklyGoal( weeklyGoalID: String, completion: ( weeklyGoal: WeeklyGoal ) -> Void )
    {
        let weeklyGoalsRef = baseRef.child("weeklyGoals")
        let weeklyGoalRef = weeklyGoalsRef.child(weeklyGoalID)
    
        weeklyGoalRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let goalText = snapshot.value!["goalText"] as! String
            let keyLifeArea = snapshot.value!["keyLifeArea"] as! KeyLifeArea
            let deadline = snapshot.value!["deadline"] as! String
            let weeklyGoal = WeeklyGoal(goalText: goalText, kla: keyLifeArea, deadline: deadline, wgid: weeklyGoalID )
            completion( weeklyGoal: weeklyGoal )
            print("DS: fetched weekly goal \(weeklyGoal.wgid)") //DEBUG
        })
    }
    
    /**
        Saves a weekly goal to the database.
    
        - Parameters:
            - uid: the user ID of the user the goal belongs to.
            - weeklyGoal: the goal being saved.
     */
    func saveWeeklyGoal( uid: String, weeklyGoal: WeeklyGoal )
    {
        //save weekly goal ID under user info in database
        let usersRef = baseRef.child("users")
        let userRef = usersRef.child(uid)
        let goalRef = userRef.child("weeklyGoals")
        goalRef.child(weeklyGoal.wgid).setValue(true)
        print("DS: saved weeklygoal under user ID" ) //DEBUG
        
        //save weekly goal info under weekly goals in database
        let weeklyGoalsRef = baseRef.child("weeklyGoals")
        let weeklyGoalRef = weeklyGoalsRef.child(weeklyGoal.wgid)
        weeklyGoalRef.child("goalText").setValue(weeklyGoal.goalText)
        weeklyGoalRef.child("kla").setValue(weeklyGoal.kla.rawValue)
        weeklyGoalRef.child("uid").setValue(uid)
        let dateFormatter = NSDateFormatter( )
        dateFormatter.dateFormat = "dd/MM/yyyy"
        weeklyGoalRef.child("deadline").setValue(dateFormatter.stringFromDate(weeklyGoal.deadline) )
        print("DS: saved weeklygoal under wgid" ) //DEBUG
    }

    
}