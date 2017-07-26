//
//  BounceAnimationController.swift
//  Challenge
//
//  Created by JoshuaKuehn on 7/26/17.
//
//

import Foundation
import UIKit

class BounceAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    // Set the transition duration for the below animateTransition
    return 0.4
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    // Grab the viewController we're animating too and the view that is being animated
    if let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to), let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
      let containerView = transitionContext.containerView
      toView.frame = transitionContext.finalFrame(for: toVC)
      containerView.addSubview(toView)
      toView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
      
      // Start the animation block
      UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .calculationModeCubic, animations: {
        // Animate the first 1/3 of the time
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.334, animations: {
          // Scale up the view by 1.2
          toView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        })
        // Animate the 2/3 of the time frame
        UIView.addKeyframe(withRelativeStartTime: 0.334, relativeDuration: 0.333, animations: {
          // Shrink by 0.9
          toView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
        // Final state animation
        UIView.addKeyframe(withRelativeStartTime: 0.666, relativeDuration: 0.333, animations: {
          // End at the proper scale
          toView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
      }, completion: { finished in
        // Let the context know we're finished
        transitionContext.completeTransition(finished)
      })
      
    }
  }
}

