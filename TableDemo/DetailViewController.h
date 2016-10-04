//
//  DetailViewController.h
//  TableDemo
//
//  Created by Ammar on 04/10/2016.
//  Copyright (c) 2016 ammar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property(nonatomic,retain) NSURL *url;
@property (weak, nonatomic) IBOutlet UIImageView *imgview;

@end
