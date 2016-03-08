//
//  GalleryViewController.swift
//  Life Index
//
//  Created by Atomisk on 2/27/16.
//  Copyright © 2016 CS125. All rights reserved.
//

import UIKit
import KrumbsSDK
import MBProgressHUD

class GalleryViewController: UICollectionViewController, KCaptureViewControllerDelegate {
	
	private let reuseIdentifier = "ImageCell"
	private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
	
	//private var searches = [FlickrSearchResults]()
//	private let flickr = Flickr()
	
//	func photoForIndexPath(indexPath: NSIndexPath) -> FlickrPhoto {
//		return searches[indexPath.section].searchResults[indexPath.row]
//	}
	
	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	
	@IBOutlet weak var imageView: UIImageView!
	
	@IBAction func capturePhoto(sender: AnyObject) {
		let vc = KrumbsSDK.sharedInstance().startKCaptureViewController()
		vc.delegate = self
		
		self.presentViewController(vc, animated: true, completion: nil)
	}
	
	func captureController(captureController: KCaptureViewController!, didFinishPickingMediaWithInfo media: [String : AnyObject]!) {
	
		self.imageView.image = media[KCaptureControllerImageUrl] as? UIImage
		
		let mediaJsonUrl: NSURL = (media[KCaptureControllerMediaJsonUrl] as! NSURL)
		NSLog("MediaJsonUrl: ", mediaJsonUrl)
		
		let audioWasCaptured: Bool = (media[KCaptureControllerIsAudioCaptured] as! NSString).boolValue
		NSLog("Audio Was Captured: ", audioWasCaptured)
		
		if (audioWasCaptured) {
			let localAudioUrl: NSURL = (media[KCaptureControllerAudioUrl] as! NSURL)
			NSLog("Local Audio URL: ", localAudioUrl)
		}
		
		let completionState = String(media[KCaptureControllerCompletionState]?.intValue)
		NSLog("Capture Completion State: ", completionState)
		
	}
	
	private func tagAndStoreImage(mediaJsonUrl: NSURL, image: UIImage) {
		
	}
	
	func captureControllerDidCancel(captureController: KCaptureViewController!) {
		NSLog("User Canceled Capture!")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
/*
extension GalleryViewController {
	//1
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return searches.count
	}
	
	//2
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return searches[section].searchResults.count
	}
	
	//3
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		//1
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GalleryImageCell
		//2
		let flickrPhoto = photoForIndexPath(indexPath)
		cell.backgroundColor = UIColor.blackColor()
		//3
		cell.imageView.image = flickrPhoto.thumbnail
		
		return cell
	}
}

extension GalleryViewController: UITextFieldDelegate {
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		// 1
		let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
		textField.addSubview(activityIndicator)
		activityIndicator.frame = textField.bounds
		activityIndicator.startAnimating()
		flickr.searchFlickrForTerm(textField.text!) {
			results, error in
			
			//2
			activityIndicator.removeFromSuperview()
			if error != nil {
				print("Error searching : \(error)")
			}
			
			if results != nil {
				//3
				print("Found \(results!.searchResults.count) matching \(results!.searchTerm)")
				self.searches.insert(results!, atIndex: 0)
				
				//4
				self.collectionView?.reloadData()
			}
		}
		
		textField.text = nil
		textField.resignFirstResponder()
		return true
	}
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
	//1
	func collectionView(collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
			
			let flickrPhoto =  photoForIndexPath(indexPath)
			//2
			if var size = flickrPhoto.thumbnail?.size {
				size.width += 10
				size.height += 10
				return size
			}
			return CGSize(width: 100, height: 100)
	}
	
	//3
	func collectionView(collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAtIndex section: Int) -> UIEdgeInsets {
			return sectionInsets
	}
}
*/