//
//  KCapturePageViewController.h
//  KrumbsSDK
//
//  Created by Asquith Bailey on 2/12/16.
//  Copyright © 2016 Krumbs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCaptureViewController.h"


@interface KCapturePageViewController : UIViewController

@property (nonatomic, weak) NSObject<KCaptureViewControllerDelegate> * delegate;

@end
