//
//  Validation.swift
//
//  Created by Ian J.D. Howerton on 8/9/16.
//  Edited by Andrew Goodwin on 8/15/16
//  Copyright © 2016 Conway Corporation. All rights reserved.
//

import Foundation
import UIKit

public let UpperCaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
public let LowerCaseLetters = "abcdefghijklmnopqrstuvwxyz"
public let AllLetters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
public let UpperCaseHex = "0123456789ABCDEF"
public let LowerCaseHex = "0123456789abcdef"
public let AllHex = "0123456789abcdefABCDEF"
public let PositiveWholeNumbers = "0123456789"
public let WholeNumbers = "-0123456789"
public let PositiveFloats = "0123456789."
public let Floats = "-0123456789."
public let Email = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-+@.%"
public let Street = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -#.&"
public let IPAddress = "0123456789."
public let Money = "0123456789.$"
public let Phone = "0123456789.()- "
public let Zip = "0123456789-"

public class Validation
{
    var expressions = [ValidationExpression]()
    static var expression = Validation()
    
    private init()
    {
        
        let zip = ValidationExpression(expression: "^\\d{5}(-\\d{4})?$", description: "Zip Code",failureDescription: "Invalid Zip Code", hints: [
            ValidationRule(priority: 1, expression: "\\d{5}", failureDescription: "Zip code must be 5 characters"),
            ValidationRule(priority: 0, expression: "[0-9]+", failureDescription: "Not numbers"),
            ], interfaceBuilderAliases: ["zip","zip code"], transformText: { (zipcode) in
                var myString = zipcode
                myString = myString?.stringByReplacingOccurrencesOfString(" ", withString: "")
                return myString!
            }, furtherValidation:nil)
        
        let streetAddress = ValidationExpression(expression: "^[\\d]+\\s[- a-zA-Z\\d#.&]+$", description: "Street Address",failureDescription: "Invalid address", hints: [
            ValidationRule(priority: 0, expression: "^[\\d]+.+", failureDescription: "Invalid Street Number"),
            ValidationRule(priority: 1, expression: "^[\\d]+\\s.+", failureDescription: "Needs to be of format 123 Main St"),
            ValidationRule(priority: 2, expression: ".+[- a-zA-Z\\d#.&]+$", failureDescription: "Invalid Street Name")
            ], interfaceBuilderAliases: ["street","address","street address"], transformText: { (address) in
                var myString = address
                myString = myString?.condensedWhitespace
                return myString!
            }, furtherValidation:nil)
        
        let phone = ValidationExpression(expression: "^(\\(\\d{3}\\)[-.\\s]?|\\d{3}[-.\\s]?)?\\d{3}[-.\\s]?\\d{4}$", description: "Phone number",failureDescription: "Invalid Phone number", hints: [
            ValidationRule(priority: 0, expression: "\\d{7}", failureDescription: "Too Few Numbers"),
            ValidationRule(priority: 1, expression: "\\[0-9()-]", failureDescription: "Invalid Characters")
            ], interfaceBuilderAliases: ["phone","phone #","phone number"], transformText:nil, furtherValidation:nil)
        
        let email = ValidationExpression(expression: "^[\\w.%+-]+@[\\w.-]+\\.[a-zA-Z]{2,6}$", description: "Email Address",failureDescription: "Invalid Email", hints: [
            ValidationRule(priority: 0, expression: "@.[a-zA-Z]+[.]+[a-zA-Z]+$", failureDescription: "Requires exactly one @"),
            ValidationRule(priority: 1, expression: "[.]{1}[a-z]+$", failureDescription: "Requries exactly one period")
            ], interfaceBuilderAliases: ["email","email address","@"], transformText:{ (email) in
                var myString = email
                myString = myString?.condensedWhitespace.lowercaseString
                return myString!
            }, furtherValidation:nil)
        
        let ipAddress = ValidationExpression(expression: "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", description: "IP address",failureDescription: "Invalid IP address", hints: nil, interfaceBuilderAliases: ["ip","ip address"], transformText:nil, furtherValidation:nil)
        
        let MACAddress = ValidationExpression(expression: "^([A-Fa-f\\d]{4}\\.[A-Fa-f\\d]{4}\\.[A-Fa-f\\d]{4})|([A-Fa-f\\d]{12})$", description: "MAC address",failureDescription: "Invalid MAC address", hints: nil, interfaceBuilderAliases: ["mac","mac address"], transformText:nil, furtherValidation:nil)
        
        let GPSCoordinate = ValidationExpression(expression: "^\\-?[\\d]{1,3}(\\.{1}\\d+)?$", description: "GPS Coordinate",failureDescription: "Invalid GPS Coordinate", hints: nil, interfaceBuilderAliases: ["gps","gps coordinate"], transformText:nil, furtherValidation:nil)
        
        let GPSPoint = ValidationExpression(expression: "^\\-?[\\d]{1,3}(\\.{1}\\d+)?\\,\\-?[\\d]{1,3}(\\.{1}\\d+)?$", description: "GPS Point",failureDescription: "Invalid GPS Point", hints: nil, interfaceBuilderAliases: ["gps point"], transformText:nil, furtherValidation:nil)
        
        let URL = ValidationExpression(expression: "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$", description: "URL",failureDescription: "Invalid URL", hints: nil, interfaceBuilderAliases: ["url","http","https","web address"], transformText:nil, furtherValidation:nil)
        
        let creditCard = ValidationExpression(expression: "^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\\d{3})\\d{11})$",
                                              description: "Debit or Credit Card",
                                              failureDescription: "Invalid card",
                                              hints: [ValidationRule(priority: 0, expression: "\\d+", failureDescription: "Missing Numbers")],
                                              interfaceBuilderAliases: ["card","credit card","debit card","cc"],
                                              transformText:{ (card) in
                                                var myString = card
                                                myString = myString?.condensedWhitespace.stringByReplacingOccurrencesOfString(" ", withString: "")
                                                return myString!
            },
                                              furtherValidation:{[weak self] (card) in
                                                if (self?.luhnTest(card))!{
                                                    return ValidationResult(isValid: true, failureMessage: nil, transformedString: card)
                                                }
                                                else{
                                                    return ValidationResult(isValid: false, failureMessage: "Card failed Luhn check", transformedString: card)
                                                }
            })
        
        let money = ValidationExpression(expression: "\\$?[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\\.[0-9]{2})?$", description: "Money",failureDescription: "Invalid money format", hints: [
            ValidationRule(priority: 0, expression: "[.]{1}[0-9]{2}?$", failureDescription: "Invalid Decimal Value")
            ], interfaceBuilderAliases: ["money","currency","$"], transformText:nil, furtherValidation:nil)
        
        let letters = ValidationExpression(expression: "^[a-zA-Z]+$", description: "Letters, No Spaces",failureDescription: "Not Letters Without Spaces", hints: [
            ValidationRule(priority: 0, expression: " *", failureDescription: "Spaces Detected")
            ], interfaceBuilderAliases: ["letters","abc"], transformText:nil, furtherValidation:nil)
        
        let lettersWithSpaces = ValidationExpression(expression: "^[a-zA-Z ]+$", description: "Letters",failureDescription: "Not Letters", hints: nil, interfaceBuilderAliases: ["letters with spaces","letters spaces","a b c"], transformText:nil, furtherValidation:nil)
        
        let alphaNumeric = ValidationExpression(expression: "^[-\\da-zA-Z]+$", description: "Alpha Numeric, No Spaces",failureDescription: "Not alpha numeric", hints: [
            ValidationRule(priority: 0, expression: " *", failureDescription: "Spaces Detected")
            ], interfaceBuilderAliases: ["alphanumeric","alphanumerics","abc123"], transformText:nil, furtherValidation:nil)
        
        let alphaNumericWithSpaces = ValidationExpression(expression: "^[\\s-\\da-zA-Z]+$", description: "Alpha Numeric",failureDescription: "Not alpha numeric", hints: nil, interfaceBuilderAliases: ["alphanumeric with spaces","alphanumerics with spaces","alphanumeric spaces","alphanumerics spaces","a b c 1 2 3"], transformText:nil, furtherValidation:nil)
        
        let positiveNumbers = ValidationExpression(expression: "^[0-9]+$", description: "Positive Numbers",failureDescription: "Non-positive numbers present", hints: nil, interfaceBuilderAliases: ["positive numbers","+"], transformText:nil, furtherValidation:nil)
        
        let negativeNumbers = ValidationExpression(expression: "^-[0-9]+$", description: "Negative Numbers",failureDescription: "Non-negative numbers present", hints: nil, interfaceBuilderAliases: ["negative numbers","-"], transformText:nil, furtherValidation:nil)
        
        let wholeNumbers = ValidationExpression(expression: "^-?[\\d]+$", description: "Whole Numbers",failureDescription: "Non-numbers present", hints: nil, interfaceBuilderAliases: ["numbers","all numbers","123","whole numbers","integers"], transformText:nil, furtherValidation:nil)
        
        let positiveFloats = ValidationExpression(expression: "^[\\d]*\\.*\\d*$", description: "Positive Floats",failureDescription: "Not a positive float", hints: [
            ValidationRule(priority: 0, expression: ".{1}", failureDescription: "Multiple decimals found")
            ], interfaceBuilderAliases: ["positive floats","+f"], transformText:nil, furtherValidation:nil)
        
        let negativeFloats = ValidationExpression(expression: "^-[\\d]*\\.*\\d*$", description: "Negative Floats",failureDescription: "Not a negative float", hints: [
            ValidationRule(priority: 0, expression: ".{1}", failureDescription: "Multiple decimals found")
            ], interfaceBuilderAliases: ["negative floats","-f"], transformText:nil, furtherValidation:nil)
        
        let allFloats = ValidationExpression(expression: "^-?[\\d]*\\.*\\d*$", description: "All Floats",failureDescription: "Non-numbers present", hints: [
            ValidationRule(priority: 0, expression: ".{1}", failureDescription: "Multiple decimals found")], interfaceBuilderAliases: ["floats","all floats","123f"], transformText:nil, furtherValidation:nil)
        
        let text = ValidationExpression(expression: "^[a-zA-Z'.,;:!&()\\-\\s]+$", description: "Text", failureDescription: "Non-Text characters present", hints: nil, interfaceBuilderAliases: ["text"], transformText:nil, furtherValidation:nil)
        
        let name = ValidationExpression(expression: "^[a-zA-Z'\\-\\s]+$", description: "Name", failureDescription: "Non-Text characters present", hints: nil, interfaceBuilderAliases: ["name"], transformText:nil, furtherValidation:nil)
        
        let ssn = ValidationExpression(expression: "^([0-9]{3}[-]*[0-9]{2}[-]*[0-9]{4})*$", description: "Social Security Numbers", failureDescription: "Invalid SSN", hints: nil, interfaceBuilderAliases: ["ssn", "ss#"], transformText:nil, furtherValidation:nil)
        
        let states = ValidationExpression(expression: "^(?:A[KLRZ]|C[AOT]|D[CE]|FL|GA|HI|I[ADLN]|K[SY]|LA|M[ADEINOST]|N[CDEHJMVY]|O[HKR]|PA|RI|S[CD]|T[NX]|UT|V[AT]|W[AIVY])*$", description: "State Abbreviations", failureDescription: "Invalid 2 character state abbreviation", hints: nil, interfaceBuilderAliases: ["state","states"], transformText:nil, furtherValidation:nil)
        
        expressions = [zip, streetAddress, phone, email, ipAddress, MACAddress, GPSCoordinate, GPSPoint, URL, creditCard, money, letters, lettersWithSpaces, alphaNumeric, alphaNumericWithSpaces, positiveNumbers, negativeNumbers, wholeNumbers, positiveFloats, negativeFloats, allFloats, text, ssn, states, name]
        
    }
    
    public func isValid(expression: ValidationExpression, string: String) -> ValidationResult
    {
        return expression.validate(string)
    }
    
    public func isValid(validation: ValidationType, string: String) -> ValidationResult
    {
        let expression = expressions[validation.rawValue]
        return expression.validate(string)
    }
    
    func luhnTest(number: String) -> Bool{
        let noSpaceNum = number.condensedWhitespace
        let reversedInts = noSpaceNum.characters.reverse().map
            {
                Int(String($0))
        }
        return reversedInts.enumerate().reduce(0, combine: {(sum, val) in let odd = val.index % 2 == 1
            return sum + (odd ? (val.element! == 9 ? 9 : (val.element! * 2) % 9) : val.element!)
        }) % 10 == 0
    }
    
}

public enum ValidationType : Int
{
    case None = -1
    case Zip = 0
    case StreetAddress = 1
    case Phone = 2
    case Email = 3
    case IPAddress = 4
    case MACAddress = 5
    case GPSCoordinate = 6
    case GPSPoint = 7
    case URL = 8
    case CreditCard = 9
    case Money = 10
    case Letters = 11
    case LettersWithSpaces = 12
    case AlphaNumeric = 13
    case AlphaNumericWithSpaces = 14
    case PositiveNumbers = 15
    case NegativeNumbers = 16
    case WholeNumbers = 17
    case PositiveFloats = 18
    case NegativeFloats = 19
    case Floats = 20
    case Text = 21
    case SSN = 22
    case States = 23
    case Name = 24
}

private struct AssociatedKeys {
    static var enumContext = "enumContext"
    static var val = "validation"
    static var valExpression = "validationExpression"
    static var ac = "allowedChars"
}

public class ValidationExpression
{
    public var hints: [ValidationRule]?
    public var description = ""
    public var expression = ""
    public var failureDescription = ""
    public var aliases: [String]?
    public var transformedString = ""
    private var transformationClosure: ((String?) -> String)? = nil
    private var furtherValidationClosure: ((String) -> ValidationResult)? = nil
    
    public init()
    {
        
    }
    public init(expression: String, description: String, failureDescription: String)
    {
        self.expression = expression
        self.description = description
        self.failureDescription = failureDescription
    }
    public init(expression: String, description: String, failureDescription: String, hints: [ValidationRule]?, transformText: ((String?) -> String)?, furtherValidation: ((String) -> ValidationResult)?)
    {
        self.transformationClosure = transformText
        self.expression = expression
        self.description = description
        self.hints = hints
        self.hints = self.hints?.sort{
            item1, item2 in
            return item1.priority < item2.priority
        }
        self.failureDescription = failureDescription
        self.furtherValidationClosure = furtherValidation
    }
    public init(expression: String, description: String, failureDescription: String, hints: [ValidationRule]?, interfaceBuilderAliases aliases:[String]?, transformText: ((String?) -> String)?, furtherValidation: ((String) -> ValidationResult)?)
    {
        self.transformationClosure = transformText
        self.expression = expression
        self.description = description
        self.hints = hints
        self.hints = self.hints?.sort{
            item1, item2 in
            return item1.priority < item2.priority
        }
        self.aliases = aliases
        self.failureDescription = failureDescription
        self.furtherValidationClosure = furtherValidation
    }
    public func validate(string: String) -> ValidationResult
    {
        self.transformedString = string
        if self.transformationClosure != nil
        {
            self.transformedString = transformationClosure!(self.transformedString)
        }
       
        let test = NSPredicate(format: "SELF MATCHES %@",expression)
        let isValid = test.evaluateWithObject(self.transformedString)
        if isValid == false
        {
            if hints != nil && hints?.count > 0{
                for index in 0...self.hints!.count - 1
                {
                    let result = self.hints![index].validate(self.transformedString)
                    if result.isValid == false
                    {
                        return result
                    }
                }
            }
        }
        
        if self.furtherValidationClosure != nil{
            return furtherValidationClosure!(self.transformedString)
        }
        
        return ValidationResult(isValid: isValid,failureMessage: isValid ? nil: failureDescription, transformedString: self.transformedString)
    }
}

public class ValidationResult
{
    public var isValid = false
    public var failureMessage : String? = nil
    public var transformedString : String = ""
    
    public init(isValid: Bool, failureMessage:String?, transformedString: String)
    {
        self.isValid = isValid
        self.failureMessage = failureMessage
        self.transformedString = transformedString
    }
}

public class ValidationRule
{
    public var priority = 0
    public var expression = ""
    public var failureDescription = ""
    
    public init(priority: Int, expression: String, failureDescription: String)
    {
        self.priority = priority
        self.expression = expression
        self.failureDescription = failureDescription
    }
    public func validate(string:String) -> ValidationResult
    {
        let test = NSPredicate(format: "SELF MATCHES %@",expression)
        return ValidationResult(isValid: test.evaluateWithObject(string),failureMessage: failureDescription, transformedString: string)
    }
    
}

@IBDesignable
public extension UITextField
{
    public func validate() -> ValidationResult
    {
        if self.validationExpression != nil{
            return Validation.expression.isValid(self.validationExpression!, string: self.text!)
        }
        else{
            return Validation.expression.isValid(self.validationType, string: self.text!)
        }
    }
    public func validate(validation: ValidationType) -> ValidationResult
    {
        return Validation.expression.isValid(validation, string: self.text!)
    }
    @IBInspectable
    public var validation: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.val) as? String
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.val,
                    newValue as NSString?,
                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
                
                for index in 0...Validation.expression.expressions.count - 1{
                    let expression = Validation.expression.expressions[index]
                    if expression.aliases != nil{
                        for alias in expression.aliases!{
                            if newValue.condensedWhitespace.lowercaseString.stringByTrimmingCharactersInSet(
                                NSCharacterSet.whitespaceAndNewlineCharacterSet()
                                ) == alias.condensedWhitespace.lowercaseString.stringByTrimmingCharactersInSet(
                                    NSCharacterSet.whitespaceAndNewlineCharacterSet()
                                ){
                                self.validationType = ValidationType(rawValue: index)!
                                switch self.validationType {
                                case .Email:
                                    self.allowedCharacters = Email
                                case .Phone:
                                    self.allowedCharacters = Phone
                                case .Zip, .SSN:
                                    self.allowedCharacters = Zip
                                case .StreetAddress:
                                    self.allowedCharacters = Street
                                case .IPAddress:
                                    self.allowedCharacters = IPAddress
                                case .Money:
                                    self.allowedCharacters = Money
                                case .Letters, .States:
                                    self.allowedCharacters = AllLetters
                                case .LettersWithSpaces:
                                    self.allowedCharacters = AllLetters + " "
                                case .AlphaNumeric:
                                    self.allowedCharacters = AllLetters + PositiveWholeNumbers
                                case .AlphaNumericWithSpaces:
                                    self.allowedCharacters = AllLetters + PositiveWholeNumbers + " "
                                case .PositiveNumbers:
                                    self.allowedCharacters = PositiveWholeNumbers
                                case .PositiveFloats:
                                    self.allowedCharacters = PositiveFloats
                                case .NegativeNumbers, .WholeNumbers:
                                    self.allowedCharacters = WholeNumbers
                                case .NegativeFloats, .Floats:
                                    self.allowedCharacters = Floats
                                case .MACAddress:
                                    self.allowedCharacters = AllHex + "."
                                case .Name:
                                    self.allowedCharacters = AllLetters + "'" + "-"
                                case .CreditCard:
                                    self.allowedCharacters = PositiveWholeNumbers + " "
                                default:
                                    break
                                }
                            }
                        }
                    }
                    else{
                        self.validationType = .None
                    }
                }
            }
        }
    }
    public var validationType: ValidationType {
        get {
            let rawvalue = objc_getAssociatedObject(self, &AssociatedKeys.enumContext)
            if rawvalue == nil{
                self.allowedCharacters = ""
                return .None
            }else{
                return ValidationType(rawValue: rawvalue as! Int)!
            }
        }
        set {
            switch newValue {
            case .Email:
                self.allowedCharacters = Email
            case .Phone:
                self.allowedCharacters = Phone
            case .Zip, .SSN:
                self.allowedCharacters = Zip
            case .StreetAddress:
                self.allowedCharacters = Street
            case .IPAddress:
                self.allowedCharacters = IPAddress
            case .Money:
                self.allowedCharacters = Money
            case .Letters, .States:
                self.allowedCharacters = AllLetters
            case .LettersWithSpaces:
                self.allowedCharacters = AllLetters + " "
            case .AlphaNumeric:
                self.allowedCharacters = AllLetters + PositiveWholeNumbers
            case .AlphaNumericWithSpaces:
                self.allowedCharacters = AllLetters + PositiveWholeNumbers + " "
            case .PositiveNumbers:
                self.allowedCharacters = PositiveWholeNumbers
            case .PositiveFloats:
                self.allowedCharacters = PositiveFloats
            case .NegativeNumbers, .WholeNumbers:
                self.allowedCharacters = WholeNumbers
            case .NegativeFloats, .Floats:
                self.allowedCharacters = Floats
            case .MACAddress:
                self.allowedCharacters = AllHex + "."
            case .Name:
                self.allowedCharacters = AllLetters + "'" + "-"
            case .CreditCard:
                self.allowedCharacters = PositiveWholeNumbers + " "
            default:
                break
            }
            objc_setAssociatedObject(self, &AssociatedKeys.enumContext, newValue.rawValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var validationExpression: ValidationExpression? {
        get {
            let exp = objc_getAssociatedObject(self, &AssociatedKeys.valExpression)
            if exp == nil{
                return nil
            }else{
                return exp as? ValidationExpression
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.valExpression, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var allowedCharacters: String {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ac) as? String ?? ""
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.ac,
                newValue as NSString,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}
public extension String
{
    public var condensedWhitespace: String
    {
        let components = self.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return components.filter { !$0.isEmpty }.joinWithSeparator(" ")
    }
    
    public func shouldAllow(allowedCharacters: String...) -> Bool
    {
        if allowedCharacters.count == 1 && allowedCharacters[0] == ""{
            return true
        }
        let characterSet = NSMutableCharacterSet()
        
        for str in allowedCharacters
        {
            characterSet.addCharactersInString(str)
        }
        
        return !(self.rangeOfCharacterFromSet(characterSet.invertedSet) != nil)
    }
}
