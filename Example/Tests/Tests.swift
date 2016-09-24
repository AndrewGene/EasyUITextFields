import UIKit
import XCTest
import WASHD
@testable import WASHD_Example

class Tests: XCTestCase {
    var vc:ViewController!
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc = storyboard.instantiateInitialViewController() as! ViewController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidCreditCard()
    {
        let _ = vc.view
        vc.txtIB.text = "4485209100028409"
        vc.txtIB.validationType = ValidationType.creditCard
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidEmail() {
        let _ = vc.view
        //vc.txtIB.text! = "hi"
        //vc.txtIB.typeText("hi")
        vc.txtIB.text = "andrew@gmail.com"
        vc.txtIB.validationType = ValidationType.email
        XCTAssertTrue(vc.txtIB.validate().isValid)
        //XCTAssert((vc.txtIB.text == "hi") == true)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testValidName()
    {
        let _ = vc.view
        vc.txtIB.text = "D'martin-James"
        vc.txtIB.validationType = ValidationType.name
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidState()
    {
        let _ = vc.view
        vc.txtIB.text = "OR"
        vc.txtIB.validationType = ValidationType.states
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidText()
    {
        let _ = vc.view
        vc.txtIB.text = "This is text now, for some symbols found in text.!&;:"
        vc.txtIB.validationType = ValidationType.text
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidSSN()
    {
        let _ = vc.view
        vc.txtIB.text = "156-98-3258"
        vc.txtIB.validationType = ValidationType.ssn
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidAllFloats()
    {
        let _ = vc.view
        vc.txtIB.text = "123.2558"
        vc.txtIB.validationType = ValidationType.floats
        XCTAssertTrue(vc.txtIB.validate().isValid)
        vc.txtIB.text = "-123.2558"
        vc.txtIB.validationType = ValidationType.floats
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidNegativeNumbers()
    {
        let _ = vc.view
        vc.txtIB.text = "-123456"
        vc.txtIB.validationType = ValidationType.negativeNumbers
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidPositiveNumbers()
    {
        let _ = vc.view
        vc.txtIB.text = "123456"
        vc.txtIB.validationType = ValidationType.positiveNumbers
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidAlphaNumWithSpaces()
    {
        let _ = vc.view
        vc.txtIB.text = "asdfeccv ef123 15"
        vc.txtIB.validationType = ValidationType.alphaNumericWithSpaces
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidAlphaNum()
    {
        let _ = vc.view
        vc.txtIB.text = "asdfeccvef12315"
        vc.txtIB.validationType = ValidationType.alphaNumeric
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidLettersWithSpaces()
    {
        let _ = vc.view
        vc.txtIB.text = "asdfec cvef"
        vc.txtIB.validationType = ValidationType.lettersWithSpaces
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidLetters()
    {
        let _ = vc.view
        vc.txtIB.text = "asdfeccvef"
        vc.txtIB.validationType = ValidationType.letters
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidURL()
    {
        let _ = vc.view
        vc.txtIB.text = "https://adfasdfasd.com"
        vc.txtIB.validationType = ValidationType.url
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidGPSPoint()
    {
        let _ = vc.view
        vc.txtIB.text = "-12.2,12.5"
        vc.txtIB.validationType = ValidationType.gpsPoint
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidGPSCoordinate()
    {
        let _ = vc.view
        vc.txtIB.text = "-12.2"
        vc.txtIB.validationType = ValidationType.gpsCoordinate
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testMACAddress()
    {
        let _ = vc.view
        vc.txtIB.text = "005370871040"
        vc.txtIB.validationType = ValidationType.macAddress
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testWholeNumbers()
    {
        let _ = vc.view
        vc.txtIB.text = "123"
        vc.txtIB.validationType = ValidationType.wholeNumbers
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidNegativeFloats()
    {
        let _ = vc.view
        vc.txtIB.text = "-1.25"
        vc.txtIB.validationType = ValidationType.negativeFloats
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidPositiveFloats()
    {
        let _ = vc.view
        vc.txtIB.text = "1.25"
        vc.txtIB.validationType = ValidationType.positiveFloats
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidFloats()
    {
        let _ = vc.view
        vc.txtIB.text = "1.25"
        vc.txtIB.validationType = ValidationType.floats
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidStreet()
    {
        let _ = vc.view
        vc.txtIB.text = "867 Fendley Drive Apt A2"
        vc.txtIB.validationType = ValidationType.streetAddress
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidIPAddress()
    {
        let _ = vc.view
        vc.txtIB.text = "192.168.255.255"
        vc.txtIB.validationType = ValidationType.ipAddress
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidMoney()
    {
        let _ = vc.view
        vc.txtIB.text = "$500.23"
        vc.txtIB.validationType = ValidationType.money
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidZip()
    {
        let _ = vc.view
        vc.txtIB.text = "72032"
        vc.txtIB.validationType = ValidationType.zip
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testValidPhoneNumber()
    {
        let _ = vc.view
        vc.txtIB.text = "5018587091"
        vc.txtIB.validationType = ValidationType.phone
        XCTAssertTrue(vc.txtIB.validate().isValid)
    }
    func testStringFormat()
    {
        let _ = vc.view
        vc.txtAdvanced.text = "1234"
        vc.txtAdvanced.format = "xx / xx"
        print(vc.txtAdvanced.text)
        XCTAssertTrue(vc.txtAdvanced.text == "12 / 34")
    }
    func testStringMaxLength()
    {
        let _ = vc.view
        vc.txtIB.maxLength = 3
        XCTAssertTrue(vc.txtIB.reachedMaxLength(NSMakeRange(0, 0), string: "33135"))
    }
    func testFindTextInputs()
    {
        let _ = vc.view
        vc.findAllTextInputs()
        XCTAssertTrue(vc.textInputArray.count > 0)
    }
    func assertFirstResponder(_ textField:UITextField)
    {
        XCTAssert(textField.isFirstResponder)
    }
    func testMoveNext()
    {
        let _ = vc.view
        vc.findAllTextInputs()
        vc.txtIB.jumpOrder = 0
        vc.txtProgrammatic.jumpOrder = 1
        vc.txtIB.becomeFirstResponder()
        vc.txtIB.text = "123"
        vc.currentjumpOrder = 0
        vc.moveNext()
        XCTAssertTrue(vc.currentjumpOrder == 1)
    }
    func testMoveOnFormat(){
        let _ = vc.view
        vc.findAllTextInputs()
        vc.txtIB.jumpOrder = 0
        vc.txtIB.formatJump = true
        vc.txtProgrammatic.jumpOrder = 1
        vc.txtIB.becomeFirstResponder()
        vc.currentjumpOrder = 0
        vc.txtIB.format = "xx / xx"
        vc.txtIB.text = "12 / 3"
        let _ = vc.txtIB.formatText("4")
        RunLoop.current.run(until: Date().addingTimeInterval(0.5))
        XCTAssertTrue(vc.currentjumpOrder == 1)
        //self.performSelector(Selector("assertFirstResponder:"), withObject: vc.txtIB3, afterDelay: 0.0)
    }
    
    func testMoveOnMaxLength(){
        let _ = vc.view
        vc.findAllTextInputs()
        vc.txtIB.jumpOrder = 0
        vc.txtIB.lengthJump = true
        vc.txtProgrammatic.jumpOrder = 1
        vc.txtIB.becomeFirstResponder()
        vc.currentjumpOrder = 0
        vc.txtIB.maxLength = 4
        vc.txtIB.text = "123"
        let _ = vc.txtIB.reachedMaxLength(NSMakeRange(3, 0), string: "4")
        RunLoop.current.run(until: Date().addingTimeInterval(0.5))
        XCTAssertTrue(vc.currentjumpOrder == 1)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
