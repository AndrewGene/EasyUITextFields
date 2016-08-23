//
//  JumpOrder.swift
//  UITextFieldExtensions
//
//  Created by Andrew Goodwin on 8/19/16.
//  Copyright © 2016 Andrew Goodwin. All rights reserved.
//

import Foundation
import UIKit

private struct AssociatedKeys {
    static var fri = "jumpOrder"
    static var fra = "firstResponderArray"
    static var cfri = "currentjumpOrder"
    static var mnd = "moveNextDate"
    static var mnt = "moveNextTimer"
    static var fj = "formatJump"
    static var lj = "lengthJump"
    static var fn = "formatNotification"
    static var ln = "lengthNotification"
    static var tfn = "textFormatNotification"
    static var tln = "textLengthNotification"
}

@IBDesignable
public extension UITextField
{    
    @IBInspectable
    public var formatJump: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.fj) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.fj, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBInspectable
    public var lengthJump: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.lj) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.lj, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var textLengthNotification: AnyObject? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.tln) ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tln, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var textFormatNotification: AnyObject? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.tfn) ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tfn, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBInspectable
    public var jumpOrder: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.fri) as? Int ?? -1
        }
        set {
            if textFormatNotification != nil{
                NSNotificationCenter.defaultCenter().removeObserver(textFormatNotification!)
            }
           textFormatNotification = NSNotificationCenter.defaultCenter().addObserverForName("text.MoveNext.Format", object: nil, queue: NSOperationQueue.mainQueue()) { [weak self](notification) in
                if self!.formatJump{
                    NSNotificationCenter.defaultCenter().postNotificationName("firstResponder.MoveNext.Format", object: nil)
                }
            }
            if textLengthNotification != nil{
                NSNotificationCenter.defaultCenter().removeObserver(textLengthNotification!)
            }
            textLengthNotification = NSNotificationCenter.defaultCenter().addObserverForName("text.MoveNext.MaxLength", object: nil, queue: NSOperationQueue.mainQueue()) { [weak self](notification) in
                if self!.lengthJump{
                    NSNotificationCenter.defaultCenter().postNotificationName("firstResponder.MoveNext.MaxLength", object: nil)
                }
            }
            objc_setAssociatedObject(self, &AssociatedKeys.fri, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func getjumpOrder()->Int{
        return jumpOrder
        //NSNotificationCenter.defaultCenter().postNotificationName("firstResponder.MoveNext", object: jumpOrder + 1)
    }
}

@IBDesignable
public extension UITextView
{
    @IBInspectable
    public var jumpOrder: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.fri) as? Int ?? -1
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.fri, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func getjumpOrder()->Int{
        return jumpOrder
        //NSNotificationCenter.defaultCenter().postNotificationName("firstResponder.MoveNext", object: jumpOrder + 1)
    }
}

public extension UIViewController{
    
    public var currentjumpOrder: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.cfri) as? Int ?? -1
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.cfri, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var textInputArray: [UIView] {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.fra) as? [UIView] ?? [UIView]()
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.fra,
                newValue as [UIView]?,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    private var moveNextDate: NSDate? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.mnd) as? NSDate ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.mnd, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    private var formatNotification: AnyObject? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.fn) ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.fn, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    private var lengthNotification: AnyObject? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ln) ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ln, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func moveNext(){
        self.moveNextDate = NSDate()
        for view in self.textInputArray{
            if view is UITextField{
                let tf = view as! UITextField
                if tf.jumpOrder == currentjumpOrder + 1{
                    tf.becomeFirstResponder()
                    currentjumpOrder = tf.jumpOrder
                    break
                }
            }
            else if view is UITextView{
                let tf = view as! UITextView
                if tf.jumpOrder == currentjumpOrder + 1{
                    tf.becomeFirstResponder()
                    currentjumpOrder = tf.jumpOrder
                    break
                }
            }
        }
    }
    
    public func findAllTextInputs(){
        self.textInputArray = [UIView]()
        if formatNotification != nil{
            NSNotificationCenter.defaultCenter().removeObserver(formatNotification!)
        }
        formatNotification = NSNotificationCenter.defaultCenter().addObserverForName("firstResponder.MoveNext.Format", object: nil, queue: NSOperationQueue.mainQueue()) { [weak self](notification) in
            if self!.moveNextDate == nil{
                //nothing has fired before
                self!.moveNext()
            }
            else if self!.moveNextDate != nil{
                //print(self!.moveNextDate!.timeIntervalSinceNow)
                if abs(self!.moveNextDate!.timeIntervalSinceNow) < 0.1{
                    //do nothing
                }
                else{
                    self!.moveNext()
                }
            }            
        }
        if lengthNotification != nil{
            NSNotificationCenter.defaultCenter().removeObserver(lengthNotification!)
        }
        lengthNotification = NSNotificationCenter.defaultCenter().addObserverForName("firstResponder.MoveNext.MaxLength", object: nil, queue: NSOperationQueue.mainQueue()) { [weak self](notification) in
            if self!.moveNextDate == nil{
                //nothing has fired before
                self!.moveNext()
            }
            else if self!.moveNextDate != nil{
                //print(self!.moveNextDate!.timeIntervalSinceNow)
                if abs(self!.moveNextDate!.timeIntervalSinceNow) < 0.1{
                    //do nothing
                }
                else{
                    self!.moveNext()
                }
            }
        }
        findAllTextInputsInView(self.view)
    }
    
    private func findAllTextInputsInView(inputView:UIView){
        for view in inputView.subviews{
            if view.respondsToSelector(#selector(UITextField.getjumpOrder)) || view.respondsToSelector(#selector(UITextView.getjumpOrder)){
                if view is UITextField{
                    textInputArray.append(view)
                    if view.subviews.count > 0{
                        findAllTextInputsInView(view)
                    }
                }
            }
        }
    }
}
