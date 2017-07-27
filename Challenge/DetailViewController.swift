//
//  DetailViewController.swift
//  Challenge
//
//  Created by JoshuaKuehn on 7/26/17.
//
//

import UIKit

class DetailViewController: UIViewController {

  var imageResult: ImageResult?
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var votesLabel: UILabel!
  @IBOutlet weak var favoritesLabel: UILabel!
  
  override func viewDidLoad() {
      super.viewDidLoad()
    
    createAndAddGestureRecognizer()
    view.backgroundColor = .clear
    formatImageView()
    if let imageResult = imageResult {
      updateUIWith(imageResult: imageResult)
    }
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    // Override the default style so it knows a custom one needs to be used
    modalPresentationStyle = .custom
    transitioningDelegate = self
  }
  
  // Create and add a gesture to dismiss the VC when tapped outside of the popUp View
  func createAndAddGestureRecognizer() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped(_:)))
    tapGesture.cancelsTouchesInView = false
    tapGesture.delegate = self
    view.addGestureRecognizer(tapGesture)
  }
  
  
  private func updateUIWith(imageResult: ImageResult) {
    // Check cache for image associated with imageResult
    if let image = Search.downloader.imageCache?.image(for: imageResult.urlRequest, withIdentifier: imageResult.id) {
      imageView.image = image
    }
    nameLabel.text = imageResult.name
    descriptionLabel.text = imageResult.description
    votesLabel.text = "Votes: \(imageResult.votes)"
    favoritesLabel.text = "Favorites: \(imageResult.favoritesCount)"
  }
  
  // formats the imageView
  private func formatImageView() {
    // Make sure the image is clipped for the rounded corners
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 5.0
    imageView.layer.borderColor = UIColor.black.cgColor
    imageView.layer.borderWidth = 1.0
  }
  
  @IBAction func closeButtonTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: UIGestureRecognizerDelegate
extension DetailViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    // If a user taps the UIView in the view or anything in the uiview this will return false. Otherwise it'll return true and dismiss.
    return (touch.view === self.view)
  }
}

// MARK: UIViewControllerTransitionDelegate
extension DetailViewController: UIViewControllerTransitioningDelegate {
  // Using a custom presentation controller
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
  }
  
  // Use a custom animation controller to animate the VC when it's presented
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return BounceAnimationController()
  }
  
  // Use a custom animation controller to animate when the VC is dismissed
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return SlideOutAnimationController()
  }
}
