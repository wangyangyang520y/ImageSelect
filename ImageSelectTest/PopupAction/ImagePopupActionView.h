//
//  ImagePopupActionView.h
//  ImageSelectTest
//
//  Created by 王洋洋 on 15/10/8.
//  Copyright © 2015年 王洋洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@class ImagePopupActionView;

@protocol ImagePopupActionViewDelegate <NSObject>

-(void)imagePopupActionView:(ImagePopupActionView *)actionView tokePhotoAsset:(ALAsset *)asset;

-(void)imagePopupActionView:(ImagePopupActionView *)actionView selectedAsset:(NSArray *)assetArray;

@end

@interface ImagePopupActionView : UIView

@property(nonatomic,assign) id<ImagePopupActionViewDelegate> delegate;
@property(nonatomic,assign) NSInteger maxSelectedNumber;
@property(nonatomic,assign) BOOL isDispalySelectedItem;

-(instancetype)initWithFrame:(CGRect)frame withViewController:(UIViewController *)viewController previewImage:(BOOL)isPreviewImage;


- (void)setImages:(NSArray *)images;

-(void)deleteSelectedAsset:(NSInteger )index;

-(void)showWithCompletion:(void(^)())completion;

-(void)dismissWithCompletion:(void(^)())completion;

@end



@interface PhtotObj : NSObject

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UIButton *btnCheck;

@property(nonatomic,strong) UIView *viewCover;

@property(nonatomic,strong) ALAsset *asset;

-(void)showCover;
-(void)dismissCover;

@end