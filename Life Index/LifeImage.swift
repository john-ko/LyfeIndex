//
//  LifeImage.swift
//  Life Index
//
//  Created by Atomisk on 3/3/16.
//  Copyright © 2016 CS125. All rights reserved.
//

import Foundation

class LifeImage: RLMObject {
	dynamic var id: String = ""
	dynamic var image: UIImage? = nil
	dynamic var tags: [String] = []
}