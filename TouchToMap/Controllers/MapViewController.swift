//
//  ViewController.swift
//  TouchToMap
//
//  Created by Hugo Flores Perez on 4/25/20.
//  Copyright © 2020 Hugo Flores Perez. All rights reserved.
//

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
        viewObj.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        viewObj.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewObj.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewObj.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}

