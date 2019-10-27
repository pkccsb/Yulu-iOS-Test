//
//  Control.swift
//  Yulu-iOS-Test
//
//  Created by Praveen on 23/10/19.
//  Copyright © 2019 Praveen. All rights reserved.
//

import UIKit
import Alamofire

class Control: NSObject {
    
    static func hasError(response:DataResponse<Any>) -> NSError?
    {
        if let value = response.result.value as? [String:AnyObject]
        {
            if let httpResponse = response.response
            {
                switch httpResponse.statusCode
                {
                case 200:
                    
                    if let value = response.result.value as? [String:AnyObject]
                    {
                        if let statusCode = value["status_code"] as? Int, let message = value["message"] as? String
                        {
                            return NSError.init(domain: NSLocalizedString("general.appname", comment: ""), code: statusCode, userInfo: ["message":message])
                        }
                    }
                    
                case 201:
                    
                    if let value = response.result.value as? [String:AnyObject]
                    {
                        if let statusCode = value["status_code"] as? Int, let message = value["message"] as? String
                        {
                            return NSError.init(domain: NSLocalizedString("general.appname", comment: ""), code: statusCode, userInfo: ["message":message])
                        }
                    }
                    
                default:
                    
                    if let error = value["error"] as? String
                    {
                        return NSError.init(domain: NSLocalizedString("general.appname", comment: ""), code: httpResponse.statusCode, userInfo: ["message":error])
                    }
                    else if let errorDict = value["error"] as? [String:AnyObject]
                    {
                        if let message = errorDict["message"] as? String
                        {
                            if let code = errorDict["code"] as? String
                            {
                                return NSError.init(domain: NSLocalizedString("general.appname", comment: ""), code: httpResponse.statusCode, userInfo: ["message":message, "code":code])
                            }
                            else {
                                return NSError.init(domain: NSLocalizedString("general.appname", comment: ""), code: httpResponse.statusCode, userInfo: ["message":message])
                            }
                        }
                        else {
                            return Control.undefinedError()
                        }
                    }
                    else if let errors = value["errors"] as? [String:AnyObject]
                    {
                        var errorMessage = ""
                        for (_, errorMessages) in errors
                        {
                            if let messages = errorMessages as? [String]
                            {
                                for message in messages {
                                    
                                    errorMessage = "\(errorMessage) " + message
                                    
                                }
                            }
                        }
                        return NSError.init(domain: NSLocalizedString("general.appname", comment: ""), code: httpResponse.statusCode, userInfo: ["message":errorMessage])
                    }
                    else if let message = value["error_msg"] as? String
                    {
                        return NSError.init(domain: NSLocalizedString("general.appname", comment: ""), code: httpResponse.statusCode, userInfo: ["message":message])
                    }
                    else if let message = value["message"] as? String
                    {
                        if let code = value["code"] as? String
                        {
                            return NSError.init(domain: NSLocalizedString("general.appname", comment: ""), code: httpResponse.statusCode, userInfo: ["message":message, "code":code])
                        }
                        else {
                            return NSError.init(domain: NSLocalizedString("general.appname", comment: ""), code: httpResponse.statusCode, userInfo: ["message":message])
                        }
                    }
                    else
                    {
                        return Control.undefinedError()
                    }
                }
            }
        }
        
        return nil
    }
    
    static func undefinedError() -> NSError
    {
        return NSError.init(domain: NSLocalizedString("general.appname", comment: ""), code: -1, userInfo: ["message":NSLocalizedString("general.error.undefined", comment: "")])
    }
}
