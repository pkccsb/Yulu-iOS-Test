//
//  ApplicationManager.swift
//  Yulu-iOS-Test
//
//  Created by Praveen on 23/10/19.
//  Copyright © 2019 Praveen. All rights reserved.
//

import UIKit

class ApplicationManager: NSObject {

    static let sharedInstance = ApplicationManager()
    
    var currPlaceInfos:[PlaceInfo] = []
    
    // MARK: -
    override init() {
        super.init()
        
        //If anything need to initialise during first object creation
    }
    
    func restoreSavedData() {
        self.currPlaceInfos.removeAll()
    }
    
}
