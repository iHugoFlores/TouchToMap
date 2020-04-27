//
//  LoginView.swift
//  TouchToMap
//
//  Created by Hugo Flores Perez on 4/27/20.
//  Copyright © 2020 Hugo Flores Perez. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    private let logoImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "logo"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let welcomeLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 2
        text.textAlignment = .center
        return text
    }()
    
    private let autenticationMethodImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "questionmark"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        return button
    }()
    
    private let bottomContainerView = UIView()
    private let bottomView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray
        setUpMain()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpMain() {
        setUpLogoImage()
        setUpWelcomeText()
        setLoginActionArea()
    }
    
    func setUpLogoImage() {
        addSubview(logoImage)
        let margins = layoutMarginsGuide
        logoImage.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -32).isActive = true
        logoImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoImage.topAnchor.constraint(equalTo: margins.topAnchor, constant: 16).isActive = true
        logoImage.widthAnchor.constraint(equalTo: logoImage.heightAnchor).isActive = true
    }
    
    func setUpWelcomeText() {
        let welcomeContent = NSMutableAttributedString(
            string: "Welcome\n",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28)
            ]
        )
        
        welcomeContent.append(NSAttributedString(
            string: "Touch to Map!",
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 34)
            ])
        )
        
        welcomeLabel.attributedText = welcomeContent
        addSubview(welcomeLabel)
        let margins = layoutMarginsGuide
        welcomeLabel.topAnchor.constraint(equalTo: centerYAnchor).isActive = true
        welcomeLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 32).isActive = true
        welcomeLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -32).isActive = true
        //welcomeLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func setLoginActionArea() {
        bottomView.backgroundColor = .white
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.layer.cornerRadius = 16
        //bottomView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        addSubview(bottomView)

        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false

        bottomView.addSubview(bottomContainerView)

        bottomContainerView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        bottomContainerView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true

        bottomView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 16).isActive = true
    }
    
    func setLoginActionContent(buttonTitle: String, imageName: String) {
        loginButton.setTitle(buttonTitle, for: .normal)
        autenticationMethodImage.image = UIImage(systemName: imageName)
        bottomContainerView.addSubview(autenticationMethodImage)
        bottomContainerView.addSubview(loginButton)
        
        loginButton.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor).isActive = true
        autenticationMethodImage.leadingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: 72).isActive = true
        autenticationMethodImage.topAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
        autenticationMethodImage.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor).isActive = true
        autenticationMethodImage.heightAnchor.constraint(equalTo: bottomView.heightAnchor, multiplier: 0.3).isActive = true
        autenticationMethodImage.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor).isActive = true
    }
    
    func setLoginText(title: String, description: String) {
        let content = NSMutableAttributedString(
            string: "\(title)\n",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)
            ]
        )
        
        content.append(NSAttributedString(
            string: description,
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
            ])
        )
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = content
        bottomContainerView.addSubview(label)
        label.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor).isActive = true
    }

}
