//
//  ViewController.swift
//  TouchToMap
//
//  Created by Hugo Flores Perez on 4/25/20.
//  Copyright © 2020 Hugo Flores Perez. All rights reserved.
//

import CoreLocation
import UIKit

class MapViewController: UIViewController {
    
    private let viewObj = MapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMain()
    }
    
    func setUpMain() {
        view.backgroundColor = UIColor(named: "MapControllerBackground")
        setUpView()
    }
    
    func setUpView() {
        view.addSubview(viewObj)
        viewObj.setMapPressListener(target: self, action: #selector(onMapTapped(gestureReconizer:)))
        viewObj.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        viewObj.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewObj.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewObj.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc
    func onMapTapped(gestureReconizer: UITapGestureRecognizer) {
        let coordinates = viewObj.getMapCoordinatesOfTouchPoint(gestureRecognizer: gestureReconizer)
        let latVal = coordinates.latitude
        let longVal = coordinates.longitude
        let geoLocation = CLGeocoder()
        geoLocation.reverseGeocodeLocation(CLLocation(latitude: latVal, longitude: longVal)) { [unowned self] (placemarks, error) in
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
            self.viewObj.centerMapInLocation(region.center, regionRadius: region.radius * 2)
        }
    }

}



