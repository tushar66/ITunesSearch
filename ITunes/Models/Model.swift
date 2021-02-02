//
//  Model.swift
//  ITunes
//
//  Created by Tushar Mendiratta on 31/01/21.
//  Copyright © 2021 None. All rights reserved.
//

import Foundation

struct Items: Codable {
  let resultCount: Int
  let results: [Track]
}


struct Track: Codable {
  let wrapperType: WrapperType
  let artistID, collectionID: Int?
  let artistName, trackName, previewUrl, collectionName, collectionCensoredName: String?
  let artistViewURL, collectionViewURL: String?
  let artworkUrl60, artworkUrl100: String?
  let collectionPrice: Double?
  let trackTimeMillis, trackCount: Int?
  let trackPrice: Float?
  let copyright: String?
  let country: String?
  let currency: String?
  let releaseDate: String?
  let primaryGenreName: String?
  let contentAdvisoryRating: String?
  
  enum CodingKeys: String, CodingKey {
    case wrapperType
    case trackPrice
    case artistID = "artistId"
    case collectionID = "collectionId"
    case artistName, trackName, previewUrl, collectionName, collectionCensoredName
    case artistViewURL = "artistViewUrl"
    case collectionViewURL = "collectionViewUrl"
    case artworkUrl60, artworkUrl100, collectionPrice, trackTimeMillis, trackCount, copyright, country, currency, releaseDate, primaryGenreName, contentAdvisoryRating
  }
}


enum WrapperType: String, Codable {
  case collection = "collection"
  case track = "track"
}



struct Search: Codable {
  let resultCount: Int
  let results: [Artist]
}


struct Artist: Codable {
  let artistName: String
  
}
