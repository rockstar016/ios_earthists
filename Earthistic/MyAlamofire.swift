//
//  FHAlamofire.swift
//  fithabit
//
//  Created by VietND on 7/22/16.
//  Copyright © 2016 fithabit. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import MBProgressHUD

var  spiningActivity:MBProgressHUD?=nil
var KEYWINDOW = UIApplication.sharedApplication().keyWindow?.rootViewController

class MyAlamofire: Manager {
    
    class var shareInstance: MyAlamofire {
        get {
            struct Static {
                static var instance: MyAlamofire? = nil
                static var token: dispatch_once_t = 0
            }
            dispatch_once(&Static.token, {
                let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
                configuration.timeoutIntervalForRequest = 60.0
                configuration.timeoutIntervalForResource = 60.0
                let manager = MyAlamofire(configuration: configuration)
                Static.instance = manager

            })
            return Static.instance!
        }
    }
    class  func POST(url: String, parameters: [String: AnyObject],showLoading:Bool,showSuccess:Bool,showError:Bool,search:Bool, completionHandler: (result:Bool,responseObject:NSDictionary) -> Void) -> Request {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        if showLoading {
            showIndicator()
        }
        let headers = [
            "Accept":"application/json",
        ]
        if search == true {
            return MyAlamofire.shareInstance.request(.POST, url, parameters: parameters, headers: headers ).validate().responseJSON { response in
                switch response.result {
                    
                case .Success(let JSON):
                    
                    let res = JSON as! NSArray
                    let retval = ["data":res]
                    completionHandler( result: true,responseObject: retval)
                    
                case .Failure(let error):
                    switch error.code {
                    case -1005:
                        //self.displayError(error.localizedDescription)
                        break
                    default:
                        print(error.localizedDescription)
                        break
                    }
                    completionHandler( result: false,responseObject:[:])
                }
                hideIndicator()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }
 
        return MyAlamofire.shareInstance.request(.POST, url, parameters: parameters, headers: headers ).validate().responseJSON { response in
            
            
            switch response.result {
                    
                case .Success(let JSON):
                    
                    let res = JSON as! NSDictionary

                    completionHandler( result: true,responseObject: res)
                    
                case .Failure(let error):
                    var res:NSDictionary!

                    switch error.code {
                    case -6003:
                        if(response.response?.statusCode == 401)
                        {
                            do{
                                let retval = try NSJSONSerialization.JSONObjectWithData(response.data!, options: [])
                                res = retval as! NSDictionary
                                completionHandler( result: false,responseObject:res)
                            }
                            catch
                            {
                                print("err")
                            }
                        }
                        if(response.response?.statusCode == 400)
                        {
                            do{
                                let retval = try NSJSONSerialization.JSONObjectWithData(response.data!, options: [])
                                res = retval as! NSDictionary
                                completionHandler( result: false,responseObject:res)
                            }
                            catch
                            {
                                print("err")
                            }
                        }
                        
                        break
                    default:
                        print(error.localizedDescription)
                        break
                    }
                    
                    
                    completionHandler( result: false,responseObject:[:])
                }
                hideIndicator()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
    }
    class func GET(url: String, parameters: [String: AnyObject],showLoading:Bool,showSuccess:Bool,showError:Bool, search : Bool, completionHandler: (result:Bool,responseObject:NSDictionary) -> Void) -> Request {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if showLoading {
            showIndicator()
        }
        if search == true {
            return MyAlamofire.shareInstance.request(.GET, url, parameters: parameters)
                .validate().responseJSON { response in
                    switch response.result {
                    case .Success(let JSON):
                        let res = JSON as! NSArray
                        let resval = ["data" : res]
                        if let ok = resval["ok"] as? Bool {
                            if ok{
                                if resval["message"] != nil && showSuccess{
                                    self.displaySuccess(resval["message"] as? String ?? "")
                                }
                                completionHandler( result: true,responseObject:resval)
                            }else{
                                if resval["message"] != nil && showError{
                                    self.displayError(resval["message"] as! String)
                                }
                                completionHandler( result: false,responseObject: resval)
                            }
                        }
                        
                    case .Failure(let error):
                        print(error)
                        switch error.code {
                        case -1005:
                            //self.displayError(error.localizedDescription)
                            break
                        default:
                            break
                        }
                        completionHandler( result: false,responseObject:[:])
                    }
                    hideIndicator()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }

        }
        return MyAlamofire.shareInstance.request(.GET, url, parameters: parameters)
            .validate().responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    let res = JSON as! NSDictionary
                    if let ok = res["ok"] as? Bool {
                        if ok{
                            if res["message"] != nil && showSuccess{
                                self.displaySuccess(res["message"] as? String ?? "")
                            }
                            completionHandler( result: true,responseObject:res)
                        }else{
                            if res["message"] != nil && showError{
                                self.displayError(res["message"] as! String)
                            }
                            completionHandler( result: false,responseObject: res)
                        }
                    }
                    
                case .Failure(let error):
                    print(error)
                    switch error.code {
                    case -1005:
                        self.displayError(error.localizedDescription)
                        break
                    default:
                        break
                    }
                    completionHandler( result: false,responseObject:[:])
                }
                hideIndicator()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
    }
    
    class func GET2(url: String, parameters: [String: AnyObject],showLoading:Bool,showSuccess:Bool,showError:Bool, search : Bool, completionHandler: (result:Bool,responseObject:AnyObject) -> Void) -> Request {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
       
        
        if(search)
        {
            return MyAlamofire.shareInstance.request(.GET, url, parameters: parameters)
                .validate().responseJSON { response in
                    switch response.result {
                    case .Success(let JSON):
                        let res = JSON as! NSArray
                        let resval = ["data" : res]
                        completionHandler( result: true,responseObject:resval)
                        
                    case .Failure(let error):
                        print(error)
                        switch error.code {
                        case -1005:
                            self.displayError(error.localizedDescription)
                            break
                        default:
                            break
                        }
                        completionHandler( result: false,responseObject:[])
                    }
                    //hideIndicator()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }else{
            if showLoading {
                showIndicator()
            }
            return MyAlamofire.shareInstance.request(.GET, url, parameters: parameters)
                .validate().responseJSON { response in
                    switch response.result {
                    case .Success(let JSON):
                        completionHandler( result: true,responseObject:JSON)
                        
                    case .Failure(let error):
                        print(error)
                        switch error.code {
                        case -1005:
                            self.displayError(error.localizedDescription)
                            break
                        default:
                            break
                        }
                        completionHandler( result: false,responseObject:[])
                    }
                    hideIndicator()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }

        }

        
    }
    class func Delete(url: String, parameters: [String: AnyObject],showLoading:Bool,showSuccess:Bool,showError:Bool, search : Bool, completionHandler: (result:Bool,responseObject:AnyObject) -> Void) -> Request {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

            return MyAlamofire.shareInstance.request(.DELETE, url, parameters: parameters)
                .validate().responseJSON { response in
                    switch response.result {
                    case .Success(let JSON):
                        let res = JSON as! NSDictionary
                        completionHandler( result: true,responseObject:res)
                        
                    case .Failure(let error):
                        print(error)
                        switch error.code {
                        case -1005:
                            self.displayError(error.localizedDescription)
                            break
                        default:
                            break
                        }
                        completionHandler( result: false,responseObject:[])
                    }
                    //hideIndicator()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
               }
    }
    class func PATCH(url: String, parameters: [String: AnyObject],showLoading:Bool,showSuccess:Bool,showError:Bool, search : Bool, completionHandler: (result:Bool,responseObject:AnyObject) -> Void) -> Request {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        return MyAlamofire.shareInstance.request(.PATCH, url, parameters: parameters)
            .validate().responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    let res = JSON as! NSDictionary
                    completionHandler( result: true,responseObject:res)
                    
                case .Failure(let error):
                    print(error)
                    switch error.code {
                    case -1005:
                        self.displayError(error.localizedDescription)
                        break
                    default:
                        break
                    }
                    completionHandler( result: false,responseObject:[])
                }
                //hideIndicator()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }


    class func displaySuccess(message:String){
        // Display an alert message
        let myAlert = UIAlertController(title: "Success", message:message, preferredStyle: UIAlertControllerStyle.Alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
        myAlert.addAction(okAction);

        while let presentVC = KEYWINDOW?.presentedViewController
        {
            KEYWINDOW = presentVC
        }
        KEYWINDOW?.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    class func displayError(message:String){
        // Display an alert message
        let myAlert = UIAlertController(title: "Caution", message:message, preferredStyle: UIAlertControllerStyle.Alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
        myAlert.addAction(okAction);
        
        while let presentVC = KEYWINDOW?.presentedViewController
        {
            KEYWINDOW = presentVC
        }
        KEYWINDOW?.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    class  func showIndicator() {
        spiningActivity = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow!, animated: true)
        spiningActivity?.label.text = "Loading"
    }
    
    class func hideIndicator(){
        if spiningActivity?.superview != nil {
            spiningActivity?.removeFromSuperview()
        }
    }
    
}





