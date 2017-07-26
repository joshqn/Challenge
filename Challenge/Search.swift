//
//  Search.swift
//  Challenge
//
//  Created by JoshuaKuehn on 7/26/17.
//
//

import Foundation
import Alamofire
import AlamofireImage

typealias SearchComplete = (_ isSuccessful: Bool, _ response: [ImageResult]?) -> Void
typealias ImageDownloadComplete = () -> Void

class Search {
  static let downloader = ImageDownloader()
  
  static func performSearchFor(imageName: String, page: Int, completion: @escaping SearchComplete) {
    var imageResults: [ImageResult] = []
    
    // Add URL parameters
    let urlParams = [
      "term": imageName,
      "consumer_key":"L1Yj9o68dZub8KbSSYEdCrQG5G4tapkehKgqYVKt",
      "page": "\(page)",
    ]
    
    // Indicate that network activity has started
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    // Fetch Request
    Alamofire.request("https://api.500px.com/v1/photos/search", parameters: urlParams)
      .responseJSON { response in
        
        // Stop network activity indicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        // Check for errors with the results
        if (response.result.error == nil) {
          
          // Serialized Json result dictionary
          guard let resultDict = response.result.value as? [String: Any] else { return }
          
          // Get the number of pages available for this search
          guard let pageCount = resultDict["total_pages"] as? Int else { return }
          // If the page we're searching for is larger than the possible pages then search is done
          if pageCount < page {
            completion(true, nil)
          }
          
          // Grabbing the array of photos we received back
          guard let array = resultDict["photos"] as? [Any] else { return }
          
          // Iterate through the array grabbing json to init ImageResult values
          for json in array {
            
            // Cast the values we get from the array into the json dictionary form
            if let json = json as? [String: Any] {
              do {
                // Attempt to get a result back
                let imageResult = try ImageResult(json: json)
                imageResults.append(imageResult)
              } catch let error as SerializationError {
                // If the initializer throws then we'll get those errors here
                print(error)
              } catch {
                // Catch-all for errors
                print(error.localizedDescription)
              }
              
            }
          }
          
          // Successful and return all of the imageResults
          completion(true, imageResults)
        }
        else {
          // An error occured and we've got no results
          completion(false, nil)
        }
        
        
    }
  }
  
}