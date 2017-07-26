//
//  SearchViewController.swift
//  Challenge
//
//  Created by JoshuaKuehn on 7/26/17.
//
//

import UIKit

class SearchViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var lineSpacing:CGFloat = 8
  var minInterSpacing:CGFloat = 8
  let detailSegueIdentifier = "ModalDetail"
  
  override func viewDidLoad() {
      super.viewDidLoad()
    
    collectionView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)

  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == detailSegueIdentifier {
      let detailVC = segue.destination as! DetailViewController
      let indexPath = sender as! IndexPath
    }
  }
  
}

//MARK: UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 50
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
  }
}

//MARK: UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    performSegue(withIdentifier: detailSegueIdentifier, sender: indexPath)
  }
}

//MARK: UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = Int(((self.view.frame.width) / 3) - (lineSpacing + minInterSpacing))
    return CGSize(width: width, height: width)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    let inset: CGFloat = 8.0
    return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return lineSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return minInterSpacing
  }
}

//MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    print("Clicked")
  }
}
