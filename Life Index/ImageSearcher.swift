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

		var results: SearchResults = SearchResults(searchQuery: searchQuery, searchResults: [])
		var indexObjects: [InvertedIndex] = []
		
		let realm = try! Realm()
		let io = realm.objects(InvertedIndex)

		return results
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
