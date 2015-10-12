//
//  ImagePopupActionView.m
//  ImageSelectTest
//
//  Created by 王洋洋 on 15/10/8.
//  Copyright © 2015年 王洋洋. All rights reserved.
//

#import "ImagePopupActionView.h"
#import "BBMAlbumAssetTool.h"

#import "BBMAlbumNavigationController.h"
#import "BBMAlbumViewController.h"
#import "BBMPhotosViewController.h"
#import "BBMPhotoModel.h"


#define defaultImageHeight       150


#define defaultMaxShowImageNumber 50

typedef enum {
    BtnAlbumAction_openAlbum,
    BtnAlbumAction_sendImage
}BtnAlbumActionType;

@interface ImagePopupActionView()<BBMAlbumViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BtnAlbumActionType btnAlbumActionType;
}

@property(nonatomic,weak) UIWindow *window;
@property(nonatomic,strong) UIViewController *viewController;

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIButton *btnAlbum;
@property(nonatomic,strong) UIButton *btnTokePhoto;
@property(nonatomic,strong) UIButton *btnCancel;

@property(nonatomic,strong) NSLayoutConstraint *contentViewConstraintV;

@property(nonatomic,strong) NSMutableArray *photoObjArray;
@property(nonatomic,strong) NSMutableArray *selectedImageArray;

@property(nonatomic,strong) UIImagePickerController *picker;

@property(nonatomic,strong) NSArray *albumAndAssetArray;

@property(nonatomic,assign) BOOL isPreviewImage;

@end

static NSString *identity = @"collection_cell";

@implementation ImagePopupActionView

-(instancetype)initWithFrame:(CGRect)frame withViewController:(UIViewController *)viewController previewImage:(BOOL)isPreviewImage
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        self.viewController = viewController;
        self.isPreviewImage = isPreviewImage;
        btnAlbumActionType = BtnAlbumAction_openAlbum;
        self.window = [[UIApplication sharedApplication].windows lastObject];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGstureAction:)]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _picker = [[UIImagePickerController alloc] init];//初始化
            _picker.delegate = self;
            _picker.allowsEditing = NO;//设置可编辑
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [BBMAlbumAssetTool getAllAlbumAndAssetsComplete:^(NSArray *dataArray) {
                self.albumAndAssetArray = dataArray;
                if (self.isPreviewImage) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSArray *tempArray = ((NSDictionary *)self.albumAndAssetArray[0])[BBMAssetAlbumPhotosArr];
                        if (tempArray.count>defaultMaxShowImageNumber) {
                            [self setImages:[tempArray subarrayWithRange:NSMakeRange(tempArray.count-defaultMaxShowImageNumber, defaultMaxShowImageNumber)]];
                        }else{
                            [self setImages:tempArray];
                        }
                        
                    });
                }
            } albumAuthorizationFail:^{
                
            }];
        });
        
        [self setUpView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - 设置初始化view和约束

-(void)setUpView
{
    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    [self addSubview:self.contentView];
    
    if (self.isPreviewImage) {
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.scrollView];
    }
    
    self.btnAlbum = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnAlbum.translatesAutoresizingMaskIntoConstraints = NO;
    [self.btnAlbum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnAlbum setTitle:@"相册" forState:UIControlStateNormal];
    [self.btnAlbum setBackgroundColor:[UIColor whiteColor]];
    [self.btnAlbum addTarget:self action:@selector(btnAlbumAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnAlbum];
    
    self.btnTokePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnTokePhoto.translatesAutoresizingMaskIntoConstraints = NO;
    [self.btnTokePhoto setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnTokePhoto setTitle:@"拍照" forState:UIControlStateNormal];
    [self.btnTokePhoto setBackgroundColor:[UIColor whiteColor]];
    [self.btnTokePhoto addTarget:self action:@selector(btnTokePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnTokePhoto];
    
    self.btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCancel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [self.btnCancel addTarget:self action:@selector(btnCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCancel setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.btnCancel];
    
    [self setUpConstraint];
}

-(void)setUpConstraint
{
    self.contentViewConstraintV = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self addConstraint:self.contentViewConstraintV];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_btnAlbum]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_btnAlbum)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_btnTokePhoto]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_btnTokePhoto)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_btnCancel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_btnCancel)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentView)]];
    
    if(self.isPreviewImage){
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_scrollView]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_scrollView(==height)]-5-[_btnAlbum(==40)]-0.5-[_btnTokePhoto(==40)]-5-[_btnCancel(==40)]-0-|" options:0 metrics:@{@"height":@(defaultImageHeight+10)} views:NSDictionaryOfVariableBindings(_scrollView,_btnAlbum,_btnTokePhoto,_btnCancel)]];
    }else{
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_btnAlbum(==40)]-0.5-[_btnTokePhoto(==40)]-5-[_btnCancel(==40)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_btnAlbum,_btnTokePhoto,_btnCancel)]];
    }
}

#pragma mark - 设置初始化图片数组

- (void)setImages:(NSArray *)assetArray
{
    if (self.photoObjArray) {
        for (PhtotObj *photo in self.photoObjArray) {
            [photo.imageView removeFromSuperview];
            [photo.btnCheck removeFromSuperview];
        }
        [self.photoObjArray removeAllObjects];
    }else{
        self.photoObjArray = [[NSMutableArray alloc] init];
    }
    
    for (int i=0;i<assetArray.count;i++) {
        ALAsset *asset = assetArray[i];
        
        PhtotObj *photo = [[PhtotObj alloc] init];
        photo.asset = asset;
        photo.imageView.tag = i;
        photo.imageView.image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
        [photo.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)]];
        
        [photo.btnCheck addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        photo.btnCheck.tag = 100+i;
        
        [self.scrollView addSubview:photo.imageView];
        [photo.imageView addSubview:photo.btnCheck];
        
        [self.photoObjArray addObject:photo];
    }
    
    [self setUpScrollViewConstraint];
}


#pragma mark - scrollview控件约束布局
-(void)setUpScrollViewConstraint
{
    UIImageView *previousView = nil;
    
    for (int i=0; i<self.photoObjArray.count; i++) {
        PhtotObj *photo = self.photoObjArray[i];
        UIImageView *subview = photo.imageView;
        
        CGFloat aspectRatio = subview.intrinsicContentSize.width/subview.intrinsicContentSize.height;
        
        if (i==0) {
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[subview(==width)]" options:0 metrics:@{@"width":[NSNumber numberWithFloat:defaultImageHeight*aspectRatio]} views:NSDictionaryOfVariableBindings(subview)]];
        }else if(i==self.photoObjArray.count-1){
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousView]-5-[subview(==width)]-5-|" options:0 metrics:@{@"width":[NSNumber numberWithFloat:defaultImageHeight*aspectRatio]} views:NSDictionaryOfVariableBindings(previousView,subview)]];
        }else{
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousView]-5-[subview(==width)]" options:0 metrics:@{@"width":[NSNumber numberWithFloat:defaultImageHeight*aspectRatio]} views:NSDictionaryOfVariableBindings(previousView,subview)]];
        }
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[subview(height)]-5-|" options:0 metrics:@{@"height":@(defaultImageHeight)} views:NSDictionaryOfVariableBindings(subview)]];
        
        previousView = subview;
        
        
        UIButton *checkmarkView = photo.btnCheck;
        
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=5)-[checkmarkView(25)]-(>=5)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(checkmarkView)]];
        
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==5)-[checkmarkView(25)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(checkmarkView)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_contentView]-(<=-30@450)-[checkmarkView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentView,checkmarkView)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_contentView]-(>=-30@350)-[checkmarkView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentView,checkmarkView)]];
        
    }
    
}


#pragma mark - tap手势控件消失
-(void)tapGstureAction:(UITapGestureRecognizer *)gesture
{
    CGPoint pt = [gesture locationInView:self];
    if (!CGRectContainsPoint(self.contentView.frame, pt)) {
        [self dismissWithCompletion:^{
            
        }];
    }
}

#pragma mark - 图片tap回调
-(void)imageViewTapped:(UITapGestureRecognizer *)gesture
{
    [self selectedHandle:(UIImageView *)gesture.view];
}

#pragma mark - checkBtn按钮点击回调
-(void)checkBtnAction:(UIButton *)sender
{
    NSInteger tag = sender.tag-100;
    PhtotObj *photo = self.photoObjArray[tag];
    
    [self selectedHandle:photo.imageView];
}

-(void)selectedHandle:(UIImageView *)imageView
{
    if (!self.selectedImageArray) {
        self.selectedImageArray = [[NSMutableArray alloc] init];
    }
    
    NSInteger tag = imageView.tag;
    PhtotObj *photo = self.photoObjArray[tag];
    UIButton *btnCheck = photo.btnCheck;

    if (btnCheck.isSelected) {
        [self.selectedImageArray removeObject:photo];
        if (self.selectedImageArray.count == self.maxSelectedNumber-1) {
            for (PhtotObj *photo in self.photoObjArray) {
                [photo dismissCover];
            }
        }
        [btnCheck setSelected:NO];
    }else{
        [self.selectedImageArray addObject:photo];
        [btnCheck setSelected:YES];
        if (self.maxSelectedNumber>0 && self.selectedImageArray.count==self.maxSelectedNumber) {
            NSLog(@"图片选择总数超过最大可选数量%@",@(self.maxSelectedNumber));
            for (PhtotObj *photo in self.photoObjArray) {
                [photo showCover];
            }
        }
    }
    
    if (self.selectedImageArray.count>0) {
        [self.btnAlbum setTitle:[NSString stringWithFormat:@"发送（%@张）",@(self.selectedImageArray.count)] forState:UIControlStateNormal];
        [self.btnAlbum setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        btnAlbumActionType = BtnAlbumAction_sendImage;
    }else{
        [self.btnAlbum setTitle:@"相册" forState:UIControlStateNormal];
        [self.btnAlbum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnAlbumActionType = BtnAlbumAction_openAlbum;
    }
}

#pragma mark - 按钮点击回调

-(void)btnAlbumAction:(UIButton *)sender
{
    switch (btnAlbumActionType) {
        case BtnAlbumAction_openAlbum:
        {
            [self dismissWithCompletion:^{
                
            }];
            
            if (self.albumAndAssetArray && self.albumAndAssetArray.count>0) {
                [self showAlbumVc:self.albumAndAssetArray];
            }else{
                [BBMAlbumAssetTool getAllAlbumAndAssetsComplete:^(NSArray *dataArray) {
                    self.albumAndAssetArray = dataArray;
                    [self showAlbumVc:self.albumAndAssetArray];
                } albumAuthorizationFail:^{
                    
                }];
            }
        }
            break;
            
        case BtnAlbumAction_sendImage:
        {
            [self dismissWithCompletion:^{
                
            }];
            if ([self.delegate respondsToSelector:@selector(imagePopupActionView:selectedImage:)]) {
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                for (PhtotObj *photoObj in self.selectedImageArray) {
                    [tempArray addObject:[UIImage imageWithCGImage:[photoObj.asset defaultRepresentation].fullScreenImage]];
                }
                [self.delegate imagePopupActionView:self selectedImage:tempArray];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)btnTokePhotoAction:(UIButton *)sender
{
    if(!self.picker){
        _picker = [[UIImagePickerController alloc] init];//初始化
        _picker.delegate = self;
        _picker.allowsEditing = NO;//设置可编辑
    }
    
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self dismissWithCompletion:^{
        
    }];
    
    [self.viewController presentViewController:self.picker animated:YES completion:^{
        
    }];
}

-(void)btnCancelAction:(UIButton *)sender
{
    [self dismissWithCompletion:^{
        
    }];
}

#pragma mark - 显示相册VC
-(void)showAlbumVc:(NSArray *)dataArray
{
    BBMAlbumViewController *albumViewController = [[BBMAlbumViewController alloc] init];
    albumViewController.delegate = self;
    albumViewController.maxSelectedNumber = self.maxSelectedNumber;
    
    BBMPhotosViewController *photoVc = [[BBMPhotosViewController alloc] init];
    photoVc.delegate = albumViewController;
    photoVc.maxSelectedNumber = self.maxSelectedNumber;
    
    BBMAlbumNavigationController *nav = [[BBMAlbumNavigationController alloc] initWithRootViewController:albumViewController];
    albumViewController.dataArr = dataArray;
    
    NSArray *tempPhotoArray = ((NSDictionary *)self.albumAndAssetArray[0])[BBMAssetAlbumPhotosArr];
    NSMutableArray *tempDataArray = [[NSMutableArray alloc] init];
    for (ALAsset *asset in tempPhotoArray) {
        BBMPhotoModel *photoModel = [[BBMPhotoModel alloc] init];
        photoModel.asset = asset;
        [tempDataArray addObject:photoModel];
    }
    photoVc.dataArr = tempDataArray;
    
    [nav pushViewController:photoVc animated:NO];
//    photoVc.navigationItem.backBarButtonItem.title = @"相册";
    [self.viewController presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark - 控件显示
-(void)showWithCompletion:(void(^)())completion
{
    [self.window addSubview:self];
    [self layoutIfNeeded];
    
    if (self.albumAndAssetArray && self.albumAndAssetArray.count>0) {
        [self resumeWholeView];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [BBMAlbumAssetTool getAllAlbumAndAssetsComplete:^(NSArray *dataArray) {
                self.albumAndAssetArray = dataArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *tempArray = ((NSDictionary *)self.albumAndAssetArray[0])[BBMAssetAlbumPhotosArr];
                    if (tempArray.count>defaultMaxShowImageNumber) {
                        [self setImages:[tempArray subarrayWithRange:NSMakeRange(tempArray.count-defaultMaxShowImageNumber, defaultMaxShowImageNumber)]];
                    }else{
                        [self setImages:tempArray];
                    }
                });
            } albumAuthorizationFail:^{
          
            }];
        });
    }
    
    self.contentViewConstraintV.constant = -self.contentView.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        completion();
    }];
}

-(void)resumeWholeView
{
    [self.selectedImageArray removeAllObjects];
    for (PhtotObj *photo in self.photoObjArray) {
        [photo.btnCheck setSelected:NO];
        [photo dismissCover];
    }
    [self.btnAlbum setTitle:@"相册" forState:UIControlStateNormal];
    [self.btnAlbum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnAlbumActionType = BtnAlbumAction_openAlbum;
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
}

#pragma mark - 控件消失
-(void)dismissWithCompletion:(void(^)())completion
{
    self.contentViewConstraintV.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        completion();
    }];
}

#pragma mark - BBMAlbumViewControllerDelegate
- (void)bbmAlbumViewController:(BBMAlbumViewController *)bbmAlbumViewController didSeletedDataArr:(NSArray *)dataArr
{
    if ([self.delegate respondsToSelector:@selector(imagePopupActionView:selectedImage:)]) {
        [self.delegate imagePopupActionView:self selectedImage:dataArr];
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Picker returned successfully.");
    UIImage *theImage = nil;
    // 判断，图片是否允许修改
    if ([picker allowsEditing]){
        //获取用户编辑之后的图像
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        // 照片的元数据参数
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(imagePopupActionView:selectedImage:)]) {
        [self.delegate imagePopupActionView:self tokePhoto:theImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end


@implementation PhtotObj

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.userInteractionEnabled = YES;
        
        self.btnCheck = [[UIButton alloc] init];
        self.btnCheck.translatesAutoresizingMaskIntoConstraints = NO;
        [self.btnCheck setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [self.btnCheck setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    }
    return self;
}

-(void)showCover
{
    if (!self.btnCheck.isSelected) {
        if (!self.viewCover) {
           self.viewCover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
        }
        self.viewCover.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        [self.imageView addSubview:self.viewCover];
        self.imageView.userInteractionEnabled = NO;
        [self.imageView bringSubviewToFront:self.viewCover];
    }
    
}

-(void)dismissCover
{
    self.imageView.userInteractionEnabled = YES;
    if (self.viewCover && [self.viewCover superview]) {
        [self.viewCover removeFromSuperview];
    }
}

@end


