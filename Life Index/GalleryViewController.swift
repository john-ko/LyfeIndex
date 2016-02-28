//
//  GalleryViewController.swift
//  Life Index
//
//  Created by Atomisk on 2/27/16.
//  Copyright © 2016 CS125. All rights reserved.
//

import UIKit
import KrumbsSDK

class GalleryViewController: UIViewController, KCaptureViewControllerDelegate {
	
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
