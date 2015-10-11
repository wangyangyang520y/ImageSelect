//
//  BBMPhotoModel.h
//  BBMImageViewPickerControoer
//
//  Created by BBM on 15/10/8.
//  Copyright (c) 2015年 BBM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface BBMPhotoModel : NSObject
@property(nonatomic, assign)BOOL isSelected;
@property(nonatomic, assign)BOOL isCover;
@property(nonatomic,strong)  ALAsset*asset;
@end
