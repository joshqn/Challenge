//
//  DimmingPresentationController.swift
//  Challenge
//
//  Created by JoshuaKuehn on 7/26/17.
//
//

import UIKit

class DimmingPresentationController: UIPresentationController {
  
  // this background will be used instead of the one in DetailVC when presenting
  lazy var background = UIView(frame: .zero)
  
  // This makes sure that the SearchVC view doesn't disappear when DetailVC is presented
  override var shouldRemovePresentersView: Bool {
    return false
  }
  
  override func presentationTransitionWillBegin() {
    setupBackground()
    // Grabing the coordinator responsible for the presentation so that the background can be animated at the same rate
    if let coordinator = presentedViewController.transitionCoordinator {
      coordinator.animate(alongsideTransition: { (_) in
        // Make the background fade in
        self.background.alpha = 1
      }, completion: nil)
    }
  }
  
  override func dismissalTransitionWillBegin() {
    if let coordinator = presentedViewController.transitionCoordinator {
      coordinator.animate(alongsideTransition: { (_) in
        // Make the background fade out
        self.background.alpha = 0
      }, completion: nil)
    }
  }
  
  private func setupBackground() {
    background.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    // If we switch orientation while the detailVC is visible these autoresizing mask make sure it covers the whole view
    background.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    background.frame = containerView!.bounds
    containerView!.insertSubview(background, at: 0)
    // We want the background to fade in so initially it's invisible
    background.alpha = 0
  }
  
}
