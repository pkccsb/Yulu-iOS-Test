//
//  Images.swift
//  Yulu-iOS-Test
//
//  Created by Praveen on 25/10/19.
//  Copyright © 2019 Praveen. All rights reserved.
//

// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit.UIImage
typealias Image = UIImage
#elseif os(OSX)
import AppKit.NSImage
typealias Image = NSImage
#endif

// swiftlint:disable file_length
// swiftlint:disable type_body_length
enum Asset: String {
    case ic_placeholder = "ic_placeholder"
    case ic_map_place = "ic_map_place"
    case ic_Back = "ic_Back"
    case Location_Pin_1 = "Location_Pin_1"
    case Right_Arrow = "Right-Arrow"
    case ic_edit = "ic_edit"
    
    var image: Image {
        return Image(asset: self)
    }
}
// swiftlint:enable type_body_length

extension Image {
    convenience init!(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}


