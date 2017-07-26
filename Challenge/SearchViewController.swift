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
  var page = 0
  
  var startingNumberOfCells = 0
  var endingNumberOfCells = 0
  
  var imageResults:[ImageResult] = [] {
    didSet {
      startingNumberOfCells = oldValue.count
      endingNumberOfCells = imageResults.count
    }
  }
  var isLoading = false
  
  override func viewDidLoad() {
      super.viewDidLoad()
    
    collectionView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)

  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  func searchForImageWith(name: String) {
    Search.performSearchFor(imageName: name, page: page) { (isSuccessful, results) in
      
      // We're done loading the results of our search
      self.isLoading = false
      
      // If our search is succesful execute this block
      if isSuccessful {
        
        // Verify we got results
        if let results = results {
          // Append the new results to our imageResults array
          self.imageResults += results
          // Do a Batch update of inserts into the collectionView
          self.collectionView.performBatchUpdates({
            // Grab the indexPaths that are being inserted
            let indexPaths = self.createIndexPathsToInsertIntoCollectionView()
            self.collectionView.insertItems(at: indexPaths)
          }, completion: nil)
        } else {
          // If results is nil then there are no more results so we display this alert
          self.noMoreResultsAlert()
        }
      } else {
        // Indicate there is an issue with the network
        self.networkAlert()
      }
      
    }
    // Iterate the page to load
    page += 1
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == detailSegueIdentifier {
      let detailVC = segue.destination as! DetailViewController
      let indexPath = sender as! IndexPath
    }
  }
  
  // MARK: Helper Functions
  func createIndexPathsToInsertIntoCollectionView() -> [IndexPath] {
    var indexPaths: [IndexPath] = []
    
    for i in startingNumberOfCells..<endingNumberOfCells {
      let indexPath = IndexPath(item: i, section: 0)
      indexPaths.append(indexPath)
    }
    
    return indexPaths
  }
  
  func IndexPathsToBeDeleted() -> [IndexPath] {
    var indexPaths:[IndexPath] = []
    
    for i in 0..<endingNumberOfCells {
      let indexPath = IndexPath(item: i, section: 0)
      indexPaths.append(indexPath)
    }
    return indexPaths
  }
  
  // MARK: Alert Controllers
  func networkAlert() {
    let alert = UIAlertController(title: "Whooops...", message: "Looks like there's an error with the network. Try again later.", preferredStyle: .alert)
    let okButton = UIAlertAction(title: "OK", style: .cancel)
    
    alert.addAction(okButton)
    
    present(alert, animated: true, completion: nil)
    
  }
  
  func noMoreResultsAlert() {
    let alert = UIAlertController(title: "That's all of them", message: "Looks like theres no other pictures. Try searching for something else", preferredStyle: .alert)
    let okButton = UIAlertAction(title: "OK", style: .cancel)
    
    alert.addAction(okButton)
    
    present(alert, animated: true, completion: nil)
  }
  
}

//MARK: UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageResults.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageResultCollectionViewCell
    let imageResult = imageResults[indexPath.row]
    cell.configure(for: imageResult)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
    // If the next row to be displayed is the last and nothing is loading then search for more images
    if imageResults.count - indexPath.row < 2 && isLoading == false {
      isLoading = true
      searchForImageWith(name: searchBar.text!)
    }
    
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
    isLoading = true
    
    // Check if the imageResults array is currently holding anything
    if imageResults.count > 0 {
      imageResults.removeAll()
      collectionView.reloadData()
    }
    
    page = 1
    searchForImageWith(name: searchBar.text!)
    
    searchBar.resignFirstResponder()
  }
}
