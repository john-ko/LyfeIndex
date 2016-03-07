//
//  LifeImage.swift
//  Life Index
//
//  Created by Atomisk on 3/3/16.
//  Copyright © 2016 CS125. All rights reserved.
//

import Foundation
import RealmSwift

class LifeImage: Object {
	dynamic var id: String
	dynamic var tags: [String] = []
	
	init(var imageURL: String) {
		self.id = imageURL
	}
}
