//
//  HomeViewController.swift
//  ARTSPerience
//
//  Created by Hafiz on 06/01/2018.
//  Copyright © 2018 Derp. All rights reserved.
//

import UIKit
import HDAugmentedReality
import CoreLocation
import MapKit

class HomeViewController: UIViewController {

    let limit = 10
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var showARButton: UIButton!
    var locationManager: CLLocationManager!
    fileprivate var arViewController: ARViewController!
    var tableData = [Place]()
    
    var userCoordinate = CLLocationCoordinate2D()
    var annotations = [ARAnnotation]()
    var places = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showARButton.rounded(radius: 28)
        showARButton.addShadow()
        showARButton.addTarget(self, action: #selector(self.showARView), for: .touchUpInside)
        
        // mapview
        mapView.showsUserLocation = true

        setupLocation()
        
    }
    
    func setupLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    @objc func showARView() {
        places = PlaceStore.getAll()
        // setup ARView
        arViewController = ARViewController()
        arViewController.dataSource = self
        
        var count = 0
        for place in places {
            
            guard count < limit else { break }
            
            if let coord = place.coordinates {
                let lat = coord[1]
                let long = coord[0]
                
                let location = CLLocation(latitude: lat, longitude: long)
                
                if let annotation = ARAnnotation(identifier: place.imgURL ?? "", title: place.name ?? "...", location: location) {
                    annotations.append(annotation)
                }
            }
            count += 1
        }
        
        arViewController.setAnnotations(annotations)
        self.present(arViewController, animated: true, completion: nil)
    }
    
    func setupTable() {
        
        // setup tableview
        tableView.rowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 72, right: 0)
        
        tableData = PlaceStore.getAll()
        counterLabel.text = "\(tableData.count) locations found."
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "PlaceViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! PlaceViewCell
        let place = tableData[indexPath.row]
        
        cell.titleLabel.text = place.name ?? "..."
        
        if let coords = place.coordinates {
            let lat = coords[1]
            let long = coords[0]
            
            let coordinate = CLLocation(latitude: lat, longitude: long)
            let userCoord = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
            let distance = userCoord.distance(from: coordinate) // in meter
            
            if distance > 1000 {
                cell.distanceLabel.text = String(format: "%.2f km", (distance/1000))
            }
            else {
                cell.distanceLabel.text = String(format: "%.2f m", distance)
            }
        }
       
        cell.placeImageView.sd_setImage(with: place.imgURL?.url, placeholderImage: #imageLiteral(resourceName: "sample"), completed: nil)
        
        return cell
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            userCoordinate = location.coordinate
            mapView.setRegion(region, animated: true)
            
            locationManager.stopUpdatingLocation()
            
            setupTable()
        }
    }
}

extension HomeViewController: AnnotationViewDelegate {
    func didTouch(annotationView: AnnotationView) {
        print("Tapped view for POI: \(String(describing: annotationView.titleLabel.text))")
    }
}

extension HomeViewController: ARDataSource {
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        let annotationView = AnnotationView()
        annotationView.annotation = viewForAnnotation
        annotationView.delegate = self
        annotationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        
        return annotationView
    }
}