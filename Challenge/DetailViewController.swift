//
//  DetailViewController.swift
//  Challenge
//
//  Created by JoshuaKuehn on 7/26/17.
//
//

import UIKit

class DetailViewController: UIViewController {

  override func viewDidLoad() {
      super.viewDidLoad()
    
    createAndAddGestureRecognizer()
    
    view.backgroundColor = .clear
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    modalPresentationStyle = .custom
    transitioningDelegate = self
  }
  
  func createAndAddGestureRecognizer() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped(_:)))
    tapGesture.cancelsTouchesInView = false
    tapGesture.delegate = self
    view.addGestureRecognizer(tapGesture)
  }
  
  @IBAction func closeButtonTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: UIGestureRecognizerDelegate
extension DetailViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return (touch.view === self.view)
  }
}

// MARK: UIViewControllerTransitionDelegate
extension DetailViewController: UIViewControllerTransitioningDelegate {
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
  }
}
