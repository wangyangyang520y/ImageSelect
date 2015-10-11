//
//  BBMAssetAlbum.m
//  BBMImageViewPickerControoer
//
//  Created by BBM on 15/10/7.
//  Copyright (c) 2015年 BBM. All rights reserved.
//

#import "BBMAlbumAssetTool.h"


@implementation BBMAlbumAssetTool

+(ALAssetsLibrary *)getShareInstance
{
    [ALAssetsLibrary disableSharedPhotoStreamsSupport];
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,
                  ^{
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}

+(void)getAllAlbumComplete:(void(^)(NSArray *albumArray,NSArray *groupArray))completion albumAuthorizationFail:(void(^)())authorizationFail
{
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        authorizationFail();
        return;
    }else{
        ALAssetsLibrary *assetsLibrary = [self getShareInstance];
        NSMutableArray *tempAlbumArray = [[NSMutableArray alloc] init];
        NSMutableArray *tempGroupArray = [[NSMutableArray alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                if (group.numberOfAssets > 0) {
                    [tempGroupArray addObject:group];
                    
                    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
                    [tempDic setObject:[UIImage imageWithCGImage:[group posterImage]] forKey:BBMAssetAlbumPosterImage];
                    [tempDic setObject:[group valueForProperty:ALAssetsGroupPropertyName] forKey:BBMAssetAlbumGroupName];
                    [tempDic setObject:@(group.numberOfAssets) forKey:BBMAssetAlbumPhotosCount];
                    [tempAlbumArray addObject:tempDic];
                }
            }else{
                completion(tempAlbumArray,tempGroupArray);
            }
        } failureBlock:^(NSError *error) {
        }];

    }
    
}

+(void)getAssetsByAlbum:(ALAssetsGroup *)group completion:(void(^)(NSMutableArray *assetArray))completion
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            UIImage *contentImage = [UIImage imageWithCGImage:[[result defaultRepresentation] fullScreenImage]];
            [tempArray addObject:contentImage];
        } else {
            completion(tempArray);
        }
    }];
}


+(void)getAllAlbumAndAssetsComplete:(void(^)(NSArray *dataArray))completion albumAuthorizationFail:(void(^)())authorizationFail
{
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        authorizationFail();
        return;
    }else{
        
        ALAssetsLibrary *assetsLibrary = [self getShareInstance];
        
        NSMutableArray *tempAlbumAndAssetArray = [[NSMutableArray alloc] init];
        NSMutableArray *tempGroupArray = [[NSMutableArray alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                if (group.numberOfAssets > 0) {
                    [tempGroupArray addObject:group];
                }
            }else{
                for (ALAssetsGroup *group in tempGroupArray) {
                    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                        if (result) {
                            [tempArray addObject:result];
                        } else {
                            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
                            [tempDic setObject:[UIImage imageWithCGImage:[group posterImage]] forKey:BBMAssetAlbumPosterImage];
                            [tempDic setObject:[group valueForProperty:ALAssetsGroupPropertyName] forKey:BBMAssetAlbumGroupName];
                            [tempDic setObject:@(group.numberOfAssets) forKey:BBMAssetAlbumPhotosCount];
                            [tempDic setObject:tempArray forKey:BBMAssetAlbumPhotosArr];
                            [tempAlbumAndAssetArray addObject:tempDic];
                        }
                    }];
                }
                NSComparator finderSort = ^(NSDictionary *dic1,NSDictionary *dic2){
                    
                    if ([dic1[BBMAssetAlbumPhotosCount] integerValue]> [dic2[BBMAssetAlbumPhotosCount] integerValue]) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }else if ([dic1[BBMAssetAlbumPhotosCount] integerValue]< [dic2[BBMAssetAlbumPhotosCount] integerValue]){
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    else
                        return (NSComparisonResult)NSOrderedSame;
                };
                completion([tempAlbumAndAssetArray sortedArrayUsingComparator:finderSort]);
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }
}

@end