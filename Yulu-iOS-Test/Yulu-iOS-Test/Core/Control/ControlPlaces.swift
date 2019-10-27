//
//  ControlPlaces.swift
//  Yulu-iOS-Test
//
//  Created by Praveen on 23/10/19.
//  Copyright © 2019 Praveen. All rights reserved.
//

import UIKit
import Alamofire

class ControlPlaces: Control {

    //Fetch Places
    static func fetchPlaceDetails(resultHandler:@escaping ([PlaceInfo]?, NSError?) -> Void)
    {
        let urlString = Config.Api.PlacesApi.Places.URL
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(request).responseJSON { response in
            
            switch response.result
            {
            case .success:
                
                if let error = Control.hasError(response: response)
                {
                    resultHandler(nil, error)
                }
                else
                {
                    var history = [PlaceInfo]()
                    if let json = response.result.value as? [[String:AnyObject]]
                    {
                        print("fetchPlaceDetails response == \(json) \n")
                        history = json.map({ PlaceInfo(JSON: $0)! })
                    }
                    resultHandler(history, nil)
                }
                
            case .failure(_):
                var error = response.error as NSError?
                if error == nil {
                    error = Control.undefinedError()
                }
                resultHandler(nil, error)
            }
        }
    }
    
    //For Fetch - Place Info based on Place Id
    static func fetchPlaceInfo(placeId:String!, resultHandler:@escaping (PlaceInfo?,NSError?) -> Void)
    {
        let urlString = String(format: Config.Api.PlacesApi.PlacesUsingID.URL, placeId!)
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(request).responseJSON { response in
            
            switch response.result
            {
            case .success:
                
                if let error = Control.hasError(response: response)
                {
                    resultHandler(nil, error)
                }
                else
                {
                    var placeInfo:PlaceInfo?
                    if let json = response.result.value as? [String:AnyObject]
                    {
                        print("fetchPlaceInfo response == \(json) \n")
                        placeInfo = PlaceInfo(JSON:json)
                    }
                    resultHandler(placeInfo, nil)
                }
                
            case .failure(_):
                
                var error = response.error as NSError?
                if error == nil {
                    error = Control.undefinedError()
                }
                resultHandler(nil, error)
            }
        }
    }
    
    //For Add/Update - Place Info (with/without image upload)
    static func performPlaceUpdation(placeId:String?, dict:NSMutableDictionary, resultHandler:@escaping (PlaceInfo?,NSError?) -> Void) {
        
        //if imageData is present means add/update place info with image upload, otherwise without image upload
        if let imageData = dict["image"] as? Data, imageData.count > 0 {
            //if placeId is present means update place info otherwise add as new
            ControlPlaces.performAddOrUpdatePlaceInfoWithImageUpload(dict: dict, placeId: placeId, resultHandler: { (result, error) in
                resultHandler(result, error)
            })
        }
        else {
            //if placeId is present means update place info otherwise add as new
            ControlPlaces.performAddOrUpdatePlaceInfo(dict: dict, placeId: placeId, resultHandler: { (result, error) in
                resultHandler(result, error)
            })
        }
        
    }
    
    //For Add/Update - Place Info (without image upload)
    static func performAddOrUpdatePlaceInfo(dict:NSMutableDictionary!, placeId:String?, resultHandler:@escaping (PlaceInfo?,NSError?) -> Void)
    {
        let jsonObject: NSMutableDictionary = dict
        
        var jsonData: Data? = nil
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions())
            if jsonData != nil {
                let jsonString = String(data: jsonData!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                if jsonString != nil {
                    print("performAddOrUpdatePlaceInfo json string = \(jsonString!)")
                }
                else {
                    print("performAddOrUpdatePlaceInfo json string = ")
                }
            }
        }
        catch _ {
            print("performAddOrUpdatePlaceInfo JSON Failure")
        }
        
        let urlString = (placeId == nil ? Config.Api.PlacesApi.Places.URL : String(format: Config.Api.PlacesApi.PlacesUsingID.URL, placeId!))
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = (placeId == nil ? HTTPMethod.post.rawValue : HTTPMethod.put.rawValue)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if jsonData != nil {
            request.httpBody = jsonData
        }
        
        Alamofire.request(request).responseJSON { response in
            
            switch response.result
            {
            case .success:
                
                if let error = Control.hasError(response: response)
                {
                    resultHandler(nil, error)
                }
                else
                {
                    var placeInfo:PlaceInfo?
                    if let json = response.result.value as? [String:AnyObject]
                    {
                        print("performAddOrUpdatePlaceInfo response == \(json) \n")
                        placeInfo = PlaceInfo(JSON:json)
                    }
                    resultHandler(placeInfo, nil)
                }
                
            case .failure(_):
                
                var error = response.error as NSError?
                if error == nil {
                    error = Control.undefinedError()
                }
                resultHandler(nil, error)
            }
        }
    }
    
    //For Add/Update - Place Info (with image upload)
    static func performAddOrUpdatePlaceInfoWithImageUpload(dict:NSMutableDictionary!, placeId:String?, resultHandler:@escaping (PlaceInfo?,NSError?) -> Void)
    {
        let urlString = (placeId == nil ? Config.Api.PlacesApi.Places.URL : String(format: Config.Api.PlacesApi.PlacesUsingID.URL, placeId!))
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = (placeId == nil ? HTTPMethod.post.rawValue : HTTPMethod.put.rawValue)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for mainKey in dict.allKeys {
                if let key = mainKey as? String {
                    if key == "image" {
                        if let imageData = dict[key] as? Data {
                            multipartFormData.append(imageData, withName: key, fileName: "image.jpeg", mimeType: "image/jpeg")
                        }
                    }
                    else {
                        if let val = dict[key] as? String {
                            let data = val.data(using: .utf8)
                            if data != nil {
                                multipartFormData.append(data!, withName: key)
                            }
                        }
                        else if let val = dict[key] as? Double {
                            let data = val.cleanValue.data(using: .utf8)
                            if data != nil {
                                multipartFormData.append(data!, withName: key)
                            }
                        }
                    }
                }
            }
            
        }, with: request, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    
                    switch response.result
                    {
                    case .success:
                        
                        if let error = Control.hasError(response: response)
                        {
                            resultHandler(nil, error)
                        }
                        else
                        {
                            var placeInfo:PlaceInfo?
                            if let json = response.result.value as? [String:AnyObject]
                            {
                                print("performAddOrUpdatePlaceInfoWithImageUpload response == \(json) \n")
                                placeInfo = PlaceInfo(JSON:json)
                            }
                            resultHandler(placeInfo, nil)
                        }
                        
                    case .failure(_):
                        var error = response.error as NSError?
                        if error == nil {
                            error = Control.undefinedError()
                        }
                        resultHandler(nil, error)
                    }
                }
            case .failure(let encodingError):
                var error = encodingError as NSError?
                if error == nil {
                    error = Control.undefinedError()
                }
                resultHandler(nil, error)
            }
        })
        
    }
    
}
