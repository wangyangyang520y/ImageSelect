//
//  BBMAlbumViewController.h
//  BBMImageViewPickerControoer
//
//  Created by BBM on 15/10/7.
//  Copyright (c) 2015年 BBM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBMPhotosViewController.h"
@class BBMAlbumViewController;


@protocol BBMAlbumViewControllerDelegate <NSObject>

@optional
- (void)bbmAlbumViewController:(BBMAlbumViewController *)bbmAlbumViewController didSeletedAssetArrary:(NSArray *)assetArrary;

@end

@interface BBMAlbumViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, BBMPhotosViewControllerDelegate>

@property(nonatomic, weak)id<BBMAlbumViewControllerDelegate> delegate;

-(void)setAssetArray:(NSArray *)assetArray selectedAssetArray:(NSMutableArray *)selectedAssetArray maxSelectedNumber:(NSInteger)maxSelectedNumber;

@end