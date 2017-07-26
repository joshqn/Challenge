//
//  DimmingPresentationController.swift
//  Challenge
//
//  Created by JoshuaKuehn on 7/26/17.
//
//

import UIKit

class DimmingPresentationController: UIPresentationController {
  
  lazy var background = UIView(frame: .zero)
  
  override var shouldRemovePresentersView: Bool {
    return false
  }
  
  override func presentationTransitionWillBegin() {
    background.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    background.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    background.frame = containerView!.bounds
    containerView!.insertSubview(background, at: 0)
    background.alpha = 0
    if let coordinator = presentedViewController.transitionCoordinator {
      coordinator.animate(alongsideTransition: { (_) in
        self.background.alpha = 1
      }, completion: nil)
    }
  }
  
  override func dismissalTransitionWillBegin() {
    if let coordinator = presentedViewController.transitionCoordinator {
      coordinator.animate(alongsideTransition: { (_) in
        self.background.alpha = 0
      }, completion: nil)
    }
  }
  
}
