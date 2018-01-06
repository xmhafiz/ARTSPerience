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

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var showARButton: UIButton!
    var locationManager: CLLocationManager!
    fileprivate var arViewController: ARViewController!
    var tableData = [Place]()
    var data = [Place]()
    
    let limit = 10
    var userCoordinate = CLLocationCoordinate2D()
    var annotations = [ARAnnotation]()
    var places = [Place]()
    var navigationAR = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // remove splash
        navigationController?.viewControllers.removeFirst()
        setupCustomBackButton()
        
        showARButton.rounded(radius: 28)
        showARButton.addShadow()
        showARButton.addTarget(self, action: #selector(self.showARView), for: .touchUpInside)
        
        // mapview
        mapView.showsUserLocation = true

        // tableview
        tableView.rowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        searchBar.delegate = self
        
        setupLocation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showNavbar()
        hideBackButton()
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
        arViewController.closeButtonImage = #imageLiteral(resourceName: "icon-down")
        navigationAR = UINavigationController(rootViewController: arViewController)
        navigationAR.isNavigationBarHidden = true
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
        self.present(navigationAR, animated: false, completion: nil)
        
        // show promo popups
        let delay = 12 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time) {
            if let popup = self.storyboard?.instantiateViewController(withIdentifier: "PopupViewController") {
                
                popup.modalPresentationStyle = .overCurrentContext
                self.arViewController.present(popup, animated: true, completion: nil)
            }
        }
        
    }
    
    func setupTable() {
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 72, right: 0)
        
        data = PlaceStore.getAll()
        tableData = data // copy
        counterLabel.text = "\(tableData.count) locations found."
        tableView.reloadData()
        spinner.stopAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            if let selectedRow = tableView.indexPathForSelectedRow?.row {
                let place = tableData[selectedRow]
                
                destination.place = place
            }
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("search for.. \(searchText)")
        
        if searchText.isEmpty {
            tableData = data
        }
        else {
            tableData = data.filter { ($0.name?.lowercased().contains(searchText.lowercased())) ?? false }
        }
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
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
        
        let filtered = places.filter { $0.name == annotationView.titleLabel.text }
        
        if let place = filtered.first {
            let detail = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detail.place = place
            navigationAR.pushViewController(detail, animated: true)
        }
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
