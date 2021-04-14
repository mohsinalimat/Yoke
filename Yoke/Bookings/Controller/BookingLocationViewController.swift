//
//  BookingLocationViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/14/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth

protocol BookingLocationDelegate {
    func bookingLocationController(_ bookingLocationController: BookingLocationViewController, didSelectLocation location: String)
}

class BookingLocationViewController: UIViewController {

    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    var delegate: BookingLocationDelegate?
    var searchController = UISearchController()
    let mapView = MKMapView()
    private let locationManager = LocationManager()
    let pin = MKPointAnnotation()
    var currentLocationStr = "Current location"
    //    var location: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var selectedLocation: String?
    let uid = Auth.auth().currentUser?.uid ?? ""
    static let updateNotificationName = NSNotification.Name(rawValue: "Update")
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        constrainViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavTitleAndBarButtonItems()
    }
    
    //MARK: - Helper Functions
    fileprivate func fetchUser() {
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            self.pin.title = "Location"
            self.addressTextField.text = user.street
            self.apartmentTextField.text = user.apartment
        }
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.LightGrayBg()
        view.addSubview(swipeIndicator)
        view.addSubview(saveButton)
        view.addSubview(setLocationLabel)
        view.addSubview(addressView)
        view.addSubview(addressTextField)
        view.addSubview(apartmentView)
        view.addSubview(apartmentTextField)
        view.addSubview(searchButton)
        view.addSubview(mapView)
    }
    
    func constrainViews() {
        swipeIndicator.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 5)
        swipeIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.anchor(top: swipeIndicator.bottomAnchor, left: nil, bottom: nil, right: safeArea.rightAnchor, paddingTop: 18, paddingLeft: 0, paddingBottom: 0, paddingRight: 20)
        
        setLocationLabel.anchor(top: swipeIndicator.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        setLocationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addressView.anchor(top: setLocationLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 40)
        addressTextField.anchor(top: addressView.topAnchor, left: addressView.leftAnchor, bottom: addressView.bottomAnchor, right: addressView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        apartmentView.anchor(top: addressTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 40)
        apartmentTextField.anchor(top: apartmentView.topAnchor, left: apartmentView.leftAnchor, bottom: apartmentView.bottomAnchor, right: apartmentView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        searchButton.anchor(top: apartmentView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 25, paddingBottom: 0, paddingRight: 25, height: 45)
        mapView.anchor(top: searchButton.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    private func fetchUserLocationFromSearch() {
        guard let address = addressTextField.text else { return }
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                self.handleNoLocationFound()
                return
            }
            self.saveButton.setTitleColor(UIColor.orangeColor()?.withAlphaComponent(1.0), for: .normal)
            self.saveButton.isEnabled = false
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let address = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.getAdressName(coords: address)
            self.latitude = center.latitude
            self.longitude = center.longitude
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            self.pin.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.mapView.addAnnotation(self.pin)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func getAdressName(coords: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(coords) { (placemark, error) in
            if error != nil {
                print("error")
            } else {
                
                let place = placemark! as [CLPlacemark]
                if place.count > 0 {
                    let place = placemark![0]
                    var addressString : String = ""
                    let postal = place.postalAddress
                    guard let street = postal?.street,
                          let neighbourhood = place.subLocality,
                          let city = postal?.city,
                          let state = postal?.state,
                          let zipcode = postal?.postalCode,
                          let apt = self.apartmentTextField.text else { return }
                    
                    if street != "" {
                        addressString = addressString + street + ", "
                    }
                    if apt != "" {
                        addressString = addressString + apt + ", "
                    }
                    if neighbourhood != "" {
                        addressString = addressString + neighbourhood + ", "
                    }
                    if city != "" {
                        addressString = addressString + city + ", "
                    }
                    if state != "" {
                        addressString = addressString + state + " "
                    }
                    if zipcode != "" {
                        addressString = addressString + zipcode
                    }
                    self.selectedLocation = addressString
                }
            }
        }
    }

    func handleNoLocationFound() {
        let alertController = UIAlertController(title: "We could not find that location", message: "Please check the address entered and try again", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupNavTitleAndBarButtonItems() {
        navigationItem.title = "Filter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(handleSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleDismiss))
    }
    
    //MARK: - Selectors
    @objc func locationSwitch(locationSwitchChanged: UISwitch) {
        if locationSwitch.isOn {
            
        } else {
            addressTextField.text = ""
            apartmentTextField.text = ""
        }
    }
    
    @objc func handleSetUserLocation() {
        fetchUserLocationFromSearch()
    }
    
    //MARK: - API
    @objc func handleSave() {
        guard let location = selectedLocation else { return }
        delegate?.bookingLocationController(self, didSelectLocation: location)
        handleDismiss()
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
        button.setTitleColor(UIColor.orangeColor()?.withAlphaComponent(0.5), for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    var setLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "Set Location"
        label.font = UIFont.boldSystemFont(ofSize: 17)
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
    
    let addressView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
    
    let addressTextField: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 17)
        text.placeholder = "Address"
        text.textColor = UIColor.orangeColor()
        text.backgroundColor = UIColor.white
        return text
    }()
    
    let apartmentView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
    
    let apartmentTextField: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 17)
        text.placeholder = "Apt suite or floor #"
        text.textColor = UIColor.orangeColor()
        return text
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(handleSetUserLocation), for: .touchUpInside)
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
