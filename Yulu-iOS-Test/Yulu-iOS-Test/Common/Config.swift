//
//  Config.swift
//  Yulu-iOS-Test
//
//  Created by Praveen on 23/10/19.
//  Copyright © 2019 Praveen. All rights reserved.
//

import Foundation

// MARK: Config Related ----
enum Config
{
    enum App:String
    {
        case Id = ""
        case Name = "Yulu Bike"
        case defaultCountryCode = "IN"
    }
    
    enum GoogleMap:String
    {
        case ApiKey = "AIzaSyB5sYTdK0Sq8rH5zBq-uT5vL32d2Ih4H_k"
    }
    
    enum Api:String
    {
        //Final URL
        case Host = "http://35.154.73.71"
        
        var URL: String
        {
            return "\(Config.Api.Host.rawValue)\(self.rawValue)"
        }
        
        enum PlacesApi:String
        {
            case Places = "/api/v1/places"
            
            case PlacesUsingID = "/api/v1/places/%@"  // "/api/v1/places/:id"
            
            case PlaceImageURL = "/api/v1/%@"  // "/api/v1/:imageUrl"
            
            var URL: String
            {
                return "\(Config.Api.Host.rawValue)\(self.rawValue)"
            }
        }
        
    }
}
