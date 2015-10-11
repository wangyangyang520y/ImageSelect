//
//  BBMAlbumBrowseViewController.m
//  ImageSelectTest
//
//  Created by 王洋洋 on 15/10/10.
//  Copyright © 2015年 王洋洋. All rights reserved.
//

#import "BBMAlbumBrowseViewController.h"
#import "PhotoBrowseView.h"
#import "BBMPhotoModel.h"


@interface BBMAlbumBrowseViewController ()

@property(nonatomic,assign) NSInteger currentIndex;
@property(nonatomic,strong) NSMutableArray *photoArray;
@property(nonatomic,strong) NSMutableArray *selectedImageArray;

@property(nonatomic,strong) PhotoBrowseView *photoBrowseView;

@property(nonatomic,strong) UIButton *btnCheck;
@property(nonatomic,strong) UILabel *lbTitle;

@property(nonatomic,strong) UIView *footerView;
@property(nonatomic,strong) UIButton *btnConfirm;

@end

@implementation BBMAlbumBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initNav];
    [self initContentView];
    [self initFooterView];
}

-(void)setAssetArray:(NSArray *)assetArray currentIndex:(NSInteger)currentIndex maxSelectedNumber:(NSInteger)maxSelectedNumber
{
    _currentIndex = currentIndex;
    _maxSelectedNumber = maxSelectedNumber;
    self.photoArray = [[NSMutableArray alloc] init];
    for (BBMPhotoModel *photoModel in assetArray) {
        Photo *photo = [[Photo alloc] init];
        photo.asset = photoModel.asset;
        photo.isSelected = photoModel.isSelected;
        [self.photoArray addObject:photo];
        
        if(photoModel.isSelected){
            if (!self.selectedImageArray) {
                self.selectedImageArray = [[NSMutableArray alloc] init];
            }
            [self.selectedImageArray addObject:photo];
        }
    }
}

#pragma mark - 初始化导航栏
-(void)initNav
{
    self.btnCheck = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.btnCheck setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [self.btnCheck setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    [self.btnCheck addTarget:self action:@selector(btnCheckAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnCheck];
    self.navigationItem.rightBarButtonItem = barItem;
    
    //判断初始化照片是否已经选中
    Photo *photo = self.photoArray[self.currentIndex];
    [self.btnCheck setSelected:photo.isSelected];
    
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    self.lbTitle.textAlignment = NSTextAlignmentCenter;
    self.lbTitle.font = [UIFont systemFontOfSize:20];
    self.lbTitle.textColor = [UIColor blackColor];
    self.lbTitle.text = [NSString stringWithFormat:@"%@/%@",@(self.photoArray.count),@(self.currentIndex+1)];
    self.navigationItem.titleView = self.lbTitle;
}

#pragma mark - 初始化具体内容
-(void)initContentView
{
    self.photoBrowseView = [[PhotoBrowseView alloc] initWithFrame:self.view.frame];
    __weak BBMAlbumBrowseViewController *weakSelf = self;
    
    [weakSelf.photoBrowseView setPhotoArray:self.photoArray currentPhotoIndex:self.currentIndex tapGesture:^{
        if (self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [UIView animateWithDuration:0.25 animations:^{
                self.footerView.frame = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44);
            } completion:^(BOOL finished) {
                
            }];
        }else{
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [UIView animateWithDuration:0.25 animations:^{
                self.footerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44);
            } completion:^(BOOL finished) {
                
            }];
        }
    }];
    
    weakSelf.photoBrowseView.scrollToImageCallBackBlock = ^(NSInteger index){
        self.currentIndex = index;
        Photo *photo = self.photoArray[index];
        [self.btnCheck setSelected:photo.isSelected];
        self.lbTitle.text = [NSString stringWithFormat:@"%@/%@",@(self.photoArray.count),@(self.currentIndex+1)];
    };
    
    [self.view addSubview:self.photoBrowseView];
}

#pragma mark - 初始化底部视图
-(void)initFooterView
{
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
    self.footerView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    [self.view addSubview:self.footerView];
    [self.view bringSubviewToFront:self.footerView];
    
    self.btnConfirm = [[UIButton alloc] init];
    self.btnConfirm.translatesAutoresizingMaskIntoConstraints = NO;
    [self.btnConfirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnConfirm addTarget:self action:@selector(btnConfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:self.btnConfirm];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_btnConfirm]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_btnConfirm)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_btnConfirm]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_btnConfirm)]];
    
    [self changeComfirmBtnState];
}

#pragma mark - btnCheck按钮点击回调
-(void)btnCheckAction:(UIButton *)sender
{
    if (!self.selectedImageArray) {
        self.selectedImageArray = [[NSMutableArray alloc] init];
    }
    
    Photo *currentPhoto = self.photoArray[self.currentIndex];
    
    if (sender.isSelected) {
        currentPhoto.isSelected = NO;
        [self.selectedImageArray removeObject:currentPhoto];
        [sender setSelected:NO];
    }else{
        if (self.maxSelectedNumber>0 ) {
            if (self.selectedImageArray.count<self.maxSelectedNumber) {
                currentPhoto.isSelected = YES;
                [self.selectedImageArray addObject:self.photoArray[self.currentIndex]];
                [sender setSelected:YES];
            }else{
                NSLog(@"图片选择总数超过最大可选数量%@",@(self.maxSelectedNumber));
            }
        }else{
            currentPhoto.isSelected = YES;
            [self.selectedImageArray addObject:self.photoArray[self.currentIndex]];
            [sender setSelected:YES];
        }
    }
    
    [self changeComfirmBtnState];
}

#pragma mark - 确认按钮点击回调
-(void)btnConfirmAction:(UIButton *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
    if ([self.delegate respondsToSelector:@selector(browseViewControllerSelectedImage:)]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (Photo *photo in self.selectedImageArray) {
            [tempArray addObject:photo.asset];
        }
        [self.delegate browseViewControllerSelectedImage:tempArray];
    }
}


#pragma mark - 改变确认按钮的状态
-(void)changeComfirmBtnState
{
    if (self.selectedImageArray.count<=0) {
        [self.btnConfirm setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btnConfirm setEnabled:NO];
    }else{
        [self.btnConfirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnConfirm setEnabled:YES];
    }
    [self.btnConfirm setTitle:[NSString stringWithFormat:@"确认（%@张）",@(self.selectedImageArray.count)] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
