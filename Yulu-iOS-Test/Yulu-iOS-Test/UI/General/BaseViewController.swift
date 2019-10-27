//
//  BaseViewController.swift
//  Yulu-iOS-Test
//
//  Created by Praveen on 23/10/19.
//  Copyright © 2019 Praveen. All rights reserved.
//

import UIKit
import JGProgressHUD
import IQKeyboardManagerSwift

class BaseViewController: UIViewController {

    typealias ErrorHandler = (Bool) ->Void
    var errorHandler:ErrorHandler!
    
    typealias SuccessHandler = (Bool) ->Void
    var successHandler:SuccessHandler!
    
    var returnHandler:IQKeyboardReturnKeyHandler?
    
    var hud:JGProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        returnHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnHandler?.lastTextFieldReturnKeyType = .done
        
    }
    
    // MARK: - General
    func updatePlacesInfo(needLoading:Bool, resultHandler:@escaping (Bool?,NSError?) -> Void)
    {
        if needLoading {
            DispatchQueue.main.async {
                self.showLoading()
            }
        }
        
        ControlPlaces.fetchPlaceDetails(resultHandler: { (placeInfos, error) in
            
            if needLoading {
                DispatchQueue.main.async {
                    self.hideLoading()
                }
            }
            
            if error == nil && placeInfos != nil {
                //print("\(#function) placeInfos = \(placeInfos!)")
                ApplicationManager.sharedInstance.currPlaceInfos = placeInfos!
                
                resultHandler(true, error)
            }
            else {
                var err = error
                if error == nil {
                    err = Control.undefinedError()
                }
                
                resultHandler(nil, err)
            }
            
        })
    }
    
    // MARK: - Loading indicator
    func showLoading()
    {
        self.showLoadingForText(text: "")
    }
    
    func showLoadingForText(text:String)
    {
        self.hideLoading()
        
        hud = JGProgressHUD(style: .dark)
        if (hud != nil) {
            hud!.textLabel.text = text
            hud!.show(in: self.view)
        }
    }
    
    func hideLoading()
    {
        if hud != nil {
            hud!.dismiss()
            hud = nil
        }
    }
    
    // MARK: - Alert & Error Message
    func showErrorMessage(error:NSError?)
    {
        showErrorMessage(error: error, errorHandler: nil)
    }
    func showErrorMessage(error:NSError?,errorHandler:ErrorHandler?)
    {
        var errorMessage = NSLocalizedString("general.error.undefined", comment: "")
        if let message = error?.userInfo["message"] as? String
        {
            errorMessage = message
        }
        let alertController = UIAlertController(title: NSLocalizedString("general.error", comment: ""), message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("general.ok", comment: ""), style: .default) { (alertAction) in
            
            if let errorHandler = errorHandler
            {
                errorHandler(true)
            }
            
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    func showAlertMessage(message:String)
    {
        let alertController = UIAlertController(title: NSLocalizedString("general.appname", comment: ""), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("general.ok", comment: ""), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func showAlertMessage(message:String,successHandler:SuccessHandler?)
    {
        let alertController = UIAlertController(title: NSLocalizedString("general.appname", comment: ""), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("general.ok", comment: ""), style: .default) { (alertAction) in
            
            if let successHandler = successHandler
            {
                successHandler(true)
            }
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Back button Action
    @IBAction func backBtnAction(_ sender: AnyObject)
    {
        self.mainBackBtnAction(animated: true)
    }
    
    @IBAction func backBtnActionWithoutAnimation(_ sender: AnyObject)
    {
        self.mainBackBtnAction(animated: false)
    }
    
    func mainBackBtnAction(animated: Bool) {
        if let navigation = self.navigationController {
            navigation.popViewController(animated: animated)
        } else {
            self.dismiss(animated: animated, completion: nil)
        }
    }
    
    @IBAction func dissmissKeyboard(sender: AnyObject)
    {
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
