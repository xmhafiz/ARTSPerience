//
//  DetailViewController.swift
//  ARTSPerience
//
//  Created by Hafiz on 06/01/2018.
//  Copyright © 2018 Derp. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var getDirectionButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var place: Place?
    var urlLink = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomBackButton()
        backButton.rounded(radius: 18, borderWidth: 2, borderColor: .white)
        getDirectionButton.rounded(radius: 25)
        moreButton.rounded(radius: 25)
        
        moreButton.addShadow()
        getDirectionButton.addShadow()
        backButton.addShadow()
        
        if let placeData = place {
            titleLabel.text = placeData.name ?? "..."
            imageView.sd_setImage(with: placeData.imgURL?.url, placeholderImage: #imageLiteral(resourceName: "sample"), completed: nil)
            
            // split in html code
            let htmls = place?.description?.components(separatedBy: "Details:")
            print(htmls as Any)
            if let link = htmls?.last {
                if !link.isEmpty {
                    urlLink = link
                }
            }
            else {
                moreButton.isEnabled = false
                self.showAlert("Information Unavailable", description: "Sorry, the website is currently unreachable")
               
            }
            
        }
        
    }
    @IBAction func showDetail(_ sender: Any) {
        performSegue(withIdentifier: "showWebView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WebViewController {
            destination.webURL = urlLink
            print(urlLink)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showNavbar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hideNavbar()
    }
    
    @IBAction func handleBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
