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
- (void)bbmPhotosViewController:(BBMPhotosViewController *)bbmPhotosViewController didSeletedDataArr:(NSArray *)dataArr;

@end

@interface BBMPhotosViewController : UIViewController
@property(nonatomic,assign) NSInteger  maxSelectedNumber;
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,weak)id<BBMPhotosViewControllerDelegate> delegate;
@end
