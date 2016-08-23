# WASHD - What Apple Should Have Done
##The easiest way to add validation, text filtering, max length, and text field order to your UITextFields

###The best part is that you don't have to subclass UITextField--this is made using extensions

[![Version](https://img.shields.io/cocoapods/v/WASHD.svg?style=flat)](http://cocoapods.org/pods/WASHD)
[![License](https://img.shields.io/cocoapods/l/WASHD.svg?style=flat)](http://cocoapods.org/pods/WASHD)
[![Platform](https://img.shields.io/cocoapods/p/WASHD.svg?style=flat)](http://cocoapods.org/pods/WASHD)

## Requirements
- ARC
- iOS 8

## Installation

WASHD is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "WASHD"
```
##Usage
###Interface Builder
![IB](/IBScreenshot.png?raw=true "Interface Builder")

##Required Code
**To Support UITextField "jump order"**
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    self.findAllTextInputs() //find all text inputs in the view controller for jump order process
}

func textFieldDidBeginEditing(textField: UITextField) {
    self.currentjumpOrder = textField.jumpOrder //set current jump order
}
    
func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.moveNext() //move to the next text input in order
    return true
}
```
"Jump Order" refers to the order in which UITextFields will be given first responder on press of the "Return" button (like tab order in web development)

*Jump Order also works on UITextView* :punch:

**To support max length, text filtering, and text formatting**

```swift
func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if textField.reachedMaxLength(range, string: string) || !string.shouldAllow(textField.allowedCharacters){
        return false
    }
    return textField.formatText(string)
}
```
*Even if you haven't set a format on a UITextField, you can still use "textField.formatText(string)".  It will simply return true.*

**To validate before form submission (test every UITextField you want validated)**
```swift
let result = txtCreditCard.validate() //returns ValidationResult (see below)
if result.isValid
{
  print(result.transformedString)
}
else
{
  print(result.failureMessage)
}
```
#That's it!

**Validation Result**
```swift
class ValidationResult
{
    var isValid = false
    var failureMessage : String? = nil
    var transformedString : String = ""
    //...
}
```

**Built-in validation types**

```swift
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
```


###You can also set everything up programatically
```swift
txtCreditCard.validationType = .CreditCard
txtCreditCard.format = "xxxx xxxx xxxx xxxx"
txtCreditCard.maxLength = 19
txtCreditCard.jumpOrder = 1
```

#Individual Enchancement Breakdown

##Supporting Max Length
```swift
func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool 
{
  if textField.reachedMaxLength(range, string: string)
    return false
  }
  return true
}
```

##Filtering UITextField

###It's built in if you use validation!

**(e.g. a textfield with a validationType set to ".Zip" (i.e. txtZip.validationType = .Zip) will get have txtZip.allowedCharacters set to the Zip constant below)**

**Simply add this code to the "...shouldChangeCharactersInRange..." UITextField delegate method...**
```swift
func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool 
{
  if !string.shouldAllow(textField.allowedCharacters)
    return false
  }
  return true
}
```

**UITextField predefined strings**
```swift
let UpperCaseLetters = "ABCDEFGHIJKLKMNOPQRSTUVWXYZ"
let LowerCaseLetters = "abcdefghijklmnopqrstuvwxyz"
let AllLetters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ"
let UpperCaseHex = "0123456789ABCDEF"
let LowerCaseHex = "0123456789abcdef"
let AllHex = "0123456789abcdefABCDEF"
let PositiveWholeNumbers = "0123456789"
let WholeNumbers = "-0123456789"
let PositiveFloats = "0123456789."
let Floats = "-0123456789."
let Email = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789_-+@.%"
let Street = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789 -#.&"
let IPAddress = "0123456789."
let Money = "0123456789.$"
let Phone = "0123456789.()- "
let Zip = "0123456789-“
```

###Alternatively, you can add your own using "shouldAllow(String...)"
```swift
func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool 
{
  return string.shouldAllow(Numbers, "@#$") // you can enter several different strings of characters to allow
}
```

##Validation

###Declare your own — simple expression...
```swift
let zip = ValidationExpression(expression: "^\\d{5}(-\\d{4})?$", description: "Zip Code",failureDescription: "Invalid Zip Code”) 
```
…and apply it to a UITextField programmatically 
```swift
txtZip.validationExpression = zip
```

###More advanced validation
* adds sub-rules for more user friendly hints on how to fix a problem
* text transformation / cleaning **(Transformation is done BEFORE validation and is optional)**

```swift
let zip = ValidationExpression(expression: "^\\d{5}(-\\d{4})?$", description: "Zip Code",failureDescription: "Invalid Zip Code", hints: [
  ValidationRule(priority: 1, expression: "\\d{5}", failureDescription: "Zip code must be 5 characters"),
  ValidationRule(priority: 0, expression: "[0-9]+", failureDescription: "Not numbers"),
  ],transformText: 
    { (zipcode) in
      var myString = zipcode
      myString = myString?.stringByReplacingOccurrencesOfString(" ", withString: "")
      return myString!
    }
  ,furtherValidation:nil)
```


###Most advanced
* hints
* input text transformation
* further validation

**4242 4242 4242 4243** is a credit card number that passes the regular expression check.  However, the further validation performs a Luhn check that all credit cards must pass (you can read more here: (https://en.wikipedia.org/wiki/Luhn_algorithm).

The furtherValidation closure has the transformed text as a parameter and returns a Validation Result object

**NOTE** *condensedWhitespace is a helper variable that gets rid of multiple side-by-side spaces in case a user mistypes into the field in IB*
```swift
let creditCard = ValidationExpression(expression: "^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\\d{3})\\d{11})$",
            description: "Debit or Credit Card",
            failureDescription: "Invalid card",
            hints: [ValidationRule(priority: 0, expression: "\\d+", failureDescription: "Missing Numbers")],
            transformText:
            { (card) in
                var myString = card
                myString = myString?.condensedWhitespace.stringByReplacingOccurrencesOfString(" ", withString: "") 
                return myString!
            },
            furtherValidation:{[weak self] (card) in
            if (self?.luhnTest(card))!
            {
                return ValidationResult(isValid: true, failureMessage: nil, transformedString: card)
            }
            else
            {
                return ValidationResult(isValid: false, failureMessage: "Card failed Luhn check", transformedString: card)
            }
})

func luhnTest(number: String) -> Bool
{
    let noSpaceNum = number.condensedWhitespace
    let reversedInts = noSpaceNum.characters.reverse().map{
        Int(String($0))
    }
    return reversedInts.enumerate().reduce(0, combine: {(sum, val) in let odd = val.index % 2 == 1
        return sum + (odd ? (val.element! == 9 ? 9 : (val.element! * 2) % 9) : val.element!)
    }) % 10 == 0
}
```


##TODOs
- [x] Add character filtering
- [ ] Add more useful hints for several validationTypes
- [ ] Update code to Swift 3

###Please feel free to make a pull request and add more commonly-used validations

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.



## Author

Andrew Goodwin, andrewggoodwin@gmail.com :)

## License

WASHD is available under the MIT license. See the LICENSE file for more info.
