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
  
  // Variables for spacing of the collectionView
  var lineSpacing:CGFloat = 8
  var minInterSpacing:CGFloat = 8
  
  let detailSegueIdentifier = "ModalDetail"
  let collectionViewCellIdentifier = "Cell"
  var page = 0
  
  // These help indicate where new results need to be inserted
  var startingNumberOfCells = 0
  var endingNumberOfCells = 0
  
  var imageResults:[ImageResult] = [] {
    didSet {
      startingNumberOfCells = oldValue.count
      endingNumberOfCells = imageResults.count
    }
  }
  var isLoading = false
  var framesShortestSideLength:CGFloat = 0
  
  override func viewDidLoad() {
      super.viewDidLoad()
    // Top inset needs to be adjusted b/c of the searchBar
    collectionView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
    // Getting the shortest side helps make sure the cells aren't resized to be larger thus stretching the images when switching between portrait/landscape and visa versa
    framesShortestSideLength = CGFloat(self.view.frame.width < self.view.frame.height ? self.view.frame.width : self.view.frame.height)
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  // Grabs search results to add to the imageResults array
  func searchForImageWith(name: String) {
    Search.performSearchFor(imageName: name, page: page) { (error, results) in
      
      // We're done loading the results of our search
      self.isLoading = false
      
      // If our search is succesful execute this block
      if error == nil {
        
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
      } else if error == .badRequest {
        // Indicate there is an issue with the network
        self.networkAlert()
      } else if error == .cancelledRequest {
        // Previous request was cancelled because of a new request
      }
      
    }
    // Iterate the page to load
    page += 1
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == detailSegueIdentifier {
      let detailVC = segue.destination as! DetailViewController
      let indexPath = sender as! IndexPath
      let imageResult = imageResults[indexPath.row]
      detailVC.imageResult = imageResult
    }
  }
  
  // MARK: Helper Functions
  // Creates indexPaths to be inserted
  func createIndexPathsToInsertIntoCollectionView() -> [IndexPath] {
    var indexPaths: [IndexPath] = []
    
    for i in startingNumberOfCells..<endingNumberOfCells {
      let indexPath = IndexPath(item: i, section: 0)
      indexPaths.append(indexPath)
    }
    
    return indexPaths
  }
  
  // MARK: Alert Controllers
  // If a network error is encountered this will be called
  func networkAlert() {
    let alert = UIAlertController(title: "Whooops...", message: "Looks like there's an error with the network. Try again later.", preferredStyle: .alert)
    let okButton = UIAlertAction(title: "OK", style: .cancel)
    
    alert.addAction(okButton)
    
    present(alert, animated: true, completion: nil)
    
  }
  
  // Will be displayed if we reach the last possible page of the search term
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
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as! ImageResultCollectionViewCell
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
    var width = 0
    
    // Check if we're on an ipad. If so we want more cells per row because of the image size
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
      width = Int(((framesShortestSideLength) / 5) - (lineSpacing + minInterSpacing))
    } else {
      width = Int(((framesShortestSideLength) / 3) - (lineSpacing + minInterSpacing))
    }
    
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
  // Attaches the searchBar to the top of the VC
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    // If we're in the loading state then we need to cancel our current search that is loading
    if isLoading {
      Search.cancelSearch()
    }
    
    // If we're not already loading then we need to make sure the state isLoading is true
    isLoading = true
    
    // Check if the imageResults array is currently holding anything
    if imageResults.count > 0 {
      imageResults.removeAll()
      collectionView.reloadData()
    }
    
    // Reset the page we want to search for
    page = 1
    
    //Make a search using the text in the searchBar
    searchForImageWith(name: searchBar.text!)
    
    searchBar.resignFirstResponder()
  }
}
