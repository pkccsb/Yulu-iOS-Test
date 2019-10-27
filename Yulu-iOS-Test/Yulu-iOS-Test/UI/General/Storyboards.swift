//
//  Storyboards.swift
//  Yulu-iOS-Test
//
//  Created by Praveen on 23/10/19.
//  Copyright © 2019 Praveen. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardSceneType {
    static var storyboardName: String { get }
}

extension StoryboardSceneType {
    static func storyboard() -> UIStoryboard {
        return UIStoryboard(name: self.storyboardName, bundle: nil)
    }
    
    static func initialViewController() -> UIViewController {
        return storyboard().instantiateInitialViewController()!
    }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
    func viewController() -> UIViewController {
        return Self.storyboard().instantiateViewController(withIdentifier: self.rawValue)
    }
    static func viewController(identifier: Self) -> UIViewController {
        return identifier.viewController()
    }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
    func performSegue<S: StoryboardSegueType>(segue: S, sender: AnyObject? = nil) where S.RawValue == String {
        performSegue(withIdentifier: segue.rawValue, sender: sender)
    }
}

struct StoryboardScene {
    
    enum Main: String, StoryboardSceneType {
        static let storyboardName = "Main"
        
        case MyPlacesViewControllerScene = "MyPlacesViewController"
        static func instantiateMyPlacesViewController() -> MyPlacesViewController {
            guard let vc = StoryboardScene.Main.MyPlacesViewControllerScene.viewController() as? MyPlacesViewController
                else {
                    fatalError("ViewController 'MyPlacesViewController' is not of the expected class MyPlacesViewController.")
            }
            return vc
        }
        
        case PlacesOnMapViewControllerScene = "PlacesOnMapViewController"
        static func instantiatePlacesOnMapViewController() -> PlacesOnMapViewController {
            guard let vc = StoryboardScene.Main.PlacesOnMapViewControllerScene.viewController() as? PlacesOnMapViewController
                else {
                    fatalError("ViewController 'PlacesOnMapViewController' is not of the expected class PlacesOnMapViewController.")
            }
            return vc
        }
        
        case PlaceDetailsViewControllerScene = "PlaceDetailsViewController"
        static func instantiatePlaceDetailsViewController() -> PlaceDetailsViewController {
            guard let vc = StoryboardScene.Main.PlaceDetailsViewControllerScene.viewController() as? PlaceDetailsViewController
                else {
                    fatalError("ViewController 'PlaceDetailsViewController' is not of the expected class PlaceDetailsViewController.")
            }
            return vc
        }
        
        case AddOrUpdateNewPlaceViewControllerScene = "AddOrUpdateNewPlaceViewController"
        static func instantiateAddOrUpdateNewPlaceViewController() -> AddOrUpdateNewPlaceViewController {
            guard let vc = StoryboardScene.Main.AddOrUpdateNewPlaceViewControllerScene.viewController() as? AddOrUpdateNewPlaceViewController
                else {
                    fatalError("ViewController 'AddOrUpdateNewPlaceViewController' is not of the expected class AddOrUpdateNewPlaceViewController.")
            }
            return vc
        }
        
        case ChangeLocationOnMapViewControllerScene = "ChangeLocationOnMapViewController"
        static func instantiateChangeLocationOnMapViewController() -> ChangeLocationOnMapViewController {
            guard let vc = StoryboardScene.Main.ChangeLocationOnMapViewControllerScene.viewController() as? ChangeLocationOnMapViewController
                else {
                    fatalError("ViewController 'ChangeLocationOnMapViewController' is not of the expected class ChangeLocationOnMapViewController.")
            }
            return vc
        }
        
    }
    
}

struct StoryboardSegue {
    
}
