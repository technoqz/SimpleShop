//
//  MapViewController.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 20.02.2021.
//

import UIKit
import MapKit
import CoreLocation
import Contacts

protocol MapViewControllerDelegate: class {
    func fillAdress(address: String)
}

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    weak var delegate: MapViewControllerDelegate!
    var resultAdress: String?
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.transparentNavigationBar()
        confirmButton.layer.cornerRadius = 25
    }

    override func viewWillAppear(_ animated: Bool) {
        locationServiceInit()
    }
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        delegate.fillAdress(address: resultAdress ?? "")
        navigationController?.popViewController(animated: true)
    }
    
    func locationServiceInit(){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        //self.locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationServiceInit()
            case .restricted, .denied:
                addressLabel.text = "Для определение адреса необходимо разрешить доступ к GPS в настройках."
                Alert.goToSettings(vc: self)
            case .authorizedAlways, .authorizedWhenInUse:
                break
            @unknown default:
                print("CLLocationManager error")
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        guard let location = manager.location else { return }
        
        let annotation = MKPointAnnotation()
        annotation.title = "Вы тут"
        annotation.coordinate = locValue
        
        self.mapView.showAnnotations([annotation], animated: true)
        self.mapView.selectAnnotation(annotation, animated: true)
        
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: nil) { (clPlacemark: [CLPlacemark]?, error: Error?) in
            guard let place = clPlacemark?.first else {
                print("Error: \(String(describing: error))")
                return
            }
            
            let postalAddressFormatter = CNPostalAddressFormatter()
            postalAddressFormatter.style = .mailingAddress

            if let postalAddress = place.postalAddress {
                self.addressLabel.text = postalAddressFormatter.string(from: postalAddress)
                self.resultAdress = postalAddressFormatter.string(from: postalAddress)
            }
        }
    }
    

}
