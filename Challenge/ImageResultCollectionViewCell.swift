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
  weak var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  
  func configure(for imageResult: ImageResult) {
    setupActivityIndicator()
    setupCellUI()
    
  }
  
  func setupActivityIndicator() {
    if let activityIndicator = activityIndicator {
      activityIndicator.translatesAutoresizingMaskIntoConstraints = false
      self.addSubview(activityIndicator)
      activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
      activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
      activityIndicator.startAnimating()
      activityIndicator.hidesWhenStopped = true
    }
  }
  
  func setupCellUI() {
    self.layer.cornerRadius = 5.0
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor.black.cgColor
    self.nameTextField.layer.isHidden = true
  }
    
}
