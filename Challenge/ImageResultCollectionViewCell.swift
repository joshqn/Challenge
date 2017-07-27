//
//  ImageResultCollectionViewCell.swift
//  Challenge
//
//  Created by JoshuaKuehn on 7/26/17.
//
//

import UIKit
import AlamofireImage

class ImageResultCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameTextField: UITextField!
  var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
  private var requestReceipt: RequestReceipt?
  
  func configure(for imageResult: ImageResult) {
    setupActivityIndicator()
    setupCellUI()
    searchForImageWith(imageResult: imageResult)
  }
  
  // Programtic activity indicator setup
  private func setupActivityIndicator() {
    
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(activityIndicator)
    // Center the view and activate the constarints
    activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    // Start the animation
    activityIndicator.startAnimating()
    activityIndicator.hidesWhenStopped = true
    
  }
  
  // Setup and putting the UI in a state for the image to be loaded
  private func setupCellUI() {
    self.layer.cornerRadius = 5.0
    self.layer.borderWidth = 1.0
    self.nameTextField.layer.isHidden = true
  }
  
  // Search for the image provide by the imageResult
  private func searchForImageWith(imageResult: ImageResult) {
    // Grab the requestReceipt so the cell can cancel the request is it's reused before finishing
    requestReceipt = Search.downloadImageWith(urlRequest: imageResult.urlRequest, withiD: imageResult.id, completion: { [weak self] isSuccessful in
      if isSuccessful {
        self?.activityIndicator.stopAnimating()
        self?.nameTextField.layer.isHidden = false
        self?.imageView.image = Search.downloader.imageCache?.image(for: imageResult.urlRequest, withIdentifier: imageResult.id)
        self?.nameTextField.text = imageResult.name
        self?.layer.borderColor = UIColor.black.cgColor
        self?.requestReceipt = nil
      }
      
    })
  }
  
  // Clean up the cell if it's going to be reused
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.imageView.image = nil
    self.nameTextField.text = nil
    
    // if this is nil then the requeset was completed. Otherwise it will be cancelled
    if let requestReceipt = requestReceipt {
      Search.cancelRequestWith(requestReceipt: requestReceipt)
    }
  }
    
}
