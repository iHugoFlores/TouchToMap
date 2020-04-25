//
//  MapView.swift
//  TouchToMap
//
//  Created by Hugo Flores Perez on 4/25/20.
//  Copyright © 2020 Hugo Flores Perez. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

class MapView: UIView {

    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private let titleCard = TextCard()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpMainLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpMainLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        setUpMap()
    }
    
    func setUpMap() {
        setUpMapContents()
        addSubview(mapView)
        let safeMargins = layoutMarginsGuide
        mapView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: safeMargins.bottomAnchor).isActive = true
    }
    
    func setUpMapContents() {
        titleCard.setTitle("Touch anywhere in the map to get information about the place")
        mapView.addSubview(titleCard)
        mapView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        
        let margins = mapView.layoutMarginsGuide
        titleCard.widthAnchor.constraint(lessThanOrEqualTo: margins.widthAnchor).isActive = true
        titleCard.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        titleCard.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
    }
    
    func setMapPressListener(target: Any, action: Selector?) {
        let gestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func getMapCoordinatesOfTouchPoint(gestureRecognizer: UIGestureRecognizer) -> CLLocationCoordinate2D {
        let touchPoint = gestureRecognizer.location(in: mapView)
        return mapView.convert(touchPoint, toCoordinateFrom: mapView)
    }
    
    func centerMapInLocation(_ location: CLLocationCoordinate2D, regionRadius: CLLocationDistance) {
        let region = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
}