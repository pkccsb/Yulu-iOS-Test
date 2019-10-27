//
//  AddOrUpdateNewPlaceViewController.swift
//  Yulu-iOS-Test
//
//  Created by Praveen on 25/10/19.
//  Copyright © 2019 Praveen. All rights reserved.
//

import UIKit
import GoogleMaps

class AddOrUpdateNewPlaceViewController: BaseViewController, ChangeLocationOnMapViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    enum ViewMode {
        case add
        case update
    }
    
    var mode:ViewMode = .add
    
    var placeInfo:PlaceInfo?
    var addPlaceAtCoordinate:CLLocationCoordinate2D?
    
    @IBOutlet weak var mainInfoLabel: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var changeImageLabel: UILabel!
    @IBOutlet weak var changeLocationLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    var currSelectedLocationCoordinate:CLLocationCoordinate2D?
    var currSelectedImageData:Data?
    
    var picker = UIImagePickerController();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleField.text = ""
        descriptionField.text = ""
        changeImageLabel.text = "Change Image"
        changeLocationLabel.text = "Select Location"
        currSelectedLocationCoordinate = nil
        saveBtn.setTitle("Save", for: .normal)
        
        picker.delegate = self
        
        if mode == .update {
            mainInfoLabel.text = "Edit Info"
            
            if let title = placeInfo?.title, title.count > 0 {
                titleField.text = title
            }
            
            if let description = placeInfo?.description, description.count > 0 {
                descriptionField.text = description
            }
            
            if let lat = placeInfo?.latitude {
                if let long = placeInfo?.longitude {
                    changeLocationLabel.text = "\(lat.cleanValue), \(long.cleanValue)"
                    
                    currSelectedLocationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                }
            }
        }
        else {
            mainInfoLabel.text = "Add Info"
            
            if let loc = addPlaceAtCoordinate {
                changeLocationLabel.text = "\(loc.latitude.cleanValue), \(loc.longitude.cleanValue)"
                
                currSelectedLocationCoordinate = addPlaceAtCoordinate
            }
        }
    }
    
    @IBAction func changePlaceLocationOnMapBtnClicked(_ sender: Any)
    {
        print("changePlaceLocationOnMapBtnClicked...")
        doneAction(nil)
        
        let controller = StoryboardScene.Main.ChangeLocationOnMapViewControllerScene.viewController() as! ChangeLocationOnMapViewController
        controller.mode = .changeLocation
        controller.delegate = self
        controller.selectedLocation = currSelectedLocationCoordinate
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func changeImageBtnClicked(_ sender: Any)
    {
        print("changeImageBtnClicked...")
        doneAction(nil)
        
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: .default){
                UIAlertAction in
                self.openCamera()
            }
            let galleryAction = UIAlertAction(title: "Photo Library", style: .default){
                UIAlertAction in
                self.openGallery()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
                UIAlertAction in
            }
            
            // Add the actions
            if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
                alert.addAction(cameraAction)
            }
            alert.addAction(galleryAction)
            alert.addAction(cancelAction)
            alert.popoverPresentationController?.sourceView = self.view
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.openGallery()
        }
    }
    
    func openCamera(){
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        } else {
            self.showAlertMessage(message: "You don't have camera.")
        }
    }
    func openGallery(){
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        if let data = image.jpegData(compressionQuality: 1.0) {
            let sizeInBytes = 500 * 1024  //500kb
            
            var finalData = data
            if data.count > sizeInBytes {
                //reduce image dimension by 30%
                if let resizedImage = image.resized(withPercentage: 0.7) {
                    if let dataResized = resizedImage.compressToData(expectedSizeInkb: 500) {
                        finalData = dataResized
                    }
                }
            }
            
            currSelectedImageData = finalData
        }
        else {
            print("data nil")
        }
    }
    
    @IBAction func saveBtnClicked(_ sender: Any)
    {
        print("saveBtnClicked...")
        doneAction(nil)
        
        if let title = titleField.text, title.count > 0 {
            if let location = currSelectedLocationCoordinate {
                let dataObject: NSMutableDictionary = NSMutableDictionary()
                
                if let tempTitle = placeInfo?.title, tempTitle == title {
                    //no change
                }
                else {
                    dataObject.setValue(title, forKey: "title")
                }
                
                if let tempLatitude = placeInfo?.latitude, tempLatitude == location.latitude {
                    //no change
                }
                else {
                    dataObject.setValue(location.latitude, forKey: "latitude")
                }
                
                if let tempLongitude = placeInfo?.longitude, tempLongitude == location.longitude {
                    //no change
                }
                else {
                    dataObject.setValue(location.longitude, forKey: "longitude")
                }
                
                var description = ""
                if let descriptionText = descriptionField.text, descriptionText.count > 0 {
                    description = descriptionText
                }
                if let tempDescription = placeInfo?.description, tempDescription == description {
                    //no change
                }
                else {
                    dataObject.setValue(description, forKey: "description")
                }
                
                if let imageData = currSelectedImageData, imageData.count > 0 {
                    dataObject.setValue(imageData, forKey: "image") //This need to be Data type
                }
                
                if dataObject.count > 0 {
                    DispatchQueue.main.async {
                        self.showLoading()
                    }
                    
                    ControlPlaces.performPlaceUpdation(placeId: placeInfo?.id, dict: dataObject, resultHandler: { (result, error) in
                        
                        DispatchQueue.main.async {
                            self.hideLoading()
                        }
                        
                        if error == nil && result != nil {
                            print("\(#function) result = \(result!)")
                            
                            self.updatePlacesInfo(needLoading: false, resultHandler: { (result, error) in
                                
                                if self.mode == .add {
                                    self.showAlertMessage(message: "Place added successfully.", successHandler: { (result) in
                                        self.backBtnAction(self.saveBtn)
                                    })
                                }
                                else {
                                    self.showAlertMessage(message: "Place updated successfully.", successHandler: { (result) in
                                        self.backBtnAction(self.saveBtn)
                                    })
                                }
                            })
                            
                        }
                        else {
                            var err = error
                            if error == nil {
                                err = Control.undefinedError()
                            }
                            print("\(#function) error = \(err!)")
                            
                            self.showErrorMessage(error: err, errorHandler: { (result) in
                                
                            })
                        }
                    })
                }
                else {
                    self.showAlertMessage(message: "Place already updated successfully.")
                }
            }
            else {
                self.showAlertMessage(message: "Please select place location.")
            }
        }
        else {
            self.showAlertMessage(message: "Please enter place title.")
        }
    }
    
    func changeLocationOnMapViewUpdatedTo(newLoc: CLLocationCoordinate2D) {
        currSelectedLocationCoordinate = newLoc
        
        if let loc = currSelectedLocationCoordinate {
            changeLocationLabel.text = "\(loc.latitude.cleanValue), \(loc.longitude.cleanValue)"
        }
        else {
            changeLocationLabel.text = "Select Location"
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    @objc func doneAction(_ sender : UITextField!) {
        self.view.endEditing(true)
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
