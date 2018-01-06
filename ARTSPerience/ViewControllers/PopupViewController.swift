//
//  PopupViewController.swift
//  ARTSPerience
//
//  Created by Hafiz on 07/01/2018.
//  Copyright © 2018 Derp. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.rounded(radius: 8)
        
        view.backgroundColor = UIColor.clear
        let delay = 5 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
