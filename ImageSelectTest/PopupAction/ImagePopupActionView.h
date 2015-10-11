//
//  ImagePopupActionView.h
//  ImageSelectTest
//
//  Created by 王洋洋 on 15/10/8.
//  Copyright © 2015年 王洋洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol ImagePopupActionViewDelegate <NSObject>

-(void)imagePopupActionViewTokePhoto:(UIImage *)image;

-(void)selectedImage:(NSArray *)imageArray;

@end

@interface ImagePopupActionView : UIView

@property(nonatomic,assign) id<ImagePopupActionViewDelegate> delegate;
@property(nonatomic,assign) NSInteger maxSelectedNumber;

-(instancetype)initWithFrame:(CGRect)frame withViewController:(UIViewController *)viewController;

- (void)setImages:(NSArray *)images;

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