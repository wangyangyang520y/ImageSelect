//
//  BBMAlbumBrowseViewController.h
//  ImageSelectTest
//
//  Created by 王洋洋 on 15/10/10.
//  Copyright © 2015年 王洋洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBMAlbumBrowseViewControllerDelegate <NSObject>

-(void)browseViewControllerSelectedImage:(NSArray *)imageArray;

@end

@interface BBMAlbumBrowseViewController : UIViewController

@property(nonatomic,assign)NSInteger maxSelectedNumber;
@property(nonatomic,weak) id<BBMAlbumBrowseViewControllerDelegate>delegate;

-(void)setAssetArray:(NSArray *)photoArray currentIndex:(NSInteger)currentIndex maxSelectedNumber:(NSInteger)maxSelectedNumber;

@end
