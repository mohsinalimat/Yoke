//
//  SearchFilterViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/10/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import MapKit

protocol SearchUsersFilterDelegate {
    func searchFilterController(_ searchFilterController: SearchFilterViewController, didSaveSearch location: String, activies: String)
}

class SearchFilterViewController: UIViewController {
    
    //MARK: - Properties
    var delegate: SearchUsersFilterDelegate?
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    let mapView = MKMapView()
    let locationMang = CLLocationManager()
    private let locationManager = LocationManager()
    var currentLocationStr = "Current location"
    var location: String = ""
    var activities: String = ""
    
    
    //MARK: - Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
        constrainViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavTitleAndBarButtonItems()
        setCurrentLocation()
        locationMang.delegate = self
        locationMang.desiredAccuracy = kCLLocationAccuracyBest
        locationMang.requestWhenInUseAuthorization()
        locationMang.requestLocation()
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(mapView)
        view.addSubview(locationView)
        view.addSubview(locationSwitch)
        locationView.addArrangedSubview(locationSwitch)
        locationView.addArrangedSubview(locationLabel)
        locationView.addArrangedSubview(locationTextField)
    }
    
    func constrainViews() {
        //        mapView.anchor(top: safeArea.topAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, topPadding: 10, bottomPadding: 0, leadingPadding: 10, trailingPadding: 10, width: view.frame.width, height: 200)
        //        locationView.anchor(top: mapView.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, topPadding: 10, bottomPadding: 0, leadingPadding: 10, trailingPadding: -10, height: 25)
        
    }
    
    private func setCurrentLocation() {
        guard let exposedLocation = self.locationManager.exposedLocation else { return }
        self.locationManager.getPlace(for: exposedLocation) { placemark in
            guard let placemark = placemark else { return }
            var output = ""
            if let town = placemark.locality {
                output = output + "\n\(town)"
            }
            if let state = placemark.administrativeArea {
                output = output + "\n\(state)"
            }
            print(output)
            self.locationTextField.text = output
            self.locationManager.getLocation(forPlaceCalled: output) { location in
                guard let location = location else { return }
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.20393, longitudeDelta: 0.01))
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    func setupNavTitleAndBarButtonItems() {
        navigationItem.title = "Filter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(handleSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleDismiss))
    }
    
    @objc func handleSave() {
        guard let locationText = locationTextField.text else { return }
        if delegate != nil {
            location = locationText
        }
        if locationSwitch.isOn {
            delegate?.searchFilterController(self, didSaveSearch: location, activies: "")
        }
        handleDismiss()
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Views
    var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Find near you"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .darkGray
        return label
    }()
    
    let locationTextField: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 15)
        text.textColor = UIColor.orangeColor()
        text.isUserInteractionEnabled = false
        return text
    }()
    
    var locationSwitch: UISwitch = {
        let switchBool = UISwitch()
        //        switchBool.tintColor = UIColor.blueColor()
        switchBool.onTintColor = UIColor.orangeColor()
        switchBool.setOn(false, animated: true)
        return switchBool
    }()
    
    let locationView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

extension SearchFilterViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationMang.requestLocation()
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            //            let span = MKCoordinateSpanMake(0.05, 0.05)
            //            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            //            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: (error)")
    }
}
