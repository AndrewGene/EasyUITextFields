//
//  ViewController.swift
//  WASHD
//
//  Created by Andrew Goodwin on 08/23/2016.
//  Copyright (c) 2016 Andrew Goodwin. All rights reserved.
//

import UIKit
import WASHD

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var txtIB: UITextField!
    @IBOutlet var txtProgrammatic: UITextField!
    @IBOutlet var txtAdvanced: UITextField!
    var lblRight = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.findAllTextInputs() //find all text inputs in the view controller for jump order process
        
        //Programmatic UITextField setup
        txtProgrammatic.validationType = .CreditCard
        txtProgrammatic.format = "xxxx xxxx xxxx xxxx"
        txtProgrammatic.maxLength = 19
        txtProgrammatic.jumpOrder = 1
        print(txtProgrammatic.allowedCharacters) //most built in validation types set allowedCharacters for you
        
        lblRight = UILabel(frame: CGRectMake(txtProgrammatic.frame.size.width - 60,0,60,txtProgrammatic.frame.size.height))
        lblRight.textAlignment = .Center
        lblRight.font = UIFont.systemFontOfSize(10)
        lblRight.textColor = UIColor.lightGrayColor()
        txtProgrammatic.rightView = lblRight
        txtProgrammatic.rightViewMode = .Always
        
        //Advanced usage: make your own validation expression (regex), transform input text before validation, and further validation
        //NOTE: regex specifies at least 5 digits
        let accountValidation = ValidationExpression(expression: "^\\d{5,}$",
                                             description: "Account Number",
                                             failureDescription: "Invalid account number",
                                             hints: [ValidationRule(priority: 0, expression: "\\d+", failureDescription: "Missing Numbers")],
                                             transformText:{ (account) in
                                                var myString = account
                                                myString = myString?.condensedWhitespace.stringByReplacingOccurrencesOfString(" ", withString: "")
                                                return myString!
            },
                                             furtherValidation:{[weak self] (account) in
                                                if (self?.hasA4(account))!{
                                                    return ValidationResult(isValid: true, failureMessage: nil, transformedString: account)
                                                }
                                                else{
                                                    return ValidationResult(isValid: false, failureMessage: "Account number does not contain the number 4", transformedString: account)
                                                }
            })
        
        txtAdvanced.validationExpression = accountValidation
        
        txtAdvanced.allowedCharacters = PositiveWholeNumbers
    }
    
    func hasA4(account:String)->Bool{
        return account.rangeOfString("4") != nil
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        txtIB.becomeFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.currentjumpOrder = textField.jumpOrder //set current first responder index
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.moveNext() //move to the next text input in order
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField.reachedMaxLength(range, string: string) || !string.shouldAllow(textField.allowedCharacters){
            return false
        }
        
        return textField.formatText(string)
    }
    
    @IBAction func textFieldDidChange(textField: UITextField) {
        if textField == txtProgrammatic{
            //this is a credit card number
            //NOTE:this does not cover ALL cards but is used as a simple example of something you COULD do
            if (txtProgrammatic.text!.hasPrefix("4")){
                lblRight.text = "VISA"
            }
            else if (txtProgrammatic.text!.hasPrefix("65") || txtProgrammatic.text!.hasPrefix("6011")){
                lblRight.text = "Discover"
            }
            else if (txtProgrammatic.text!.hasPrefix("34") || txtProgrammatic.text!.hasPrefix("37")){
                lblRight.text = "AMEX"
            }
            else if (txtProgrammatic.text!.characters.count > 0){
                lblRight.text = "MasterCard" //yes, this a simplification, again, it's an example
            }
            else{
                lblRight.text = ""
            }
        }
    }
    
    @IBAction func changeFormat(sender: AnyObject) {
        if txtIB.format == "(xxx) xxx-xxxx"{
            txtIB.format = "xxx.xxx.xxxx"
        }
        else if txtIB.format == "xxx.xxx.xxxx"{
            txtIB.format = "xxx-xxx-xxxx"
        }
        else{
            txtIB.format = "(xxx) xxx-xxxx"
        }
    }
    
    @IBAction func validateForm(sender: AnyObject) {
        
        let resultIB = txtIB.validate()
        if resultIB.isValid{
            print(resultIB.transformedString)
        }
        else{
            print(resultIB.failureMessage)
        }
        
        let resultProgrammatic = txtProgrammatic.validate()
        if resultProgrammatic.isValid{
            print(resultProgrammatic.transformedString)
        }
        else{
            print(resultProgrammatic.failureMessage)
        }
        
        let resultAdvanced = txtAdvanced.validate()
        if resultAdvanced.isValid{
            print(resultAdvanced.transformedString)
        }
        else{
            print(resultAdvanced.failureMessage)
        }
        
        //This is where you would normally show the end user your error messages. Only if they are all valid would you then submit your form.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

