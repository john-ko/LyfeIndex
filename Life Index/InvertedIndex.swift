//
//  InvertedIndex.swift
//  Life Index
//
//  Created by Atomisk on 3/8/16.
//  Copyright © 2016 CS125. All rights reserved.
//

import Foundation

class InvertedIndex: RLMObject {
	
	dynamic var tagId: String
	var imageIds: [String] = []
	
	init (keyword: String) {
		self.tagId = keyword
		super.init()
	}
	
	override static func primaryKey() -> String? {
		return "tagId"
	}
}
