//
//  GalleryImageCell.swift
//  Life Index
//
//  Created by Atomisk on 3/2/16.
//  Copyright © 2016 CS125. All rights reserved.
//

import UIKit

class GalleryImageCell: UICollectionViewCell {
	var imageView: UIImageView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height*2))
		imageView.contentMode = UIViewContentMode.ScaleAspectFit
		contentView.addSubview(imageView)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}
