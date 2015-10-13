//
//  BBMPhotosViewController.h
//  BBMImageViewPickerControoer
//
//  Created by BBM on 15/10/7.
//  Copyright (c) 2015年 BBM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBMPhotosViewController;
@protocol BBMPhotosViewControllerDelegate <NSObject>

@optional
- (void)bbmPhotosViewController:(BBMPhotosViewController *)bbmPhotosViewController didSelectedAssetArray:(NSArray *)assetArray;

@end

@interface BBMPhotosViewController : UIViewController

@property(nonatomic,weak)id<BBMPhotosViewControllerDelegate> delegate;

-(void)setPhotoModelArray:(NSArray *)photoModelArray selectedAssetArray:(NSMutableArray *)selectedAssetArray maxSelectedNumber:(NSInteger)maxSelectedNumber;

@end
