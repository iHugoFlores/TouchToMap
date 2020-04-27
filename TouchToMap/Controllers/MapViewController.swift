//
//  ViewController.swift
//  TouchToMap
//
//  Created by Hugo Flores Perez on 4/25/20.
//  Copyright © 2020 Hugo Flores Perez. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

class MapViewController: UIViewController {
    
    private let locationManager = CLLocationManager()

    private let viewObj = MapView()
    
    private let infoViewContent = LocationDetailsView()
    private var infoView: DraggableView?
    private var shouldGetUserLocation = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMain()
    }
    
    func setUpMain() {
        view.backgroundColor = UIColor(named: "MapControllerBackground")
        setUpView()
        setUpDetailsView()
        setUpLocationManager()
    }
    
    func setUpView() {
        //viewObj.setMapDelegate(to: self)
        viewObj.setLocationButtonAction(action: checkLocationPermissions)
        view.addSubview(viewObj)
        viewObj.setMapPressListener(target: self, action: #selector(onMapTapped(gestureReconizer:)))
        viewObj.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        viewObj.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewObj.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewObj.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setUpDetailsView() {
        infoView = DraggableView(mainView: infoViewContent, heightRatio: 0.3)
        addChild(infoView!)
        view.addSubview(infoView!.view)
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    @objc
    func onMapTapped(gestureReconizer: UITapGestureRecognizer) {
        let coordinates = viewObj.getMapCoordinatesOfTouchPoint(gestureRecognizer: gestureReconizer)
        let latVal = coordinates.latitude
        let longVal = coordinates.longitude
        getMapMarkerAndDetailsByLocation(CLLocation(latitude: latVal, longitude: longVal))
    }
    
    func getMapMarkerAndDetailsByLocation(_ location: CLLocation) {
        let geoLocation = CLGeocoder()
        geoLocation.reverseGeocodeLocation(location) { [unowned self] (placemarks, error) in
            if let error = error {
                print("Error in reverse location", error)
                return
            }
            guard
                let placemarks = placemarks,
                let firstLocation = placemarks.first,
                let region = firstLocation.region as? CLCircularRegion
            else { return }
            print("Tapped Geo Info:", firstLocation)
            if region.center.latitude == .zero || region.center.longitude == .zero {
                print("Invalid region?")
                return
            }
            self.viewObj.centerMapInLocation(region.center, regionRadius: region.radius * 2)
            self.viewObj.setMapMarker(onMark: firstLocation)
            self.infoViewContent.setLocationData(firstLocation)
            self.infoView?.expandView(onAnimationDone: nil)
        }
    }
    
    func checkLocationPermissions() {
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        shouldGetUserLocation = true
        executeLocationActionsOnStatus(status: status)
    }
    
    func executeLocationActionsOnStatus(status: CLAuthorizationStatus) {
        if !shouldGetUserLocation { return }
        switch status {
        case .notDetermined:
            print("Ask for permissions?")
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            print("Permissions granted. Get location")
            locationManager.startUpdatingLocation()
        case .denied:
            let alert = UIAlertController(title: "Location Services Disabled", message: "Turn on location services to see your current location", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
        default:
            print("Case not contemplated: \(status.rawValue)")
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        executeLocationActionsOnStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getMapMarkerAndDetailsByLocation(locations.first!)
        // Avoid updating the location continuously
        locationManager.stopUpdatingLocation()
    }
}
