//
//  PlaceDetailsViewController.swift
//  Yulu-iOS-Test
//
//  Created by Praveen on 25/10/19.
//  Copyright © 2019 Praveen. All rights reserved.
//

import UIKit
import CoreLocation

class PlaceDetailsViewController: BaseViewController {

    var placeInfo:PlaceInfo?
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeTitleLabel: UILabel!
    @IBOutlet weak var placeDescriptionLabel: UILabel!
    @IBOutlet weak var placeLocationLabel: UILabel!
    @IBOutlet weak var h_placeImageView: NSLayoutConstraint!
    @IBOutlet weak var h_placeTitleLabel: NSLayoutConstraint!
    @IBOutlet weak var h_placeDescriptionLabel: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let placeId = placeInfo?.id, placeId.count > 0 {
            DispatchQueue.main.async {
                self.showLoading()
            }
            
            ControlPlaces.fetchPlaceInfo(placeId: placeId, resultHandler: { (result, error) in
                
                DispatchQueue.main.async {
                    self.hideLoading()
                }
                
                if error == nil && result != nil {
                    print("\(#function) result = \(result!)")
                    self.placeInfo = result!
                }
                else {
                    var err = error
                    if error == nil {
                        err = Control.undefinedError()
                    }
                    print("\(#function) error = \(err!)")
                    
//                    self.showErrorMessage(error: err, errorHandler: { (result) in
//
//                    })
                }
                
                self.updateUI()
            })
        }
        else {
            self.updateUI()
        }
    }
    
    func updateUI() {
        placeTitleLabel.text = ""
        h_placeTitleLabel.constant = 0
        
        placeDescriptionLabel.text = ""
        h_placeDescriptionLabel.constant = 0
        
        placeImageView.image = Asset.ic_placeholder.image
        h_placeImageView.constant = 250
        
        placeLocationLabel.text = ""
        
        if let title = placeInfo?.title, title.count > 0 {
            placeTitleLabel.text = title
            
            h_placeTitleLabel.constant = self.heightForView(text: title, font: placeTitleLabel.font, width: placeTitleLabel.frame.size.width)
        }
        
        if let description = placeInfo?.description, description.count > 0 {
            placeDescriptionLabel.text = description
            
            h_placeDescriptionLabel.constant = self.heightForView(text: description, font: placeDescriptionLabel.font, width: placeDescriptionLabel.frame.size.width)
        }
        
        if let imageUrl = placeInfo?.imageUrl, imageUrl.count > 0 {
            var subURL = imageUrl
            if subURL.hasPrefix("/") {
                subURL = String(subURL.dropFirst())
            }
            if let finalImgUrl = URL(string: String(format: Config.Api.PlacesApi.PlaceImageURL.URL, subURL)) {
                //placeImageView.load(url: finalImgUrl)
                placeImageView.kf.setImage(with: finalImgUrl, placeholder: Asset.ic_placeholder.image)
            }
        }
        
        if let lat = placeInfo?.latitude {
            if let long = placeInfo?.longitude {
                placeLocationLabel.text = "\(lat.cleanValue), \(long.cleanValue)"
            }
        }
    }

    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    @IBAction func viewPlaceLocationOnMapBtnClicked(_ sender: Any)
    {
        print("viewPlaceLocationOnMapBtnClicked...")
        
        if let lat = placeInfo?.latitude {
            if let long = placeInfo?.longitude {
                let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let controller = StoryboardScene.Main.ChangeLocationOnMapViewControllerScene.viewController() as! ChangeLocationOnMapViewController
                controller.mode = .viewLocation
                controller.selectedLocation = location
                self.navigationController!.pushViewController(controller, animated: true)
            }
        }
    }

    @IBAction func updatePlaceBtnClicked(_ sender: Any)
    {
        print("updatePlaceBtnClicked...")
        let controller = StoryboardScene.Main.AddOrUpdateNewPlaceViewControllerScene.viewController() as! AddOrUpdateNewPlaceViewController
        controller.mode = .update
        controller.placeInfo = placeInfo
        self.navigationController!.pushViewController(controller, animated: true)
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
