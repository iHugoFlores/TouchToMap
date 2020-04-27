//
//  DraggableView.swift
//  TouchToMap
//
//  Created by Hugo Flores Perez on 4/25/20.
//  Copyright © 2020 Hugo Flores Perez. All rights reserved.
//

import UIKit

class DraggableView: UIViewController {
    private enum ViewState {
        case expanded, collapsed
    }
    
    private var viewHeight: CGFloat = 0
    private let handleAreaHeight: CGFloat = 30
    private var visualEffect: UIVisualEffectView?
    private var viewVisible = false
    private var nextState: ViewState {
        return viewVisible ? .collapsed : .expanded
    }
    private var runningAnimations = [UIViewPropertyAnimator]()
    private var animationProgressWhenInterrupted: CGFloat = .zero
    private let animationDuration: TimeInterval = 0.9
    
    private var contentView: UIView?
    private var onAnimationDone: (() -> Void)?
    
    private var topSafeAreaHeight: CGFloat = 0
    private var bottomSafeAreaHeight: CGFloat = 0
    
    let handlingArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 16
        let icon = UIImageView(image: UIImage(systemName: "minus")!.withRenderingMode(.alwaysTemplate))
        icon.tintColor = .systemGray
        icon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(icon)
        
        icon.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        icon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 100).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return view
    }()
    
    init(mainView: UIView, heightRatio: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        contentView = mainView
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        topSafeAreaHeight = safeFrame.minY
        bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
        viewHeight = (safeFrame.height * heightRatio) - handleAreaHeight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        blurEffectView.layer.cornerRadius = 16
        blurEffectView.clipsToBounds = true
        view.insertSubview(blurEffectView, at: 0)
        setUpAnimatableViews()
        setUpMain()
        setUpAnimationActions()
    }
    
    func setUpAnimatableViews() {
        visualEffect = UIVisualEffectView()
        visualEffect?.isUserInteractionEnabled = false
        visualEffect?.frame = view.frame
        view.addSubview(visualEffect!)
    }
    
    func setViewCompressedPosition() {
        view.frame.origin.y = view.frame.height
    }
    
    func setViewExpandedPosition() {
        view.frame.origin.y = view.frame.height - viewHeight - handleAreaHeight - bottomSafeAreaHeight
    }
    
    func setUpMain() {
        guard let contentView = contentView else { return }
        view.addSubview(handlingArea)
        view.addSubview(contentView)
        
        setViewCompressedPosition()
        
        let margins = view.safeAreaLayoutGuide
        handlingArea.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        handlingArea.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        handlingArea.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        handlingArea.heightAnchor.constraint(equalToConstant: handleAreaHeight).isActive = true

        contentView.topAnchor.constraint(equalTo: handlingArea.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        //contentView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    func setUpAnimationActions() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        handlingArea.addGestureRecognizer(panGestureRecognizer)
    }
    
    func expandView(onAnimationDone: (() -> Void)?) {
        if viewVisible { return }
        animateTransitionIfNeeded(state: nextState, duration: animationDuration)
        self.onAnimationDone = onAnimationDone
    }
    
    @objc
    func handleCardPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // Start Transition
            startInteractiveTransition(state: nextState, duration: animationDuration)
        case .changed:
            // Update Transition
            let translation = recognizer.translation(in: view)
            var fractionCompleted = translation.y / viewHeight
            fractionCompleted = viewVisible ? fractionCompleted : -fractionCompleted
            updateInteractiveTransition(fractionCompleted: fractionCompleted)
        case .ended:
            // Continue transition
            continueInteractiveTransition()
        default:
            print("Not implemented")
        }
    }
    
    private func animateTransitionIfNeeded(state: DraggableView.ViewState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded: self.setViewExpandedPosition()
                default: self.setViewCompressedPosition()
                }
            }
            frameAnimator.addCompletion { _ in
                self.viewVisible.toggle()
                self.runningAnimations.removeAll()
                if let onAnimationDone = self.onAnimationDone {
                    onAnimationDone()
                    self.onAnimationDone = nil
                }
            }
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
        }
    }
    
    private func startInteractiveTransition(state: DraggableView.ViewState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    private func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    private func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }

}
