//
//  DetailViewController.h
//  TableDemo
//
//  Created by Ammar Mujeeb on 10/5/16.
//  Copyright © 2016 ammar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <NSURLConnectionDataDelegate>

@property (nonatomic) NSMutableData *imageData;
@property (nonatomic) NSUInteger totalBytes;
@property (nonatomic) NSUInteger receivedBytes;
@property(nonatomic,retain) NSURL *imgurl;
@property(nonatomic,retain) IBOutlet UIImageView *imgv;

@end
