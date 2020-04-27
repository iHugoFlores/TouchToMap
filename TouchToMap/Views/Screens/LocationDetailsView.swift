//
//  LocationDetailsView.swift
//  TouchToMap
//
//  Created by Hugo Flores Perez on 4/25/20.
//  Copyright © 2020 Hugo Flores Perez. All rights reserved.
//

import MapKit
import UIKit

class LocationDetailsView: UIView {
    
    private let contentText: UITextView = {
        let text = UITextView()
        text.isEditable = false
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .clear
        return text
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpMain()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpMain() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentText)
        let margins = layoutMarginsGuide
        contentText.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        contentText.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        contentText.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        contentText.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    func setLocationData(_ mark: CLPlacemark) {
        //print(mark.subAdministrativeArea, mark.subLocality)
        let stringContent = NSMutableAttributedString()
        if let locality = mark.locality, let country = mark.country {
            stringContent.append(NSAttributedString(
                string: "\(locality) - \(country)\n",
                attributes: [
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)
                ])
            )
        }
        if let administrativeArea = mark.administrativeArea, let subAdministrativeArea = mark.subAdministrativeArea {
            stringContent.append(NSAttributedString(
                string: "\(administrativeArea) - \(subAdministrativeArea)\n",
                attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                    NSAttributedString.Key.foregroundColor: UIColor.systemGray
                ])
            )
        }
        if let name = mark.name {
            stringContent.append(NSAttributedString(
                string: name + "\n",
                attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)
                ])
            )
        }
        
        contentText.attributedText = stringContent
    }
    
}
