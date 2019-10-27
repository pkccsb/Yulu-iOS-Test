//
//  MapMarkerInfoView.swift
//  Yulu-iOS-Test
//
//  Created by Praveen on 25/10/19.
//  Copyright © 2019 Praveen. All rights reserved.
//

import UIKit

class MapMarkerInfoView: UIView {

    let kCONTENT_XIB_NAME = "MapMarkerInfoView"
    @IBOutlet var contentView: UIView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var hDescriptionLabel: NSLayoutConstraint!
    
    // MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    // MARK: -
    func showPlaceDetails(info: PlaceInfo) {
        
        if let title = info.title, title.count > 0 {
            titleLabel.text = title
        }
        else {
            titleLabel.text = ""
        }
        
        if let description = info.description, description.count > 0 {
            descriptionLabel.text = description
            hDescriptionLabel.constant = self.frame.size.height/2.0
        }
        else {
            descriptionLabel.text = ""
            hDescriptionLabel.constant = 0
        }
    }
    
}
