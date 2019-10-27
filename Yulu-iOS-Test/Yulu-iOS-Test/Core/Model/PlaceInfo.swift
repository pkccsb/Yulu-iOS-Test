//
//  PlaceInfo.swift
//  Yulu-iOS-Test
//
//  Created by Praveen on 24/10/19.
//  Copyright © 2019 Praveen. All rights reserved.
//

import UIKit
import ObjectMapper

class PlaceInfo: Mappable {
    
    var id:String?
    var latitude:Double?
    var longitude:Double?
    var title:String?
    var description:String?
    var imageUrl:String?
    
    required init?(map: Map)
    {
    }
    
    required init?()
    {
    }
    
    func mapping(map: Map)
    {
        id   <- map["id"]
        latitude   <- map["latitude"]
        longitude   <- map["longitude"]
        title   <- map["title"]
        description   <- map["description"]
        imageUrl   <- map["imageUrl"]
    }
    
}
