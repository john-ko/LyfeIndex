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
	
	private var hud: MBProgressHUD = MBProgressHUD()
	
	private let reuseIdentifier = "ImageCell"
	private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
	
	private var searches = [SearchResults]()
	
	func photoForIndexPath(indexPath: NSIndexPath) -> UIImage {
		return searches[indexPath.section].searchResults[indexPath.row]
	}
	
	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	
	@IBOutlet weak var imageView: UIImageView!
	
	@IBAction func capturePhoto(sender: AnyObject) {
		let vc = KrumbsSDK.sharedInstance().startKCaptureViewController()
		vc.delegate = self
		
		self.presentViewController(vc, animated: true, completion: nil)
	}
	
	func captureController(captureController: KCaptureViewController!, didFinishPickingMediaWithInfo media: [String : AnyObject]!) {
	
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
		
		self.tagAndStoreImage(mediaJsonUrl, image: (media[KCaptureControllerImageUrl] as! UIImage))
	}
	
	private func tagAndStoreImage(mediaJsonUrl: NSURL, image: UIImage) {
		// show progress hud
		hud.show(true)
		
		// Instantiate realm object for persistent local storage
		//var lifeImage = LifeImage(mediaJsonUrl, image)

		// Instantiate tagging api for json fetching and parsing
		let taggingApi = TaggingAPI()
		
		// request mediaJson object
		dispatch_async(dispatch_get_main_queue()) {
			
			// remove progress hud
			//hud.hide(true)
		}
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

extension GalleryViewController {
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return searches.count
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return searches[section].searchResults.count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GalleryImageCell
		
		let photo = photoForIndexPath(indexPath)
		cell.backgroundColor = UIColor.blackColor()
		
		cell.imageView.image = photo
		
		return cell
	}
}

extension GalleryViewController: UITextFieldDelegate {
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		
		let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
		textField.addSubview(activityIndicator)
		activityIndicator.frame = textField.bounds
		activityIndicator.startAnimating()
		let searcher = ImageSearcher()
		let results = searcher.searchLifeIndexForImage(textField.text!)
		activityIndicator.removeFromSuperview()
		
		print("Found \(results.searchResults.count) matching \(results.searchQuery)")
		self.searches.insert(results, atIndex: 0)
		
		self.collectionView?.reloadData()
	
		textField.text = nil
		textField.resignFirstResponder()
		return true
	}
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
			
		/*	let flickrPhoto =  photoForIndexPath(indexPath)
			//2
			if var size = flickrPhoto.thumbnail?.size {
				size.width += 10
				size.height += 10
				return size
			} */
			return CGSize(width: 100, height: 100)
	}
	
	func collectionView(collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAtIndex section: Int) -> UIEdgeInsets {
			return sectionInsets
	}
}
