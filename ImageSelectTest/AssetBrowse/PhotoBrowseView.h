//
//  PhotoBrowseController.h
//  MMP.iPad.RMYY
//
//  Created by wangyangyang on 14/10/8.
//  Copyright (c) 2014年 ZengJianYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoView.h"

#define photoPadding 10

typedef enum {
    INIT,
    FORWARD,
    FORBACK
} Direct;


@interface PhotoBrowseView :UIView <UIScrollViewDelegate>

@property(nonatomic,strong) void(^scrollToImageCallBackBlock)(NSInteger index);

-(void)setPhotoArray:(NSArray *)photoArray currentPhotoIndex:(NSInteger)currentPhotoIndex tapGesture:( void(^)())tapGestureCallBackBlock;

@end
