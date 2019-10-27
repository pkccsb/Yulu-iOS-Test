//
//  LocationManager.swift
//  Yulu-iOS-Test
//
//  Created by Praveen on 25/10/19.
//  Copyright © 2019 Praveen. All rights reserved.
//

import UIKit
import SwiftLocation
import CoreLocation

class LocationManager: NSObject {

    static var currentLocation:CLLocation?
    static var country:String?
    
    static func startUpdate()
    {
        SwiftLocation.Locator.currentPosition(accuracy: .house, timeout: nil, onSuccess: { location in
            
            currentLocation = location
            getCurrentCountry()
            
        }) { (err, last) -> (Void) in
            
            
        }
    }
    
    static func getLocation(resultHandler:@escaping (CLLocation) -> Void)
    {
        if let location = currentLocation as CLLocation?
        {
            resultHandler(location)
        }
        else
        {
            LocationManager.startUpdate()
            SwiftLocation.Locator.currentPosition(accuracy: .house, timeout: Timeout.after(10), onSuccess: { location in
                
                currentLocation = location
                getCurrentCountry()
                resultHandler(currentLocation!)
                
            }) { (err, last) -> (Void) in
                
                if let location = last as CLLocation?
                {
                    currentLocation = location
                    getCurrentCountry()
                }
                else
                {
                    //Bangalore, India
                    currentLocation = CLLocation(latitude: 12.972442, longitude: 77.580643)
                    getCurrentCountry()
                }
                resultHandler(currentLocation!)
                
            }
        }
    }
    
    static func getCurrentCountry()
    {
        SwiftLocation.Locator.location(fromCoordinates: currentLocation!.coordinate, onSuccess: { places in
            
            if (places.count > 0) {
                if let isoCountryCode = places[0].placemark?.isoCountryCode
                {
                    country = isoCountryCode
                }
            }
            
        }) { _ in
            
            
        }
        
    }
    
}
