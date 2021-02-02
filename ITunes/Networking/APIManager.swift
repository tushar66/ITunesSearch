//
//  APIManager.swift
//  ITunes
//
//  Created by Tushar Mendiratta on 31/01/21.
//  Copyright © 2021 None. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
  
  //MARK: - Fetching data from Network
  func request(_ text: String, completion: @escaping (Items?, String?) -> ()){
    let URL = "https://itunes.apple.com/search?"
    
    let parameters: [String : String] = [
      "term": text
    ]
    
    print(parameters)
    
    var comment: String?
    
    if Connectivity.isConnectedToInternet {
        
      AF.request(URL, method: .get, parameters: parameters).responseJSON { (response) in
        
        print(response)
        
        if case .success = response.result {
          guard let data = response.data else { return }
          let decoder = JSONDecoder()
          do {
            let results = try decoder.decode(Items.self, from: data)
            print(results.resultCount)
            if results.results.isEmpty {
              comment = "No Results"
            }
            completion(results, comment)
          } catch {
            print("Error fetch data")
          }
        }
      }
    } else {
      comment = "No internet connection"
      completion(nil, comment)
    }
  }
  
    
    func searchData(_ text: String, completion: @escaping ([Artist]) -> ()){
      let url = "https://itunes.apple.com/search?"
      
      let parameters: [String : String] = [
        "term": text,
        "entity": "musicArtist",
        "limit": "4"
      ]
      
      AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
        if case .success = response.result {
          
            guard let data = response.data else { return }
            let decoder = JSONDecoder()
            do {
              let results = try decoder.decode(Search.self, from: data)
              completion(results.results)
            } catch {
              print("Error fetch data")
            }
          
        }
      }
    }
  
}


class Connectivity {
  class var isConnectedToInternet: Bool {
    return NetworkReachabilityManager()?.isReachable ?? false
  }
  
}



  
  
