//
//  UIViewController.swift
//  CodeBase
//
//  Created by Hafiz on 18/09/2017.
//  Copyright © 2017 github. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideNavbar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func showNavbar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func hideBackButton() {
        self.navigationItem.hidesBackButton = true
    }
    
    func setupCustomBackButton() {
        // custom back button image
        self.navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "icon-left")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "icon-left")
    }
    
    // MARK:- show alert
    func showAlert(_ title: String, description: String) {
        
        let alertController = UIAlertController(
            title: title,
            message: description,
            preferredStyle: .alert
        )
        
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK:- Open url or phone
    func openURL(link: String) {
        if let url = URL(string: link) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
