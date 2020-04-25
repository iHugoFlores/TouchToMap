//
//  ButtonCard.swift
//  TouchToMap
//
//  Created by Hugo Flores Perez on 4/25/20.
//  Copyright © 2020 Hugo Flores Perez. All rights reserved.
//

import UIKit

class IconButtonCard: UIView {
    
    private static let buttonSize: CGFloat = 22
    private static let marginVal: CGFloat = 12
    private var onPress: (() -> Void)?

    private let button: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private let icon: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "questionmark")!.withRenderingMode(.alwaysOriginal))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpMain()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpMain() {
        backgroundColor = UIColor(white: 1, alpha: 0.7)
        insetsLayoutMarginsFromSafeArea = false
        layoutMargins = UIEdgeInsets(top: IconButtonCard.marginVal, left: IconButtonCard.marginVal, bottom: IconButtonCard.marginVal, right: IconButtonCard.marginVal)
        let margins = layoutMarginsGuide
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = IconButtonCard.buttonSize + (IconButtonCard.marginVal / CGFloat(2))
        layer.shadowRadius = 1
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.5
        button.addSubview(icon)
        addSubview(button)

        icon.leadingAnchor.constraint(equalTo: button.leadingAnchor).isActive = true
        icon.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
        icon.topAnchor.constraint(equalTo: button.topAnchor).isActive = true
        icon.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        
        button.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    @objc
    func buttonAction(sender: UIButton) {
        guard let onPress = onPress else { return }
        onPress()
    }
    
    func setUpButton(iconName: String, action: @escaping () -> Void) {
        icon.image = UIImage(systemName: iconName)
        onPress = action
    }

}
