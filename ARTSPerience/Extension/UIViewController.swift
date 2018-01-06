//
//  UIViewController.swift
//  CodeBase
//
//  Created by Hafiz on 18/09/2017.
//  Copyright © 2017 github. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

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

        navigationItem.backBarButtonItem = UIBarButtonItem(title:" ", style: .plain, target: nil, action: nil)
        
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
    
    // Location
    func openLocation(latitude: Double, longitude: Double, placeName: String) {
        let alertController = UIAlertController(title: "Choose Application", message: nil, preferredStyle: .actionSheet)
        
        // using apple maps
        let mapsAction = UIAlertAction(title: "Maps", style: .default) { (action) in
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = placeName
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
        
        let googleMapsAction = UIAlertAction(title: "Google Maps", style: .default) { (action) in
            let link : String = "comgooglemaps://"
            let wazeInstalled = self.schemeAvailable(link)
            if wazeInstalled {
                let urlStr : NSString = NSString(format: "comgooglemaps://maps?daddr=%f,%f", latitude, longitude)
                self.openSocialNetwork(urlStr as String)
            } else {
                let alertController = UIAlertController(title: "Google Maps Not Found",
                                                        message: "Please download the app or navigate using other options",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",
                                             style: UIAlertActionStyle.default,
                                             handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        let wazeAction = UIAlertAction(title: "Waze", style: .default) { (action) in
            let link : String = "waze://"
            let wazeInstalled = self.schemeAvailable(link)
            if wazeInstalled {
                let urlStr : NSString = NSString(format: "waze://?ll=%f,%f&navigate=yes",latitude, longitude)
                self.openSocialNetwork(urlStr as String)
            } else {
                let alertController = UIAlertController(title: "Waze Not Found",
                                                        message: "Please download the app or navigate using other options",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",
                                             style: UIAlertActionStyle.default,
                                             handler: nil)
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .destructive,
                                         handler: nil)
        
        alertController.addAction(mapsAction)
        alertController.addAction(googleMapsAction)
        alertController.addAction(wazeAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func schemeAvailable(_ scheme : String) -> Bool {
        if let url = URL.init(string: scheme) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    fileprivate func openSocialNetwork(_ url:String) {
        openURL(link: url)
    }
}
