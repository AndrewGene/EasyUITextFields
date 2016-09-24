//
//  ViewController.swift
//  WASHD
//
//  Created by Andrew Goodwin on 08/23/2016.
//  Copyright (c) 2016 Andrew Goodwin. All rights reserved.
//

import UIKit
import WASHD

open class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var txtIB: UITextField!
    @IBOutlet var txtProgrammatic: UITextField!
    @IBOutlet var txtAdvanced: UITextField!
    var lblRight = UILabel()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.findAllTextInputs() //find all text inputs in the view controller for jump order process
        
        //Programmatic UITextField setup
        txtProgrammatic.validationType = .creditCard
        txtProgrammatic.format = "xxxx xxxx xxxx xxxx"
        txtProgrammatic.maxLength = 19
        txtProgrammatic.jumpOrder = 1
        print(txtProgrammatic.allowedCharacters) //most built in validation types set allowedCharacters for you
        
        lblRight = UILabel(frame: CGRect(x: txtProgrammatic.frame.size.width - 60,y: 0,width: 60,height: txtProgrammatic.frame.size.height))
        lblRight.textAlignment = .center
        lblRight.font = UIFont.systemFont(ofSize: 10)
        lblRight.textColor = UIColor.lightGray
        txtProgrammatic.rightView = lblRight
        txtProgrammatic.rightViewMode = .always
        
        //Advanced usage: make your own validation expression (regex), transform input text before validation, and further validation
        //NOTE: regex specifies at least 5 digits
        let accountValidation = ValidationExpression(expression: "^\\d{5,}$",
                                             description: "Account Number",
                                             failureDescription: "Invalid account number",
                                             hints: [ValidationRule(priority: 0, expression: "\\d+", failureDescription: "Missing Numbers")],
                                             transformText:{ (account) in
                                                var myString = account
                                                myString = myString?.condensedWhitespace.replacingOccurrences(of: " ", with: "")
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
    
    func hasA4(_ account:String)->Bool{
        return account.range(of: "4") != nil
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txtIB.becomeFirstResponder()
    }
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentjumpOrder = textField.jumpOrder //set current first responder index
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.moveNext() //move to the next text input in order
        return true
    }
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.reachedMaxLength(range, string: string) || !string.shouldAllow(textField.allowedCharacters){
            return false
        }
        
        return textField.formatText(string)
    }
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
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
    
    @IBAction func changeFormat(_ sender: AnyObject) {
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
    
    @IBAction func validateForm(_ sender: AnyObject) {
        
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
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

