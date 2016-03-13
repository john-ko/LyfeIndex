//
//  InvertedIndex.swift
//  Life Index
//
//  Created by Atomisk on 3/8/16.
//  Copyright © 2016 CS125. All rights reserved.
//

import UIKit
import RealmSwift

class Strings: Object {
	dynamic var name = ""
}

class LifeImage: Object {
	
	dynamic var imageId = ""
	dynamic var largeImage: NSData? = nil
	//dynamic var thumbnail: UIImage? = nil
	
	var imageTags = List<Strings>()
	
	override static func primaryKey() -> String? {
		return "imageId"
	}
}

class InvertedIndex: Object {
	
	dynamic var tagId = ""
	let imageIds = List<Strings>()
	
	override static func primaryKey() -> String? {
		return "tagId"
	}
}
