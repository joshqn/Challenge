//
//  ImageResult.swift
//  Challenge
//
//  Created by JoshuaKuehn on 7/26/17.
//
//

import Foundation

// Possible errors when initializing the ImageResult
enum SerializationError: Error {
  case missing(String)
  case initIssue(String)
}

struct ImageResult {
  var name: String
  var url: URL
  // Default description b/c some pictures don't have descriptions
  var description: String = "No Description Available"
  var id: String
  var urlRequest: URLRequest
  var votes: Int
  var favoritesCount: Int
  
  // Init throws and lets the caller handle error
  init(json: [String: Any]) throws {
    
    guard let name = json["name"] as? String else {
      throw SerializationError.missing("name")
    }
    self.name = name
    
    guard let urlString = json["image_url"] as? String else {
      throw SerializationError.missing("url")
    }
    
    guard let id = json["id"] as? Int else {
      throw SerializationError.missing("id")
    }
    self.id = "\(id)"
    
    if let description = json["description"] as? String {
      self.description = description
    }
    
    guard let url = URL(string: urlString) else {
      throw SerializationError.initIssue(urlString)
    }
    self.url = url
    self.urlRequest = URLRequest(url: url)
    
    guard let votes = json["votes_count"] as? Int else {
      throw SerializationError.missing("votes_count")
    }
    self.votes = votes
    
    guard let favoritesCount = json["favorites_count"] as? Int else {
      throw SerializationError.missing("favorites_count")
    }
    self.favoritesCount = favoritesCount
    
  }
}
