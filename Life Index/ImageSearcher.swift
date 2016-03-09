//
//  ImageSearcher.swift
//  Life Index
//
//  Created by Atomisk on 3/2/16.
//  Copyright © 2016 CS125. All rights reserved.
//

import Foundation
import UIKit

struct SearchResults {
	let searchQuery : String
	let searchResults : [UIImage] = []
}

class ImageSearcher {

	let stopWords = ["I", "a", "about", "an", "are", "as", "at", "be", "by", "com", "for", "from", "how", "in", "is", "it", "of", "on", "or", "that", "the", "this", "to", "was", "what", "when", "where", "who", "will", "with", "the", "www"]

	func searchLifeIndexForImage(searchQuery: String) -> SearchResults {
		let searchTags: [String] = self.tokenizeQuery(searchQuery)
		let results: SearchResults = SearchResults(searchQuery: searchQuery)

		for i in 1...searchTags.count {

		}

		return results
	}

	// returns a list of space delimited tokens
	private func tokenizeQuery(searchQuery: String) -> [String] {
		return searchQuery.characters.split{$0 == " "}.map(String.init)
	}
	
	private func toLower(list: [String]) -> [String] {
		
	}

	private func removeStopWords(list: [String]) -> [String] {
		var newlist = list.filter({ $0 != })
	}

}

extension Array where Element: Equatable {
	mutating func removeObjectsInArray(array: [Element]) {
		for object in array {
			self.removeAll()
		}
	}
}
