//
//  ViewModel.swift
//  ITunes
//
//  Created by Tushar Mendiratta on 31/01/21.
//  Copyright © 2021 None. All rights reserved.
//

import UIKit
import Foundation

class ViewModel {
  
  let repository = APIManager()
  var comment: String?
  var didUpdateDataToUI: (([Track]) -> Void)?
  private(set) var dataToUI: [Track]? {
    didSet {
      didUpdateDataToUI?(dataToUI!)
    }
  }
  var didUpdateSearchArrayToUI: (([String]) -> Void)?
  var searchArray: [String]? {
    didSet {
      didUpdateSearchArrayToUI?(searchArray!)
    }
  }
  
  
  func request(with text: String) {
    repository.request(text){ [weak self] (items, text) in
      guard let self = self else { return }
      
      if let resultData = items {
        self.comment = text
        self.dataToUI = resultData.results
      } else {
        self.comment = text
      }
    }
  }
  
  
  func search(_ text: String) {
    repository.searchData(text) {[weak self] (items) in
      guard let self = self else { return }
      
      var resultArray = [String]()
      for item in 0 ..< items.count {
        let artistName = items[item].artistName
        if !resultArray.contains(artistName) {
          resultArray.append( artistName) }
      }
      self.searchArray = resultArray
    }
  }
  
}

