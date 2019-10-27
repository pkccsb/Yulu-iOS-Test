//
//  PlacesOnMapViewController.swift
//  Yulu-iOS-Test
//
//  Created by Praveen on 25/10/19.
//  Copyright © 2019 Praveen. All rights reserved.
//

import UIKit
import GoogleMaps

class PlacesOnMapViewController: BaseViewController, GMSMapViewDelegate {

    @IBOutlet weak var mainMapView: GMSMapView!
    
    var mainPlaceInfos:[PlaceInfo] = []
    
    var currAddingPlaceMarker:GMSMarker?
    var currShownMapMarkerInfoView:MapMarkerInfoView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mainMapView.isMyLocationEnabled = true
        self.mainMapView.settings.myLocationButton = true
        self.mainMapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mainPlaceInfos = ApplicationManager.sharedInstance.currPlaceInfos
        self.refreshUI()
    }
    
    func refreshUI() {
        
        var bounds = GMSCoordinateBounds()
        
        //clear marker if any
        self.mainMapView.clear()
        
        if self.mainPlaceInfos.count > 0 {
            //Create marker for places
            for place in self.mainPlaceInfos {
                if let lat = place.latitude {
                    if let long = place.longitude {
                        let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        let marker = GMSMarker(position: position)
                        marker.title = place.title
                        marker.snippet = place.description
                        marker.icon = Asset.Location_Pin_1.image
                        marker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
                        marker.map = self.mainMapView
                        marker.userData = place
                        
                        bounds = bounds.includingCoordinate(marker.position)
                    }
                }
            }
            
            let update = GMSCameraUpdate.fit(bounds, withPadding: 30)
            self.mainMapView.animate(with: update)
        }
        else {
            LocationManager.getLocation { (location) in
                
                self.mainMapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
                
            }
        }
        
    }
    
    func performAddNewPlace()
    {
        print("performAddNewPlace...")
        if self.currAddingPlaceMarker != nil {
            let controller = StoryboardScene.Main.AddOrUpdateNewPlaceViewControllerScene.viewController() as! AddOrUpdateNewPlaceViewController
            controller.mode = .add
            controller.addPlaceAtCoordinate = self.currAddingPlaceMarker!.position
            self.navigationController!.pushViewController(controller, animated: true)
            
            self.currAddingPlaceMarker?.map = nil
            self.currAddingPlaceMarker = nil
        }
    }
    
    // MARK: - GMSMapView Delegate
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        //If info window showing then remove that.
//        if self.currShownMapMarkerInfoView != nil {
//            self.currShownMapMarkerInfoView?.removeFromSuperview()
//            self.currShownMapMarkerInfoView = nil
//            return;
//        }
        
        let marker = GMSMarker(position: coordinate)
        marker.icon = Asset.Location_Pin_1.image
        marker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
        marker.map = self.mainMapView
        
        self.currAddingPlaceMarker = marker
        
        //show confirmation popup for Add place
        let alertController = UIAlertController(title: NSLocalizedString("general.appname", comment: ""), message: NSLocalizedString("general.addPlace.confirmation", comment: ""), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("general.cancel", comment: ""), style: .cancel) { (alertAction) in
            self.currAddingPlaceMarker?.map = nil
            self.currAddingPlaceMarker = nil
        }
        let logoutAction = UIAlertAction(title: NSLocalizedString("general.add", comment: ""), style: .destructive) { (alertAction) in
            self.performAddNewPlace()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView?
    {
        if let place = marker.userData as? PlaceInfo {
            let infoView = MapMarkerInfoView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
            infoView.isUserInteractionEnabled = true
            infoView.showPlaceDetails(info: place)
            
            self.currShownMapMarkerInfoView = infoView
            
            return infoView
        }
        return nil
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let info = marker.userData as? PlaceInfo {
            let controller = StoryboardScene.Main.PlaceDetailsViewControllerScene.viewController() as! PlaceDetailsViewController
            controller.placeInfo = info
            self.navigationController!.pushViewController(controller, animated: true)
        }
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
