//
//  PhotoBrowseController.m
//  MMP.iPad.RMYY
//
//  Created by wangyangyang on 14/10/8.
//  Copyright (c) 2014年 ZengJianYuan. All rights reserved.
//

#import "PhotoBrowseView.h"

@interface PhotoBrowseView ()
{
    CGRect screenFrame;
    float prePosition;
    Direct scrollDirect;
    
    NSInteger initPhotoIndex;
}

@property(nonatomic,assign)NSInteger currentPhotoIndex;
@property(nonatomic,strong)NSArray *photoArray;

@property(nonatomic,strong)UIScrollView *photoScrollView;

@property(nonatomic,strong)NSMutableArray *visiblePhotoViews;

@property(nonatomic,strong)PhotoView *reusePhotoView;
@property(nonatomic,strong)PhotoView *currentPhotoView;

@property(nonatomic,strong) void(^tapGestureCallBackBlock)();

@end

@implementation PhotoBrowseView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        screenFrame = frame;
        screenFrame.origin.x -= photoPadding;
        screenFrame.size.width += (2 * photoPadding);
        [self createScrollView];
        scrollDirect = INIT;
        self.visiblePhotoViews = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)createScrollView
{
    self.photoScrollView = [[UIScrollView alloc]initWithFrame:screenFrame];
    self.photoScrollView.pagingEnabled = YES;
    self.photoScrollView.backgroundColor = [UIColor clearColor];
    self.photoScrollView.showsVerticalScrollIndicator = NO;
    self.photoScrollView.showsHorizontalScrollIndicator = NO;
    self.photoScrollView.delegate = self;
    [self addSubview:self.photoScrollView];
    
}


-(void)setPhotoArray:(NSArray *)photoArray currentPhotoIndex:(NSInteger)currentPhotoIndex tapGesture:( void(^)())tapGestureCallBackBlock
{
    _photoArray = photoArray;
    self.photoScrollView.contentSize = CGSizeMake(self.photoArray.count*screenFrame.size.width, screenFrame.size.height);
    
    _currentPhotoIndex = currentPhotoIndex;
    initPhotoIndex = currentPhotoIndex;
    self.photoScrollView.contentOffset = CGPointMake(self.currentPhotoIndex*screenFrame.size.width, 0);
    
    
    self.tapGestureCallBackBlock = tapGestureCallBackBlock;
    [self showPhotoView];
}

-(void)showPhotoView
{
    scrollDirect = INIT;
    if (self.photoArray.count==1) {
        [self showPhotoViewAtIndex:self.currentPhotoIndex];
        return;
    }
    [self showPhotoViewAtIndex:self.currentPhotoIndex-1];
    [self showPhotoViewAtIndex:self.currentPhotoIndex];
    [self showPhotoViewAtIndex:self.currentPhotoIndex+1];
    
    self.currentPhotoView = self.visiblePhotoViews[1];
}

//新加photoView调用的方法
-(void)showPhotoViewAtIndex:(NSInteger)index
{
    CGRect photoViewFrame = CGRectMake(index*screenFrame.size.width+photoPadding, 0, screenFrame.size.width-2*photoPadding, screenFrame.size.height);
    PhotoView *photoView = [[PhotoView alloc]initWithFrame:photoViewFrame];
    photoView.delegate = self;
    photoView.tapGestureCallBackBlock = self.tapGestureCallBackBlock;
    [self.photoScrollView addSubview:photoView];
    if (index<self.photoArray.count&&index>=0) {
        Photo *photo = self.photoArray[index];
        [photoView setPhoto:photo];
    }
    
    
    
    [self.visiblePhotoViews addObject:photoView];

    if (scrollDirect == FORBACK) {
        [self resortArray:self.visiblePhotoViews];
    }
    
}

//复用photoView调用的方法，复用时只改变photoView的位置和内容
-(void)showReusePhotoViewAtIndex:(NSInteger)index
{

    
    CGRect photoViewFrame = CGRectMake(index*screenFrame.size.width+photoPadding, 0, screenFrame.size.width-2*photoPadding, screenFrame.size.height);
    //在两头的时候不需要复用photoView
    if (index<self.photoArray.count&&index>=0) {
        Photo *photo = self.photoArray[index];
        self.reusePhotoView.frame = photoViewFrame;
        [self.reusePhotoView setPhoto:photo];
    }
    
    [self.visiblePhotoViews addObject:self.reusePhotoView];
    if (scrollDirect == FORBACK) {
        [self resortArray:self.visiblePhotoViews];
    }
    //记住当前的view是那个
    if (index<self.photoArray.count&&index>=0) {
        self.currentPhotoView = self.visiblePhotoViews[1];
    }else if (index<0) {
        self.currentPhotoView = self.visiblePhotoViews[0];
    }else{
        self.currentPhotoView = self.visiblePhotoViews[1];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:self.photoScrollView]) {
        return;
    }
    
    NSInteger count = self.photoArray.count;
    
    
    CGRect visibleBounds = scrollView.bounds;
    //index drag后将要显示的图片的索引
    NSInteger index;
    //判断滚动方向，给index赋不同的值
    if (scrollView.contentOffset.x>prePosition) {//向右边滚动
        
        index=ceilf(CGRectGetMinX(visibleBounds)/CGRectGetWidth(visibleBounds));
    }else{
        
        index=floorf(CGRectGetMinX(visibleBounds)/CGRectGetWidth(visibleBounds));
    }
    prePosition = scrollView.contentOffset.x;
    
    NSInteger needChangeIndex = 0;
    
    if (count<3) {
        _currentPhotoIndex = index;
        return;
    }
    
    if (index>=count) {
        index = count-1;
    }
    if (index<0) {
        index=0;
    }
    
    if (self.currentPhotoIndex == index) {
        return;
    }
    
    
    
    if (index>self.currentPhotoIndex) {
        self.reusePhotoView = self.visiblePhotoViews[0];
        [self.visiblePhotoViews removeObjectAtIndex:0];
        scrollDirect = FORWARD;
        _currentPhotoIndex = index;
        needChangeIndex = index + 1;
        [self showReusePhotoViewAtIndex:needChangeIndex];
        
        return;
    }
    if (index<self.currentPhotoIndex) {
        self.reusePhotoView = self.visiblePhotoViews[2];
        [self.visiblePhotoViews removeObjectAtIndex:2];
        scrollDirect = FORBACK;
        _currentPhotoIndex = index;
        needChangeIndex = index - 1;
        [self showReusePhotoViewAtIndex:needChangeIndex];
        
        return;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:self.photoScrollView]) {
        return;
    }
    
    if (self.scrollToImageCallBackBlock) {
        NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
        self.scrollToImageCallBackBlock(index);
    }

    if (self.photoArray.count<3) {
        return;
    }
    if (self.currentPhotoView) {
        Photo *photo = self.photoArray[self.currentPhotoIndex];
        [self.currentPhotoView setPhoto:photo];
    }
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[PhotoView class]]) {
        return ((PhotoView *)scrollView).imageView;
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[PhotoView class]]) {
        PhotoView *temp = (PhotoView *)scrollView;
        CGRect tempRect = temp.imageView.frame;
        
        float x;
        if (tempRect.size.width<temp.frame.size.width) {
            x = (temp.imageOriginFrame.size.width*temp.zoomScale-temp.imageOriginFrame.size.width)/2.0;
            if (x>=0) {
                tempRect.origin.x = temp.imageOriginFrame.origin.x - x;
            }
        }else{
            x = 0;
            tempRect.origin.x = x;
        }
        
        float y;
        if (tempRect.size.height<temp.frame.size.height) {
            y = (temp.imageOriginFrame.size.height*temp.zoomScale-temp.imageOriginFrame.size.height)/2.0;
            if (y>=0) {
                tempRect.origin.y = temp.imageOriginFrame.origin.y - y;
            }
        }else{
            y = 0;
            tempRect.origin.y = y;
        }
        
        temp.imageView.frame = tempRect;
    }
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{

}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{

}

-(void)resortArray:(NSMutableArray *)array
{

    id temp = array[array.count-1];
    [array removeObjectAtIndex:array.count-1];
    [array insertObject:temp atIndex:0];
}

@end
