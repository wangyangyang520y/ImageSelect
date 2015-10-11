//
//  BBMPhotoCell.m
//  BBMImageViewPickerControoer
//
//  Created by BBM on 15/10/7.
//  Copyright (c) 2015年 BBM. All rights reserved.
//

#import "BBMPhotoCell.h"

@interface BBMPhotoCell ()
@property(nonatomic, strong)UIImageView *contentImageView;
@property(nonatomic, strong)UIButton *btn;
@property(nonatomic, strong)UIImageView *confirmImageView;


@end

@implementation BBMPhotoCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.contentImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.contentImageView];
        
        self.btn = [[UIButton alloc] init];
        [self.btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        [self.btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn];
        
        self.coverView = [[UIView alloc] init];
        [self.contentView addSubview:self.coverView];
        self.coverView.backgroundColor = [UIColor whiteColor];
        self.coverView.alpha = 0.6;
        self.coverView.hidden = YES;
        
    }
    return self;
}

- (void)btnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
//        [self confirmAnimationWithConfirmBtn:btn];
        if (self.delegate && [self.delegate respondsToSelector:@selector(bbmPhotoCell:didSeletedAsset:)]) {
            [self.delegate bbmPhotoCell:self didSeletedAsset:self.photoModel.asset];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(bbmPhotoCell:didDeseletedAsset:)]) {
            [self.delegate bbmPhotoCell:self didDeseletedAsset:self.photoModel.asset];
        }

    }
}


//- (void)confirmAnimationWithConfirmBtn:(UIButton *)confirmBtn
//{
//    self.confirmImageView = [[UIImageView alloc] init];
//    self.confirmImageView.frame = [confirmBtn convertRect:confirmBtn.imageView.frame toView:self];
//    self.confirmImageView.image = [UIImage imageNamed:@"checked"];
//    [self addSubview:self.confirmImageView];
//    
//    CAKeyframeAnimation *keyAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    keyAni.values = @[@(1),@(1.3),@(1)];
//    keyAni.duration = 0.3;
//    keyAni.calculationMode = kCAAnimationLinear;
//    keyAni.delegate = self;
//    [self.confirmImageView.layer addAnimation:keyAni forKey:nil];
//}
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    [self.confirmImageView removeFromSuperview];
//}

- (void)setPhotoModel:(BBMPhotoModel *)photoModel
{
    _photoModel = photoModel;
    
    self.contentImageView.image = [UIImage imageWithCGImage:[photoModel.asset aspectRatioThumbnail]];
    
    if (photoModel.isSelected) {
        self.btn.selected = YES;
    }else{
        self.btn.selected = NO;
    }
    
    self.coverView.hidden = !photoModel.isCover;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.btn.frame = CGRectMake(self.frame.size.width - 25, 0, 25, 25);
    self.coverView.frame = self.bounds;
}

@end
