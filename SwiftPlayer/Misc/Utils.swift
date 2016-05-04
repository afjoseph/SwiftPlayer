//
//  Utils.swift
//  SwiftPlayer
//
//  Created by Abdullah Joseph on 3/24/16.
//

import Foundation
import UIKit

class Utils {
}

extension Utils {
    static func jsonStringToDict(src: NSString) -> NSDictionary? {
        // convert String to NSData
        let data = src.dataUsingEncoding(NSUTF8StringEncoding)
        var error: NSError?
        
        // convert NSData to 'AnyObject'
        let anyObj: AnyObject?
        do {
            anyObj = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
        } catch let error1 as NSError {
            error = error1
            anyObj = nil
        }
        
        if(error != nil) {
            // If there is an error parsing JSON, print it to the console
            print("JSON Error \(error!.localizedDescription)")
            //self.showError()
            return nil
        } else {
            return anyObj as? NSDictionary
        }
    }
}

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
}

extension UIViewController {
    func showAlertViewController(message:String, buttonMessage:String = "Dismiss",
        handler: ((UIAlertAction) -> Void)? = nil) {
            let alertController = UIAlertController(title: "Library", message:
                message, preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: buttonMessage, style: UIAlertActionStyle.Default,handler: handler))
        
            self.presentViewController(alertController, animated: true, completion: nil)
    }
}
