//
//  ImageSearcher.swift
//  Life Index
//
//  Created by Atomisk on 3/2/16.
//  Copyright © 2016 CS125. All rights reserved.
//

import UIKit
import RealmSwift

struct SearchResults {
	let searchQuery : String
	var searchResults : [UIImage] = []
}

class ImageSearcher {

	private let stopWords = ["I", "a", "about", "an", "are", "as", "at", "be", "by", "com", "for", "from", "how", "in", "is", "it", "of", "on", "or", "that", "the", "this", "to", "was", "what", "when", "where", "who", "will", "with", "the", "www"]

	func searchLifeIndexForImage(searchQuery: String) -> SearchResults {
		let searchTags: [String] = self.removeStopWords(self.tokenizeQuery(searchQuery))
		print("Query: \(searchQuery) normalized to: \(searchTags)")

		var searchResults: SearchResults = SearchResults(searchQuery: searchQuery, searchResults: [])
		var indexObjects: [InvertedIndex] = []
		var lifeImages: [LifeImage] = []

		let realm = try! Realm()

		for i in 0..<searchTags.count {
			let indexObject = realm.objectForPrimaryKey(InvertedIndex.self, key: searchTags[i])
			indexObjects.append(indexObject!)
		}
		
		for i in 0..<indexObjects.count {
			for j in 0...indexObjects[i].imageIds.count {
				let lifeImage = realm.objectForPrimaryKey(LifeImage.self, key: indexObjects[i].imageIds[j])
				lifeImages.append(lifeImage!)
			}
		}
		
		for i in 0..<lifeImages.count {
			searchResults.searchResults.append(lifeImages[i].largeImage!)
		}

		return searchResults
	}

	// returns a list of space delimited tokens
	private func tokenizeQuery(searchQuery: String) -> [String] {

		return searchQuery.lowercaseString.characters.split{$0 == " "}.map(String.init)
	}

	private func removeStopWords(var list: [String]) -> [String] {
		for word in self.stopWords {
			if let index = list.indexOf(word) {
				list.removeAtIndex(index)
			}
		}
		return list
	}
}
