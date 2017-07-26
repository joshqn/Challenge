//
//  SlideOutAnimationController.swift
//  Challenge
//
//  Created by JoshuaKuehn on 7/26/17.
//
//

import Foundation
import UIKit

class SlideOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    // Set the transition duration
    return 0.3
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    if let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) {
      let containerView = transitionContext.containerView
      
      // Getting the duration of time the animation will be transitioning
      let duration = transitionDuration(using: transitionContext)
      
      // Start the animation
      UIView.animate(withDuration: duration, animations: {
        // Animate up
        fromView.center.y -= containerView.bounds.size.height
        // Shrink the view by a factor of 0.5
        fromView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
      }, completion: { finished in
        // Indicate that our animation has finished
        transitionContext.completeTransition(finished)
      })
    }
  }
}
