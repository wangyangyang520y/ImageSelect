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
@class Photo;

@interface PhotoView : UIScrollView

@property(nonatomic,strong)Photo *photo;
@property(nonatomic,assign) CGRect imageOriginFrame;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong) void(^tapGestureCallBackBlock)();

@end


@interface Photo : NSObject

@property (nonatomic, strong)  ALAsset *asset;
@property (nonatomic, assign) BOOL isSelected; // 是否选中

@end