//
//  BBMAssetAlbum.h
//  BBMImageViewPickerControoer
//
//  Created by BBM on 15/10/7.
//  Copyright (c) 2015年 BBM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

#define  BBMAssetAlbumPosterImage   @"BBMAssetAlbumPosterImage"
#define  BBMAssetAlbumGroupName     @"BBMAssetAlbumGroupName"
#define  BBMAssetAlbumPhotosArr     @"BBMAssetAlbumPhotosArr"
#define  BBMAssetAlbumPhotosCount   @"BBMAssetAlbumPhotosCount"

@interface BBMAlbumAssetTool : NSObject


/**
 *  获取所有相册
 *
 *  @param completion        获取成功回调
 *  @param authorizationFail 认证失败回调（系统设置相册不可用时的回调）
 */
+(void)getAllAlbumComplete:(void(^)(NSArray *albumArray,NSArray *groupArray))completion albumAuthorizationFail:(void(^)())authorizationFail;

/**
 *  获取对应相册里面的所有图片
 *
 *  @param group      相册
 *  @param completion 获取成功后回调
 */
+(void)getAssetsByAlbum:(ALAssetsGroup *)group completion:(void(^)(NSMutableArray *assetArray))completion;

/**
 *  获取所有的相册和对应相册的照片
 *
 *  @param completion        获取成功回调
 *  @param authorizationFail 认证失败回调（系统设置相册不可用时的回调）
 */
+(void)getAllAlbumAndAssetsComplete:(void(^)(NSArray *dataArray))completion albumAuthorizationFail:(void(^)())authorizationFail;

@end
