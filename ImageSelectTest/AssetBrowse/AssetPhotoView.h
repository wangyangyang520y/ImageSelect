//
//  PhotoView.h
//  MMP.iPad.RMYY
//
//  Created by wangyangyang on 14/10/8.
//  Copyright (c) 2014年 ZengJianYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@class PhotoView;
@class BrowsePhoto;

@interface AssetPhotoView : UIScrollView

@property(nonatomic,strong)BrowsePhoto *photo;
@property(nonatomic,assign) CGRect imageOriginFrame;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong) void(^tapGestureCallBackBlock)();

@end


@interface BrowsePhoto : NSObject

@property (nonatomic, strong)  ALAsset *asset;
@property (nonatomic, assign) BOOL isSelected; // 是否选中

@end