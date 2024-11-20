//
//  InformationVC.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 21/04/2022.
//

import UIKit
import MapKit
import CoreLocation

class InformationVC: UIViewController {
    
    //MARK: - Properties
    private let hotlineLbl = UILabel()
    private let addressLbl = UILabel()
    private let emailLbl = UILabel()
    private let mapView = MKMapView()
    private var locationManager: CLLocationManager!
    
    var currentLoc = ""
    
    private var phoneNumber: String {
        return WebService.shared.getAPIKey().phoneNumber
    }
    
    private var address: String {
        return WebService.shared.getAPIKey().address
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        determineCurrentLocation()
    }
}

//MARK: - Configures

extension InformationVC {
    
    func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Contact & Address".localized()
        
        //TODO: - HotlineLbl
        hotlineLbl.attributedText = setupAttributed(title: "Hotline".localized() + ": ", sub: phoneNumber)
        hotlineLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - AddressLbl
        addressLbl.attributedText = setupAttributed(title: "Address".localized() + ": ", sub: address, isLink: false)
        addressLbl.numberOfLines = 0
        addressLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - EmailLbl
        emailLbl.attributedText = setupAttributed(title: "Email".localized() + ": ", sub: WebService.shared.getAPIKey().email)
        emailLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - WebView
        mapView.clipsToBounds = true
        mapView.layer.cornerRadius = 16.0
        mapView.backgroundColor = .white
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 20.0, distribution: .fill, axis: .vertical, alignment: .leading)
        stackView.addArrangedSubview(hotlineLbl)
        stackView.addArrangedSubview(addressLbl)
        stackView.addArrangedSubview(emailLbl)
        stackView.addArrangedSubview(mapView)
        view.addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20.0),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        let hotlineTap = UITapGestureRecognizer(target: self, action: #selector(hotlineDidTap))
        hotlineTap.numberOfTouchesRequired = 1
        hotlineLbl.isUserInteractionEnabled = true
        hotlineLbl.addGestureRecognizer(hotlineTap)
        
        let emailTap = UITapGestureRecognizer(target: self, action: #selector(emailDidTap))
        emailTap.numberOfTouchesRequired = 1
        emailLbl.isUserInteractionEnabled = true
        emailLbl.addGestureRecognizer(emailTap)
        
        hotlineLbl.setNeedsLayout()
        hotlineLbl.layoutIfNeeded()
        
        emailLbl.setNeedsLayout()
        emailLbl.layoutIfNeeded()
    }
    
    private func setupAttributed(title: String, sub: String, isLink: Bool = true) -> NSMutableAttributedString {
        let att1: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppSemiBold, size: 16.0)!,
            .foregroundColor: UIColor.black
        ]
        let att2: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppRegular, size: 16.0)!,
            .foregroundColor: isLink ? UIColor.link : UIColor.black
        ]
        let attr1 = NSAttributedString(string: title, attributes: att1)
        let attr2 = NSAttributedString(string: sub, attributes: att2)
        let attr = NSMutableAttributedString()
        attr.append(attr1)
        attr.append(attr2)
        
        return attr
    }
    
    private func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if #available(iOS 14.0, *) {
            switch locationManager.authorizationStatus {
            case .notDetermined:
                break
            case .restricted:
                break
            case .denied:
                break
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            @unknown default:
                break
            }
            
        } else {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    private func setUserClosestLocation(lat: CLLocationDegrees, long: CLLocationDegrees) -> String {
        let geocoder = CLGeocoder()
        let loc = CLLocation(latitude: lat, longitude: long)
        
        geocoder.reverseGeocodeLocation(loc) { placemarks, error in
            if let placemark = placemarks?.first {
                let name = placemark.name ?? ""
                let country = placemark.country ?? ""
                self.currentLoc = "\(name), \(country)"
            }
        }
        
        return currentLoc
    }
    
    private func getLocationFrom(completion: @escaping (CLLocation?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let placemarks = placemarks else {
                return
            }
            
            let currentLoc = placemarks.first?.location
            completion(currentLoc)
        }
    }
    
    @objc private func hotlineDidTap(_ sender: UITapGestureRecognizer) {
        let range = NSString(string: hotlineLbl.text!).range(of: phoneNumber)
        
        if sender.didTapAttributedTextInLabel(label: hotlineLbl, inRange: range) {
            print("phoneNumber: \(phoneNumber)")
            guard let url = URL(string: "telprompt: \(phoneNumber)") else {
                return
            }
            WebService.shared.goToURL(url)
        }
    }
    
    @objc private func emailDidTap(_ sender: UITapGestureRecognizer) {
        let email = WebService.shared.getAPIKey().email
        let range = NSString(string: emailLbl.text!).range(of: email)
        
        if sender.didTapAttributedTextInLabel(label: emailLbl, inRange: range) {
            print("email: \(email)")
            guard let url = URL(string: "mailTo: \(email)") else {
                return
            }
            WebService.shared.goToURL(url)
        }
    }
}

//MARK: - MKMapViewDelegate

extension InformationVC: MKMapViewDelegate {}

//MARK: - CLLocationManagerDelegate

extension InformationVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getLocationFrom { location in
            let coordinate = location?.coordinate ?? locations[0].coordinate
            let lat = coordinate.latitude
            let long = coordinate.longitude
            
//            print("latitude: \(lat)")
//            print("longitude: \(long)")
            
            let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: center, span: span)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
            annotation.title = self.setUserClosestLocation(lat: lat, long: long)
            
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError error: \(error.localizedDescription)")
    }
}
