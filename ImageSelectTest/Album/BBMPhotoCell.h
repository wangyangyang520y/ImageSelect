//
//  BBMPhotoCell.h
//  BBMImageViewPickerControoer
//
//  Created by BBM on 15/10/7.
//  Copyright (c) 2015年 BBM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBMPhotoModel.h"
@class BBMPhotoCell;

@protocol BBMPhotoCellDelegate <NSObject>

@optional
- (void)bbmPhotoCell:(BBMPhotoCell *)bbmPhotoCell didSeletedAsset:(ALAsset *)seletedAsset;
- (void)bbmPhotoCell:(BBMPhotoCell *)bbmPhotoCell didDeseletedAsset:(ALAsset *)deseletedAsset;
@end

@interface BBMPhotoCell : UICollectionViewCell
@property(nonatomic, strong)BBMPhotoModel *photoModel;
@property(nonatomic, strong)UIView *coverView;
@property(nonatomic, weak)id<BBMPhotoCellDelegate> delegate;
@end
