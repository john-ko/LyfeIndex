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
import RealmSwift

class GalleryViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextFieldDelegate, KCaptureViewControllerDelegate, UINavigationBarDelegate {
	
	var collectionView: UICollectionView!
	private let reuseIdentifier = "ImageCell"
	private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
	var hud: MBProgressHUD = MBProgressHUD()
	
	private var searches = [SearchResults]()
	
	func photoForIndexPath(indexPath: NSIndexPath) -> UIImage {
		return searches[indexPath.section].searchResults[indexPath.row]
	}
	
	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	
	func capturePhoto(sender: AnyObject) {
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
		
		self.tagAndStoreImage(mediaJsonUrl.absoluteString, image: (media[KCaptureControllerImageUrl] as! UIImage))
	}

	private var imageId: String = ""
	private func tagAndStoreImage(mediaJsonUrl: String, image: UIImage) {
		// show progress hud
		self.imageId = mediaJsonUrl
		
		// Store life image in database
		let lifeImage = LifeImage()
		lifeImage.largeImage = UIImagePNGRepresentation(image)
		lifeImage.imageId = mediaJsonUrl
		
		let realm = try! Realm()
		try! realm.write {
			realm.add(lifeImage)
		}

		// Instantiate tagging api for json fetching and parsing
		//dispatch_async(dispatch_get_main_queue()) {
		let taggingAPI = TaggingAPI()
		taggingAPI.postImage(image, callback: self.storeTags)
		//}
		// remove progress hud
	}
	
	func storeTags(tags: [String]) -> Void {
		print("TAGS ARE BEING STORED")
		var tagObjs: [InvertedIndex] = []
		for i in 0..<tags.count {
			let tagObject = InvertedIndex()
			let strObj = Strings()
			strObj.name = self.imageId
			tagObject.tagId = tags[i]
			tagObject.imageIds.append(strObj)
			tagObjs.append(tagObject)
		}
		let realm = try! Realm()
		try! realm.write {
			realm.add(tagObjs)
		}
	}
	
	func captureControllerDidCancel(captureController: KCaptureViewController!) {
		NSLog("User Canceled Capture!")
	}
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return searches.count
		//return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return searches[section].searchResults.count
		//return 10
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! GalleryImageCell
		
		let photo = photoForIndexPath(indexPath)
		cell.backgroundColor = UIColor.blackColor()
		
		cell.imageView.image = photo
		
//		cell.imageView.image = UIImage(named: "star")
		return cell
		
	}
	
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
	
	func collectionView(collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
			
		return CGSize(width: 100, height: 100)
	}
	
	func collectionView(collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAtIndex section: Int) -> UIEdgeInsets {
			return sectionInsets
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Create the collection view
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
		layout.itemSize = CGSize(width: 90, height: 120)
		
		collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.registerClass(GalleryImageCell.self, forCellWithReuseIdentifier: "Cell")
		collectionView.backgroundColor = UIColor.whiteColor()
		self.view.addSubview(collectionView)
		
		// Create the navigation bar
		let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 64)) // Offset by 20 pixels vertically to take the status bar into account
		
		navigationBar.backgroundColor = UIColor.whiteColor()
		navigationBar.delegate = self
		
		// Create a navigation item with a title
		let navigationItem = UINavigationItem()
		
		// Create search bar
		let textField = UITextField(frame: CGRectMake(0, 0, navigationBar.frame.size.width, 21.0))
		textField.placeholder = "Search"
		textField.returnKeyType = UIReturnKeyType.Search
		textField.delegate = self
		navigationItem.titleView = textField
		
		// Create left and right button for navigation item
		//let leftButton =  UIBarButtonItem(title: "Save", style:   UIBarButtonItemStyle.Plain, target: self, action: "btn_clicked:")
		let rightButton = UIBarButtonItem(title: "Capture", style: UIBarButtonItemStyle.Plain, target: self, action: "capturePhoto:")
		
		// Create two buttons for the navigation item
		//navigationItem.leftBarButtonItem = leftButton
		navigationItem.rightBarButtonItem = rightButton
		
		// Assign the navigation item to the navigation bar
		navigationBar.items = [navigationItem]
		
		// Make the navigation bar a subview of the current view controller
		self.view.addSubview(navigationBar)
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
