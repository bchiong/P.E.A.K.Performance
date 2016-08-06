//
//  WeeklyGoalDetailViewController.swift
//  PeakPerformance
//
//  Created by Bren on 2/08/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import SwiftValidator //https://github.com/jpotts18/SwiftValidator

protocol MonthlyGoalDetailViewControllerDelegate
{
    func addNewGoal( monthlyGoal: MonthlyGoal )
    func saveModifiedGoal( monthlyGoal: MonthlyGoal )
}

class MonthlyGoalDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, ValidationDelegate
{
    
    // MARK: - Properties
    
    /// This view controller's delegate.
    var delegate: MonthlyGoalDetailViewControllerDelegate?
    
    /// The currently authenticated user.
    var currentUser: User?
    
    /// The goal currently being edited.
    var currentGoal: MonthlyGoal?
    
    /// Key life areas for the KLA picker.
    var keyLifeAreas = [KLA_FAMILY, KLA_EMOSPIRITUAL, KLA_FINANCIAL, KLA_FRIENDSSOCIAL, KLA_HEALTHFITNESS, KLA_PARTNER, KLA_PERSONALDEV, KLA_WORKBUSINESS]
    
    /// SwiftValidator instance.
    let validator = Validator( )
    
    // MARK: Date Picker Instance (retrieved from cocoapods)
    var datePicker = MIDatePicker.getFromNib()
    //  var kAreaPicker = MIKLAPicker.getFromNib()
    var dateFormatter = NSDateFormatter()
    
    // MARK: - Outlets
    
    //text fields
    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var klaTextField: UITextField!
    @IBOutlet weak var deadlineTextField: UITextField!
    
    //pickers
    @IBOutlet weak var klaPicker: UIPickerView!
    @IBOutlet weak var deadlinePicker: UIDatePicker!
    
    //error labels
    @IBOutlet weak var goalTextErrorLabel: UILabel!
    @IBOutlet weak var klaErrorLabel: UILabel!
    @IBOutlet weak var deadlineErrorLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(sender: AnyObject)
    {
        validator.validate(self)
    }
    
    @IBAction func klaButtonPressed(sender: AnyObject)
    {
        klaPicker.hidden = false
        //        kAreaPicker.show(inVC: self)
        
    }
    
    @IBAction func deadlineButtonPressed(sender: AnyObject)
    {
        //        deadlinePicker.hidden = false
        datePicker.show(inVC: self)
    }
    
    
    // MARK: - Methods
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when all registered fields pass validation.
    func validationSuccessful()
    {
        print ("MGDVC: validation successful") //DEBUG
        saveChanges( )
    }
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when a registered field fails against a validation rule.
    func validationFailed(errors: [(Validatable, ValidationError)])
    {
        print ("WGDVC: validation failed") //DEBUG
    }

    
    func saveChanges( )
    {
        //if there's no current goal, make a new one...
        if currentGoal == nil
        {
            createNewGoal( )
        }
            //...otherwise modify the referenced goal
        else
        {
            updateGoal( )
        }
        performSegueWithIdentifier(UNWIND_FROM_MGDVC_SEGUE, sender: self)
    }
    
    func createNewGoal( )
    {
        let goalText = goalTextView.text!
        let kla = klaTextField.text!
        let deadline = deadlineTextField.text!
        let gid = NSUUID( ).UUIDString
        let mg = MonthlyGoal(goalText: goalText, kla: kla, deadline: deadline, gid: gid)
        delegate?.addNewGoal(mg)
    }
    
    func updateGoal( )
    {
        guard let cg = currentGoal else
        {
            return
        }
        cg.goalText = goalTextView.text!
        cg.kla = klaTextField.text!
        let dateFormatter = NSDateFormatter( )
        dateFormatter.dateFormat = DATE_FORMAT_STRING
        guard let dl = dateFormatter.dateFromString(deadlineTextField.text!) else
        {
            return
        }
        cg.deadline = dl
        delegate?.saveModifiedGoal(cg)
    }
    
    func updateTextFields( )
    {
        guard let cg = currentGoal else
        {
            return
        }
        goalTextView.text = cg.goalText
        klaTextField.text = cg.kla
        let dateFormatter = NSDateFormatter( )
        dateFormatter.dateFormat = DATE_FORMAT_STRING
        deadlineTextField.text = dateFormatter.stringFromDate(cg.deadline)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //hide pickers
        klaPicker.hidden = true
        deadlinePicker.hidden = true
        
        //hide error labels
        goalTextErrorLabel.hidden = true
        klaErrorLabel.hidden = true
        deadlineErrorLabel.hidden = true
        
        //update textfields if editing a goal
        if currentGoal != nil
        {
            self.updateTextFields( )
        }
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        klaPicker.dataSource = self
        klaPicker.delegate = self
        datePicker.delegate = self
        //Check if user is authenticated
        if currentUser == nil
        {
            //handle error/reauthenticate
        }
        // Do any additional setup after loading the view.
        goalTextView.layer.cornerRadius = 5
        goalTextView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        goalTextView.layer.borderWidth = 1
        goalTextView.clipsToBounds = true
        
        //set up validator style transformer
        validator.styleTransformers(success: { (validationRule) -> Void in
            validationRule.errorLabel?.hidden = true
            validationRule.errorLabel?.text = ""
            if let textField = validationRule.field as? UITextField
            {
                textField.layer.borderColor = TEXTFIELD_REGULAR_BORDER_COLOUR
                textField.layer.borderWidth = CGFloat( TEXTFIELD_REGULAR_BORDER_WIDTH )
            }
            
            }, error: { (validationError ) -> Void in
                validationError.errorLabel?.hidden = false
                validationError.errorLabel?.text = validationError.errorMessage
                if let textField = validationError.field as? UITextField
                {
                    textField.layer.borderColor = TEXTFIELD_ERROR_BORDER_COLOUR
                    textField.layer.borderWidth = CGFloat( TEXTFIELD_ERROR_BORDER_WIDTH )
                }
        })
        
        //Register fields with SwiftValidator.
        //key life area text field
        validator.registerField(klaTextField, errorLabel: klaErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG)] )
        
        //deadline text field
        validator.registerField(deadlineTextField, errorLabel: deadlineErrorLabel, rules: [RequiredRule(message: REQUIRED_FIELD_ERR_MSG)])
        
        //goal text view
        validator.registerField(goalTextView, errorLabel: goalTextErrorLabel, rules: [RequiredRule(message: REQUIRED_FIELD_ERR_MSG)])
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - KLA Picker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return keyLifeAreas.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return keyLifeAreas[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        klaTextField.text = keyLifeAreas[row]
        klaPicker.hidden = true
    }
    
    // MARK: - Deadline picker
    
    @IBAction func deadlinePickerActivated(sender: AnyObject)
    {
        //        let dateFormatter = NSDateFormatter( )
        //        dateFormatter.dateFormat = DATE_FORMAT_STRING
        //        let deadline = dateFormatter.stringFromDate(deadlinePicker.date)
        //        deadlineTextField.text = deadline
        //        deadlinePicker.hidden = true
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


extension MonthlyGoalDetailViewController: MIDatePickerDelegate {
    func miDatePicker(amDatePicker: MIDatePicker, didSelect date: NSDate) {
        //        let deadline = dateFormatter.stringFromDate(deadlinePicker.date)
        //        deadlineTextField.text = deadline
        let deadline = dateFormatter.stringFromDate(date)
        deadlineTextField.text = deadline
    }
    
    func miDatePickerDidCancelSelection(amDatePicker: MIDatePicker) {
        
    }
}
