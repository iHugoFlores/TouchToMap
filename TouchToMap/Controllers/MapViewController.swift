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

    private let viewObj = MapView()
    
    private var infoView: DraggableView?
    var visualEffect: UIVisualEffectView?
    let cardHeight: CGFloat = 600
    let cardHandleAreaHeight: CGFloat = 60
    var cardVisible = false
    var nextCardState: DraggableView.ViewState {
        return cardVisible ? DraggableView.ViewState.collapsed : DraggableView.ViewState.expanded
    }
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = .zero

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMain()
    }
    
    func setUpMain() {
        view.backgroundColor = UIColor(named: "MapControllerBackground")
        setUpView()
        setUpCard()
    }
    
    func setUpView() {
        //viewObj.setMapDelegate(to: self)
        view.addSubview(viewObj)
        viewObj.setMapPressListener(target: self, action: #selector(onMapTapped(gestureReconizer:)))
        viewObj.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        viewObj.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewObj.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewObj.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setUpCard() {
        let label = UILabel()
        label.text = "View content"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .blue
        label.textAlignment = .center
        print(view.safeAreaInsets)
        infoView = DraggableView(mainView: label)
        addChild(infoView!)
        view.addSubview(infoView!.view)
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
            if region.center.latitude == .zero || region.center.longitude == .zero {
                print("Invalid region?")
                return
            }
            self.viewObj.centerMapInLocation(region.center, regionRadius: region.radius * 2)
            self.viewObj.setMapMarker(onMark: firstLocation)
        }
    }
}
/*
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomPointAnnotation.reuseIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: CustomPointAnnotation.reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let customAnnotation = annotation as! CustomPointAnnotation

        //annotationView?.image = UIImage(imageLiteralResourceName: customAnnotation.pinCustomImageName)
        //annotationView?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("The annotation was selected",view.annotation?.title)
    }
}
*/
