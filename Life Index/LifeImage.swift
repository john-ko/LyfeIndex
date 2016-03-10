//
//  LifeImage.swift
//  Life Index
//
//  Created by Atomisk on 3/3/16.
//  Copyright © 2016 CS125. All rights reserved.
//

import UIKit
import RealmSwift

class LifeImage: Object {
	
	dynamic var imageId: String = ""
	dynamic var largeImage: UIImage? = nil
	dynamic var thumbnail: UIImage? = nil
	
	var imageTags: [String] = []
	
}