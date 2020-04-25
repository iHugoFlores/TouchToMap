//
//  DraggableView.swift
//  TouchToMap
//
//  Created by Hugo Flores Perez on 4/25/20.
//  Copyright © 2020 Hugo Flores Perez. All rights reserved.
//

import UIKit

class DraggableView: UIViewController {
    //private var contentView: UIView?
    
    enum ViewState {
        case expanded, collapsed
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        let label = UILabel()
        label.text = "Test"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }

}
