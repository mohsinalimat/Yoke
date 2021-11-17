//
//  LocationSettingsViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/13/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth

class LocationSettingsViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    let mapView = MKMapView()
    private let locationManager = LocationManager()
    let pin = MKPointAnnotation()
    var currentLocationStr = "Current location"
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var activities: String = ""
    let uid = Auth.auth().currentUser?.uid ?? ""
    static let updateNotificationName = NSNotification.Name(rawValue: "Update")
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        constrainViews()
        setCurrentLocationOnLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setupNavTitleAndBarButtonItems()
        fetchUser()
    }
    
    //MARK: - Helper Functions
    fileprivate func fetchUser() {
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            guard let username = user.username else { return }
            self.pin.title = "\(username)"
            self.cityTextField.text = user.city
            self.stateTextField.text = user.state
        }
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.LightGrayBg()
        view.addSubview(swipeIndicator)
        view.addSubview(saveButton)
        view.addSubview(setLocationLabel)
        view.addSubview(cityView)
        view.addSubview(cityTextField)
        view.addSubview(stateView)
        view.addSubview(stateTextField)
        view.addSubview(searchButton)
        view.addSubview(locationView)
        locationView.addArrangedSubview(locationLabel)
        locationView.addArrangedSubview(locationSwitch)
        view.addSubview(mapView)
    }
    
    func constrainViews() {
        swipeIndicator.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 5)
        swipeIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.anchor(top: swipeIndicator.bottomAnchor, left: nil, bottom: nil, right: safeArea.rightAnchor, paddingTop: 18, paddingLeft: 0, paddingBottom: 0, paddingRight: 20)
        
        setLocationLabel.anchor(top: swipeIndicator.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        setLocationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cityView.anchor(top: setLocationLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 45)
        cityTextField.anchor(top: cityView.topAnchor, left: cityView.leftAnchor, bottom: cityView.bottomAnchor, right: cityView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        stateView.anchor(top: cityTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 45)
        stateTextField.anchor(top: stateView.topAnchor, left: stateView.leftAnchor, bottom: stateView.bottomAnchor, right: stateView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        searchButton.anchor(top: stateTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 25, paddingBottom: 0, paddingRight: 25, height: 45)
        locationView.anchor(top: searchButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 25, paddingBottom: 0, paddingRight: 10)
        mapView.anchor(top: locationView.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    private func fetchUserLocationFromSearch() {
        guard let city = cityTextField.text,
              let state = stateTextField.text else { return }
        let address = "\(state), \(city)"
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                self.handleNoLocationFound()
                return
            }
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.latitude = center.latitude
            self.longitude = center.longitude
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            self.pin.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.mapView.addAnnotation(self.pin)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func handleNoLocationFound() {
        let alertController = UIAlertController(title: "We could not find that location", message: "Please check the address entered and try again", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    private func setUserLocationFromSwitch() {
        guard let exposedLocation = self.locationManager.exposedLocation else { return }
        self.locationManager.getPlace(for: exposedLocation) { placemark in
            guard let placemark = placemark else { return }
            var output = ""
            if let locationName = placemark.location {
                output = output + "\n\(locationName)"
            }
            if let postal = placemark.postalAddress {
                self.cityTextField.text = postal.city
                self.stateTextField.text = postal.state
            }
            self.locationManager.getLocation(forPlaceCalled: output) { location in
                guard let location = location else { return }
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                self.latitude = center.latitude
                self.longitude = center.longitude
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
                self.pin.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                self.mapView.addAnnotation(self.pin)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    private func setCurrentLocationOnLoad() {
        guard let exposedLocation = self.locationManager.exposedLocation else { return }
        self.locationManager.getPlace(for: exposedLocation) { placemark in
            guard let placemark = placemark else { return }
            var output = ""
            if let locationName = placemark.location {
                output = output + "\n\(locationName)"
            }
            
            self.locationManager.getLocation(forPlaceCalled: output) { location in
                guard let location = location else { return }
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                self.latitude = center.latitude
                self.longitude = center.longitude
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
                self.pin.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                self.mapView.addAnnotation(self.pin)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    func setupNavTitleAndBarButtonItems() {
        navigationItem.title = "Filter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(handleSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleDismiss))
    }
    
    //MARK: - Selectors
    @objc func locationSwitch(locationSwitchChanged: UISwitch) {
        if locationSwitch.isOn {
            setUserLocationFromSwitch()
        } else {
            cityTextField.text = ""
            stateTextField.text = ""
        }
    }
    
    @objc func handleSetUserLocation() {
        fetchUserLocationFromSearch()
    }
    
    //MARK: - API
    @objc func handleSave() {
        guard let city = cityTextField.text,
              let state = stateTextField.text else { return }
        UserController.shared.setUserLocation(uid, city: city, state: state, latitude: latitude, longitude: longitude) { (result) in
            switch result {
            case true:
                self.handleDismiss()
                NotificationCenter.default.post(name: LocationSettingsViewController.updateNotificationName, object: nil)
            case false:
                print("failed to save")
            }
        }
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Views
    let swipeIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.layer.cornerRadius = 5
        return view
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    var setLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "Set Location"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .gray
        return label
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Use my current location"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()
    
    let cityView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
    
    let cityTextField: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 17)
        text.placeholder = "City"
        text.textColor = UIColor.orangeColor()
        text.backgroundColor = UIColor.white
        return text
    }()
    
    let stateView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
    
    let stateTextField: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 17)
        text.placeholder = "State"
        text.textColor = UIColor.orangeColor()
        text.backgroundColor = UIColor.white
        return text
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleSetUserLocation), for: .touchUpInside)
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = UIColor.lightGray.cgColor
        return button
    }()
    
    var locationSwitch: UISwitch = {
        let switchBool = UISwitch()
        switchBool.onTintColor = UIColor.orangeColor()
        switchBool.setOn(false, animated: true)
        switchBool.addTarget(self, action: #selector(locationSwitch(locationSwitchChanged:)), for: UIControl.Event.valueChanged)
        return switchBool
    }()
    
    let locationView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.spacing = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
