//
//  RootViewController.swift
//  Yulu-iOS-Test
//
//  Created by Praveen on 23/10/19.
//  Copyright © 2019 Praveen. All rights reserved.
//

import UIKit

class RootViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.updatePlacesInfo(needLoading: true, resultHandler: { (result, error) in
            let controller = StoryboardScene.Main.MyPlacesViewControllerScene.viewController() as! MyPlacesViewController
            self.navigationController!.pushViewController(controller, animated: false)
        })
        
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
