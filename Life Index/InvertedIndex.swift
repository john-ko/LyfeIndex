//
//  InvertedIndex.swift
//  Life Index
//
//  Created by Atomisk on 3/8/16.
//  Copyright © 2016 CS125. All rights reserved.
//

import Foundation

class InvertedIndex: RLMObject {
	
	dynamic var tagId: String = ""
	dynamic var imageIds = List<String>
	
	init (keyword: String) {
		self.tagId = keyword
	}
	
	override static func primaryKey() -> String? {
		return "tagId"
	}
}
