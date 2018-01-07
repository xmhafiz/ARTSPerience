//
//  SplashViewController.swift
//  ARTSPerience
//
//  Created by Hafiz on 06/01/2018.
//  Copyright © 2018 Derp. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var blurVuew: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let delay = 4 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.performSegue(withIdentifier: "showHome", sender: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavbar()
    }

}
