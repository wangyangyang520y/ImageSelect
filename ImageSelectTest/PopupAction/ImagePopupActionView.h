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

//-(void)imagePopupActionView:(ImagePopupActionView *)actionView tokePhotoAsset:(ALAsset *)asset;

-(void)imagePopupActionView:(ImagePopupActionView *)actionView selectedAsset:(NSArray *)assetArray;

@end

@interface ImagePopupActionView : UIView

@property(nonatomic,assign) NSInteger maxSelectedNumber;  //最大可选择的数量（<=0表示可以无限选）
@property(nonatomic,assign) BOOL isDispalySelectedItem;   //是否选中上次选中过程中选中的项

@property(nonatomic,assign) id<ImagePopupActionViewDelegate> delegate;

/**
 *  初始化方法
 *
 *  @param frame
 *  @param viewController 来自哪个vc
 *  @param isPreviewImage 是否显示预览图片部分
 *
 *  @return
 */
-(instancetype)initWithFrame:(CGRect)frame withViewController:(UIViewController *)viewController previewImage:(BOOL)isPreviewImage;

/**
 *  显示
 *
 *  @param completion 显示完成回调
 */
-(void)showWithCompletion:(void(^)())completion;

/**
 *  隐藏
 *
 *  @param completion 隐藏完成回调
 */
-(void)dismissWithCompletion:(void(^)())completion;

/**
 *  通过其他方式删除图片的时候调用此方法同步选中的数据
 *
 *  @param asset
 */
-(void)deleteSelectedAsset:(ALAsset *)asset;

/**
 *  恢复到初始化状态
 */
-(void)recoverToInitState;

@end



@interface PhtotObj : NSObject

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UIButton *btnCheck;

@property(nonatomic,strong) UIView *viewCover;

@property(nonatomic,strong) ALAsset *asset;

-(void)showCover;
-(void)dismissCover;

@end