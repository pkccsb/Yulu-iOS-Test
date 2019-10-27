//
//  ChangeLocationOnMapViewController.swift
//  Yulu-iOS-Test
//
//  Created by Praveen on 25/10/19.
//  Copyright © 2019 Praveen. All rights reserved.
//

import UIKit
import GoogleMaps

@objc protocol ChangeLocationOnMapViewControllerDelegate {
    @objc optional func changeLocationOnMapViewUpdatedTo(newLoc:CLLocationCoordinate2D)
}

class ChangeLocationOnMapViewController: BaseViewController, GMSMapViewDelegate {

    enum LocationMode {
        case viewLocation
        case changeLocation
    }
    
    var mode:LocationMode = .viewLocation
    var selectedLocation:CLLocationCoordinate2D?
    var delegate:ChangeLocationOnMapViewControllerDelegate?
    
    @IBOutlet weak var mainMapView: GMSMapView!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var markerIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mainMapView.isMyLocationEnabled = true
        self.mainMapView.settings.myLocationButton = true
        self.mainMapView.delegate = self
        
        if mode == .changeLocation {
            updateBtn.isHidden = false
            markerIcon.isHidden = false
        }
        else {
            updateBtn.isHidden = true
            markerIcon.isHidden = true
        }
        
        if selectedLocation != nil {
            
            if mode == .viewLocation {
                let marker = GMSMarker(position: selectedLocation!)
                marker.icon = Asset.Location_Pin_1.image
                marker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
                marker.map = self.mainMapView
            }
            
            self.mainMapView.camera = GMSCameraPosition(target: selectedLocation!, zoom: 15, bearing: 0, viewingAngle: 0)
        }
        else {
            LocationManager.getLocation { (location) in
                
                if self.mode == .viewLocation {
                    let marker = GMSMarker(position: location.coordinate)
                    marker.icon = Asset.Location_Pin_1.image
                    marker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
                    marker.map = self.mainMapView
                }
                
                self.mainMapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
                
            }
        }
    }
    
    @IBAction func updateBtnClicked(_ sender: Any)
    {
        print("updateBtnClicked...")
        if let delegate = self.delegate {
            if selectedLocation != nil {
                delegate.changeLocationOnMapViewUpdatedTo?(newLoc: selectedLocation!)
                
                self.backBtnAction(updateBtn)
            }
        }
    }
    
    // MARK: - GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        selectedLocation = position.target//mapView.camera.target
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
