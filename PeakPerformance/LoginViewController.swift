//
//  LoginViewController.swift
//  PeakPerformance
//
//  Created by Bren on 17/07/2016.
//  Copyright © 2016 Bren. All rights reserved.
//

import UIKit
import Firebase
import SwiftValidator //https://github.com/jpotts18/SwiftValidator

/**
    Protocol for specifying log in DataService requirements.
 */
protocol LogInDataService
{
    func loadUser( uid: String ) -> User
}


/**
    Class that controls the Log In view.
 */
class LoginViewController: UIViewController, ValidationDelegate, UITextFieldDelegate {
 
    // MARK: - Properties
    
    /// The currently authenticated user.
    var currentUser: User?
    
    /// This view controller's DataService instance.
    let dataService = DataService( )
    
    /// This view controller's SwiftValidator instance.
    let validator = Validator( )
    
    
    // MARK: - Outlets
    
    //text fields
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //labels
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    
    // MARK: - Actions
    
    @IBAction func logInButtonPressed(sender: AnyObject)
    {
        //self.login( )
        validator.validate(self)
    }
    
    //@IBAction func signUpButtonPressed(sender: AnyObject) {}
    
    //@IBAction func resetPasswordButtonPressed(sender: AnyObject) {}
    
    
    
    // MARK: - Methods
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when all registered fields pass validation.
    func validationSuccessful()
    {
        print ("validation successful")
        self.login()
    }
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when a registered field fails against a validation rule.
    func validationFailed(errors: [(Validatable, ValidationError)])
    {
        print ("validation failed")
    }
    
    
    /// Attempts to authenticate a user using supplied details.
    func login()
    {
        FIRAuth.auth()?.signInWithEmail( emailField.text!, password: passwordField.text!, completion:  {
            user, error in
            
            if let error = error
            {
                //notify user of bad input/error somewhere here
                print("error logging in: " + error.localizedDescription)
            }
            else
            {
                print("logged in")
                if let user = FIRAuth.auth( )?.currentUser
                {
                    let uid = user.uid as String
                    self.currentUser = self.dataService.loadUser( uid )
                }
                
            }
        })
        //self.performSegueWithIdentifier( "loggedIn", sender: self )
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        validator.validate(self)
        return true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //set up swift validator (check sign up VC swift file for explanation)
        validator.styleTransformers(success: { (validationRule) -> Void in
            validationRule.errorLabel?.hidden = true
            validationRule.errorLabel?.text = ""
            if let textField = validationRule.field as? UITextField
            {
                textField.layer.borderColor = TF_REG_COL
                textField.layer.borderWidth = CGFloat( TF_REG_BRD )
            }
            
            }, error: { (validationError ) -> Void in
                validationError.errorLabel?.hidden = false
                validationError.errorLabel?.text = validationError.errorMessage
                if let textField = validationError.field as? UITextField
                {
                    textField.layer.borderColor = TF_ERR_COL
                    textField.layer.borderWidth = CGFloat( TF_ERR_BRD )
                }
        })
        
        //register fields to be validated (check sign up VC swift file for explanation)
        
        //email field
        validator.registerField(emailField, errorLabel: emailErrorLabel, rules: [RequiredRule( message: REQ_ERR_MSG), EmailRule( message: EMAIL_ERR_MSG)] )
        
        //password field
        validator.registerField(passwordField, errorLabel: passwordErrorLabel, rules: [RequiredRule( message: REQ_ERR_MSG), MinLengthRule(length: PW_MIN_LEN, message: SHORTPW_ERR_MSG ), MaxLengthRule(length: PW_MAX_LEN, message: LONGPW_ERR_MSG), PasswordRule( message: BADPW_ERR_MSG ) ] )
    
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //hide error labels
        emailErrorLabel.hidden = true
        passwordErrorLabel.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loggedIn"
        {
            let dvc = segue.destinationViewController as! TabBarViewController
            dvc.currentUser = self.currentUser
        }
        else if segue.identifier == "signUp"
        {
            //let dvc = segue.destinationViewController as! SignUpViewController
        }
    } */
    

}
