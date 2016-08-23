//
//  Maxlength.swift
//
//  Created by Andrew Goodwin on 8/16/16.
//  Copyright © 2016 Conway Corporation. All rights reserved.
//

import Foundation
import UIKit

private struct AssociatedKeys {
    static var len = "length"
}

@IBDesignable
public extension UITextField
{
    @IBInspectable
    public var maxLength: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.len) as? Int ?? Int.max
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.len, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func reachedMaxLength(range:NSRange, string:String)->Bool{
        let oldLength = self.text!.characters.count
        let replacementLength = string.characters.count
        let rangeLength = range.length
        let newLength = oldLength - rangeLength + replacementLength
        
        let returnKey = string.rangeOfString("\n") != nil
        let isBackspace = string == ""
        let shouldAllow = newLength <= self.maxLength || returnKey || isBackspace
        if self.maxLength == newLength{
            //do i support auto first responder
            NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(goNext), userInfo: nil, repeats: false)
        }
        return !shouldAllow
    }
    
    @objc private func goNext(){
         NSNotificationCenter.defaultCenter().postNotificationName("text.MoveNext.MaxLength", object: nil)
    }
    
}

@IBDesignable
public extension UITextView
{
    @IBInspectable
    public var maxLength: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.len) as? Int ?? Int.max
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.len, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func reachedMaxLength(range:NSRange, string:String)->Bool{
        let oldLength = self.text!.characters.count
        let replacementLength = string.characters.count
        let rangeLength = range.length
        let newLength = oldLength - rangeLength + replacementLength
        
        let returnKey = string.rangeOfString("\n") != nil
        let isBackspace = string == ""
        let shouldAllow = newLength <= self.maxLength || returnKey || isBackspace
        if self.maxLength == newLength{
            //do i support auto first responder
            NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(goNext), userInfo: nil, repeats: false)
        }
        return shouldAllow
    }
    
    @objc private func goNext(){
        NSNotificationCenter.defaultCenter().postNotificationName("text.MoveNext.MaxLength", object: nil)
    }
    
}
