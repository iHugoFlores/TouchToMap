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
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.isAccessibilityElement = true
        map.accessibilityHint = "Map"
        return map
    }()
    
    private let titleCard: TextCard = {
        let card = TextCard()
        card.setTitle("Touch anywhere in the map to get information about the place")
        card.isAccessibilityElement = true
        card.accessibilityHint = "Touch anywhere in the map to get information about the place"
        return card
    }()

    private let userLocationButton: IconButtonCard = {
        let button = IconButtonCard()
        button.isAccessibilityElement = true
        button.accessibilityHint = "Get your location"
        return button
    }()

    private var locationButtonAction: (() -> Void)?
    
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
        mapView.addSubview(titleCard)
        userLocationButton.setUpButton(iconName: "location", action: getUserLocation)
        mapView.addSubview(userLocationButton)
        mapView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        
        mapView.showsCompass = false
        let compassBtn = MKCompassButton(mapView: mapView)
        compassBtn.translatesAutoresizingMaskIntoConstraints = false
        compassBtn.compassVisibility = .adaptive
        mapView.addSubview(compassBtn)
        
        let margins = mapView.layoutMarginsGuide
        titleCard.widthAnchor.constraint(lessThanOrEqualTo: margins.widthAnchor).isActive = true
        titleCard.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        titleCard.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        userLocationButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        userLocationButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        compassBtn.centerXAnchor.constraint(equalTo: userLocationButton.centerXAnchor).isActive = true
        compassBtn.bottomAnchor.constraint(equalTo: userLocationButton.topAnchor, constant: -32).isActive = true
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
    
    func setMapMarker(onMark: CLPlacemark) {
        mapView.removeAnnotations(mapView.annotations)
        guard
            let region = onMark.region as? CLCircularRegion
        else { return }
        let annotation = CustomPointAnnotation()
        //annotation.pinCustomImageName = "burg"
        annotation.title = "\(onMark.name!)\n\(onMark.locality ?? "")"
        //annotation.subtitle = "The details"
        annotation.coordinate = region.center
        
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: CustomPointAnnotation.reuseIdentifier)
        mapView.addAnnotation(annotationView.annotation!)
    }
    
    func setMapDelegate(to delegate: MKMapViewDelegate) {
        mapView.delegate = delegate
    }
    
    func setLocationButtonAction(action: (() -> Void)?) {
        locationButtonAction = action
    }
    
    func getUserLocation() {
        if let action = locationButtonAction { action() }
    }
    
}
