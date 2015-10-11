//
//  PhotoView.m
//  MMP.iPad.RMYY
//
//  Created by wangyangyang on 14/10/8.
//  Copyright (c) 2014年 ZengJianYuan. All rights reserved.
//

#import "PhotoView.h"

#define start @"start"
#define running @"running"
#define suc @"success"
#define fail @"failure"


@interface PhotoView ()


@end

@implementation PhotoView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:doubleTap];
        
        [tap requireGestureRecognizerToFail:doubleTap];
        
        self.imageView = [[UIImageView alloc]init];
        [self addSubview:self.imageView];
        
        self.maximumZoomScale = 2.0;
        self.minimumZoomScale = 1.0;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

-(void)setPhoto:(Photo *)photo
{
    _photo = photo;
    [self showPhoto];
}

-(void)showPhoto
{
    self.imageView.image = [UIImage imageWithCGImage:[self.photo.asset aspectRatioThumbnail]];
    self.imageView.backgroundColor = [UIColor redColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    
    CGSize boundsSize = self.bounds.size;
    
    CGRect imageFrame = [self getImageRect:self.imageView.image inSize:boundsSize];
    self.imageOriginFrame = imageFrame;
    self.imageView.frame = imageFrame;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithCGImage:[self.photo.asset.defaultRepresentation fullScreenImage]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    });
}

-(void)tap:(UITapGestureRecognizer *)gesture
{
    if (self.tapGestureCallBackBlock) {
        self.tapGestureCallBackBlock();
    }
}

-(void)doubleTap:(UITapGestureRecognizer *)gesture
{
    CGPoint pt = [gesture locationInView:self];
    pt.y = pt.y+self.contentOffset.y;
    pt.x = pt.x+self.contentOffset.x;
    NSLog(@"selfframe:%@",NSStringFromCGRect(self.frame));
    NSLog(@"imageRect:%@",NSStringFromCGRect(self.imageView.frame));
    if(self.zoomScale>1.2){
        CGRect zoomRect = [self zoomRectForScale:1.0 withCenter:pt];
        NSLog(@"zoomRect:%@",NSStringFromCGRect(zoomRect));
        [self zoomToRect:zoomRect animated:YES];
    }else{
        CGRect zoomRect = [self zoomRectForScale:2.0 withCenter:pt];
        NSLog(@"zoomRect:%@",NSStringFromCGRect(zoomRect));
        [self zoomToRect:zoomRect animated:YES];
    }
}


-(CGRect)getImageRect:(UIImage *)image inSize:(CGSize)size
{
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageInitSize = image.size;
    CGFloat imageInitWidth = imageInitSize.width;
    CGFloat imageInitHeight = imageInitSize.height;
    
    CGFloat realWidth = size.width;
    CGFloat realHeight = size.height;
    
    CGRect imageFrame;
    
    if(imageInitWidth/imageInitHeight>realWidth/realHeight){
        imageFrame = CGRectMake((boundsWidth-realWidth)/2.0, (boundsHeight-realHeight)/2.0+(realHeight-realWidth/imageInitWidth*imageInitHeight)/2.0, realWidth, realWidth/imageInitWidth*imageInitHeight);
    }else{
        imageFrame = CGRectMake((boundsWidth-realWidth)/2.0+(realWidth-realHeight/imageInitHeight*imageInitWidth)/2.0, (boundsHeight-realHeight)/2.0, realHeight/imageInitHeight*imageInitWidth, realHeight);
    }
    
    return imageFrame;
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    NSLog(@"clickPt:%@",NSStringFromCGPoint(center));
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    //    zoomRect.origin.x=center.x;
    //    zoomRect.origin.y=center.y;
//    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    zoomRect.origin.y    = (self.contentOffset.y+self.frame.size.height)/2.0- (zoomRect.size.height / 2.0);

//    zoomRect.origin.y = self.frame.size.height/2.0;
    
    return zoomRect;
}

@end




@implementation Photo

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.isSelected = NO;
    }
    return self;
}

@end

