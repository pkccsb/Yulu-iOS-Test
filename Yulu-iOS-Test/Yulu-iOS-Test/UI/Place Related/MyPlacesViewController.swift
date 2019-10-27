//
//  MyPlacesViewController.swift
//  Yulu-iOS-Test
//
//  Created by Praveen on 23/10/19.
//  Copyright © 2019 Praveen. All rights reserved.
//

import UIKit
import Kingfisher

class MyPlacesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var placesInfoTableView: UITableView!
    @IBOutlet weak var placesInfoNotFoundLabel: UILabel!
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var addNewPlaceBtn: UIButton!
    @IBOutlet weak var showPlaceOnMapBtn: UIButton!
    
    var mainPlaceInfos:[PlaceInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        placesInfoTableView.tableFooterView = UIView()
        placesInfoTableView.alwaysBounceVertical = true
        placesInfoTableView.backgroundColor = .clear
        placesInfoTableView.isOpaque = false;
        placesInfoTableView.backgroundView = UIView();
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .medium)]
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        var frame = refreshControl.bounds
        frame.origin.y = frame.origin.y
        refreshControl.bounds = frame
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("general.pulltorefresh", comment: ""), attributes: attributes)
        refreshControl.addTarget(self, action: #selector(getDataPullRefresh), for: .valueChanged)
        placesInfoTableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mainPlaceInfos = ApplicationManager.sharedInstance.currPlaceInfos
        self.refreshUI()
    }
    
    @objc func getDataPullRefresh()
    {
        refreshControl.endRefreshing()
        self.fetchPlaceInfo()
    }
    
    func fetchPlaceInfo() {
        
        self.updatePlacesInfo(needLoading: true, resultHandler: { (result, error) in
            
            if error == nil && result != nil {
                
                self.mainPlaceInfos.removeAll()
                self.mainPlaceInfos = ApplicationManager.sharedInstance.currPlaceInfos
                
                //refresh UI
                DispatchQueue.main.async {
                    self.refreshUI()
                }
            }
            else {
                var err = error
                if error == nil {
                    err = Control.undefinedError()
                }
                
                self.showErrorMessage(error: err, errorHandler: { (result) in
                    
                })
            }
            
        })
    }
    
    func refreshUI() {
        self.placesInfoTableView.reloadData()
        self.placesInfoNotFoundLabel.isHidden = (self.mainPlaceInfos.count > 0 ? true : false)
    }
    
    // MARK: -
    @IBAction func addNewPlaceBtnClicked(_ sender: Any)
    {
        print("addNewPlaceBtnClicked...")
        let controller = StoryboardScene.Main.AddOrUpdateNewPlaceViewControllerScene.viewController() as! AddOrUpdateNewPlaceViewController
        controller.mode = .add
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func showPlaceOnMapBtnClicked(_ sender: Any)
    {
        print("showPlaceOnMapBtnClicked...")
        let controller = StoryboardScene.Main.PlacesOnMapViewControllerScene.viewController() as! PlacesOnMapViewController
        self.navigationController!.pushViewController(controller, animated: false)
    }
    
    // MARK: - UITableView delegate & data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainPlaceInfos.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceDetailsTableCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        let placeImageView = cell.viewWithTag(101) as! UIImageView
        placeImageView.image = Asset.ic_placeholder.image
        
        let placeTitleLabel = cell.viewWithTag(102) as! UILabel
        placeTitleLabel.text = ""
        
        let info = self.mainPlaceInfos[indexPath.row]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        let attribute1 = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        let attribute2 = [
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        let messageText = NSMutableAttributedString()
        
        if let title = info.title, title.count > 0 {
            messageText.append(NSAttributedString(string: title, attributes: attribute1))
        }
        
        if let description = info.description, description.count > 0 {
            if messageText.length > 0 {
                messageText.append(NSAttributedString(string: "\n", attributes: attribute2))
            }
            messageText.append(NSAttributedString(string: description, attributes: attribute2))
        }
        
        placeTitleLabel.attributedText = messageText
        
        if let imageUrl = info.imageUrl, imageUrl.count > 0 {
            var subURL = imageUrl
            if subURL.hasPrefix("/") {
                subURL = String(subURL.dropFirst())
            }
            if let finalImgUrl = URL(string: String(format: Config.Api.PlacesApi.PlaceImageURL.URL, subURL)) {
                //placeImageView.load(url: finalImgUrl)
                placeImageView.kf.setImage(with: finalImgUrl, placeholder: Asset.ic_placeholder.image)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = self.mainPlaceInfos[indexPath.row]
        
        let controller = StoryboardScene.Main.PlaceDetailsViewControllerScene.viewController() as! PlaceDetailsViewController
        controller.placeInfo = info
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
