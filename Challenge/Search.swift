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

enum RequestError: Error {
  case badRequest
  case cancelledRequest
}

typealias SearchComplete = (_ error: RequestError?, _ response: [ImageResult]?) -> Void
typealias ImageDownloadComplete = (_ isSucceessful: Bool) -> Void

class Search {
  
  static let downloader = ImageDownloader()
  private static var currentRequest: DataRequest?
  private static var cancelCurrentRequest = false
  
  // Searching for the result of a keyword
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
    currentRequest = Alamofire.request("https://api.500px.com/v1/photos/search", parameters: urlParams)
      .responseJSON { response in
        
        // Invalidate the current request since we've received a response
        currentRequest = nil
        
        // Check for errors
        if (response.result.error == nil) {
          
          // Stop network activity indicator
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
          
          // Serialized Json result dictionary
          guard let resultDict = response.result.value as? [String: Any] else { return }
          
          // Get the number of pages available for this search
          guard let pageCount = resultDict["total_pages"] as? Int else { return }
          // If the page we're searching for is larger than the possible pages then search is done
          if pageCount < page {
            completion(nil, nil)
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
          completion(nil, imageResults)
          
        } else if cancelCurrentRequest == true {
          // The current request was cancelled so we need to set it to nil for the next request
          cancelCurrentRequest = false
          completion(.cancelledRequest , nil)
          
        } else {
          // An error occured with the network
          completion(.badRequest , nil)
          // Stop network activity indicator
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
    }
  }
  
  static func downloadImageWith(urlRequest: URLRequest, withiD id: String, completion: @escaping ImageDownloadComplete) -> RequestReceipt? {
    
    // Check if we already have the image cached
    if downloader.imageCache?.image(for: urlRequest, withIdentifier: id) == nil {
      // Create a requestReceipt and start the download
      let requestReceipt = downloader.download(urlRequest) { (response) in
        // Check for errors
        if response.result.error == nil {
          if let image = response.result.value {
            // Add image to cache
            downloader.imageCache?.add(image, for: urlRequest, withIdentifier: id)
            completion(true)
          }
        } else {
          // An error occured so we indicate the download wasn't completed successfully
          completion(false)
        }
      }
      // return the requestReceipt so the cell can cancel if it needs to
      return requestReceipt
    } else {
      // If there is an image in cache then we can send back a completion
      completion(true)
    }
    
    return nil
  }
  
  // Cancels image downloads if the cell they're being loaded for is reused before it's completed
  static func cancelRequestWith(requestReceipt: RequestReceipt) {
    downloader.cancelRequest(with: requestReceipt)
  }
  
  // If a search doesn't complete then it's cancelled here using the currentRequest
  // further up the currentRequest is set back to nil after error propogation
  static func cancelSearch() {
    if let currentRequest = currentRequest {
      cancelCurrentRequest = true
      currentRequest.cancel()
    }
  }
  
}


























