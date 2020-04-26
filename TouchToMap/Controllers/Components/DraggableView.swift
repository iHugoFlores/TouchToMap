//
//  DraggableView.swift
//  TouchToMap
//
//  Created by Hugo Flores Perez on 4/25/20.
//  Copyright © 2020 Hugo Flores Perez. All rights reserved.
//

import UIKit

class DraggableView: UIViewController {
    enum ViewState {
        case expanded, collapsed
    }
    
    let viewHeight: CGFloat = 600
    let handleAreaHeight: CGFloat = 30
    var visualEffect: UIVisualEffectView?
    var viewVisible = false
    var nextState: ViewState {
        return viewVisible ? .collapsed : .expanded
    }
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = .zero
    
    private var contentView: UIView?
    
    var topSafeAreaHeight: CGFloat = 0
    var bottomSafeAreaHeight: CGFloat = 0
    
    let handlingArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    init(mainView: UIView) {
        super.init(nibName: nil, bundle: nil)
        contentView = mainView
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        topSafeAreaHeight = safeFrame.minY
        bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        view.frame.origin.y = view.frame.height - handleAreaHeight - bottomSafeAreaHeight
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
    }
    
    func setUpAnimationActions() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        handlingArea.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc
    func handleCardPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // Start Transition
            startInteractiveTransition(state: nextState, duration: 0.9)
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
    
    func animateTransitionIfNeeded(state: DraggableView.ViewState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.view.frame.origin.y = self.view.frame.height - self.viewHeight
                default:
                    self.view.frame.origin.y = self.view.frame.height - self.handleAreaHeight - self.bottomSafeAreaHeight
                }
            }
            frameAnimator.addCompletion { _ in
                self.viewVisible.toggle()
                self.runningAnimations.removeAll()
            }
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
        }
    }
    
    func startInteractiveTransition(state: DraggableView.ViewState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }

}
