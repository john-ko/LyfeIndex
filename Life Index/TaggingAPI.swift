//  TaggingAPI.swift
//  IOS8swiftTakePhoto
//
//  Created by John Ko on 2/20/16.
//  Copyright © 2016 John Ko. All rights reserved.
//
//  usage
//  let taggingAPI = TaggingAPI()
//  taggingAPI.postImage(image, callback: callBackFunction)
//
//

import Foundation
import UIKit

class TaggingAPI {
	
	var API_KEY = "###"
	
	func resizeImage(imageSize: CGSize, image: UIImage) -> NSData {
		UIGraphicsBeginImageContext(imageSize)
		image.drawInRect(CGRectMake(0, 0, imageSize.width, imageSize.height))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		let resizedImage = UIImagePNGRepresentation(newImage)
		UIGraphicsEndImageContext()
		return resizedImage!
	}
	
	func base64EncodeImage(image: UIImage) -> String {
		var imagedata = UIImagePNGRepresentation(image)
		
		// Resize the image if it exceeds the 2MB API limit
		if (imagedata?.length > 2097152) {
			let oldSize: CGSize = image.size
			let newSize: CGSize = CGSizeMake(800, oldSize.height / oldSize.width * 800)
			imagedata = resizeImage(newSize, image: image)
		}
		
		return imagedata!.base64EncodedStringWithOptions(.EncodingEndLineWithCarriageReturn)
	}
	
	func createRequest(imageData: String, callback: ([String]) -> Void) {
		// Create our request URL
		let request = NSMutableURLRequest(URL: NSURL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(API_KEY)")!)
		request.HTTPMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		// Build our API request
		let jsonRequest: [String: AnyObject] = [
			"requests": [
				"image": [
					"content": imageData
				],
				"features": [
					[
						"type": "LABEL_DETECTION",
						"maxResults": 15
					]
				]
			]
		]
		
		// Serialize the JSON
		request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonRequest, options: [])
		
		// Run the request on a background thread
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
			self.runRequestOnBackgroundThread(request)
		});
		
	}
	
	func parseJson(jsonData: NSString) -> [String] {
		let data = jsonData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
		
		var results = [String]()
		
		do {
			let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String: AnyObject]
			//let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String: AnyObject]
			if let responses = json["responses"] {
				
				if let response = responses as? [[String: AnyObject]] {
					//print(response)
					for r in response {
						print(r)
						if let labelAnnotations = r["labelAnnotations"] as? [[String: AnyObject]] {
							for annotations in labelAnnotations {
								if let description = annotations["description"] as? String {
									print(description)
									results.append(description)
								}
							}
						} else {
							return results
						}
					}
				}
			} else {
				return results
			}
		} catch let error as NSError {
			print("Failed to load: \(error.localizedDescription)")
		}
		print(results)
		
		return results
	}
	
	func runRequestOnBackgroundThread(request: NSMutableURLRequest) {
		
		let session = NSURLSession.sharedSession()
		
		// run the request
		let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
			print(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
			self.parseJson(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
			
		})
		task.resume()
	}
	
	func postImage(myImage: UIImage?, callback: ([String]) -> Void) {
		createRequest(base64EncodeImage(myImage!.resizeToWidth(500)), callback:callback)
	}
}

extension UIImage {
	func resize(scale:CGFloat)-> UIImage {
		let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width*scale, height: size.height*scale)))
		imageView.contentMode = UIViewContentMode.ScaleAspectFit
		imageView.image = self
		UIGraphicsBeginImageContext(imageView.bounds.size)
		imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
		let result = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return result
	}
	func resizeToWidth(width:CGFloat)-> UIImage {
		let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
		imageView.contentMode = UIViewContentMode.ScaleAspectFit
		imageView.image = self
		UIGraphicsBeginImageContext(imageView.bounds.size)
		imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
		let result = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return result
	}
}