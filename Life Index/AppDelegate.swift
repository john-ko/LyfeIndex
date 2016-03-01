//
//  AppDelegate.swift
//  Life Index
//
//  Created by Atomisk on 2/27/16.
//  Copyright © 2016 CS125. All rights reserved.
//

import UIKit
import KrumbsSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		let appId: String = "oDsiH5alwnprZuX0ylRj2vMw8HKLZ2ACvPTFAGzL"
		let clientKey: String = "DAD7jslsbeMdHrs7LSX6gkvPpg5G7WTwFU955lo4"
		let myEmail: String = "rrvega@uci.edu"
		let myFN: String = "Ronnyv"
		let mySN: String = "Public"
		
		// Initialize Krumbs API
		let sharedInstance = KrumbsSDK.initWithApplicationID(appId, andClientKey: clientKey) as! KrumbsSDK
		
		// Register your user (if you don't have anonymous access)
		sharedInstance.registerUserWithEmail(myEmail, firstName: myFN, lastName: mySN)
		
		// Register the Intent Category model with JSON files in a NSBundle, and XC AssetBundle with emoji images
		// The AssetBundle can be generated from the SDK tool 'asset-generator'
		let jsonBundle = NSBundle(path: NSBundle.mainBundle().pathForResource("IntentResourcesExample", ofType: "bundle")!)
		sharedInstance.registerIntentCategories(jsonBundle, withAssetResourceName: "IntentAssetsExample")
		
		// Configure the color scheme of the IntentPanel
		let uiConfig = sharedInstance.getIntentPanelViewConfigurationDefaults() as KIntentPanelConfiguration
		uiConfig.intentPanelBarColor = UIColor(colorLiteralRed: 0.008, green: 0.620, blue: 0.882, alpha: 1.00)
		uiConfig.intentPanelBarTextColor = UIColor.yellowColor()
		sharedInstance.setIntentPanelViewConfigurationDefaults(uiConfig)
		
		self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
		let rootView: GalleryViewController = GalleryViewController()
		self.window?.rootViewController = rootView
		self.window?.makeKeyAndVisible()
		
		return true
	}
	
	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}
	
	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}
	
	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}
	
	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}
	
	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		KrumbsSDK.shutdown()
	}
}
