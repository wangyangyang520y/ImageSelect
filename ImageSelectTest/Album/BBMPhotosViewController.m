//
//  BBMPhotosViewController.m
//  BBMImageViewPickerControoer
//
//  Created by BBM on 15/10/7.
//  Copyright (c) 2015年 BBM. All rights reserved.
//

#import "BBMPhotosViewController.h"
#import "BBMAlbumBrowseViewController.h"
#import "BBMPhotoCell.h"

#define NumberOfEachRow   4

static NSString *collectionViewCellID = @"BBMPhotoCell";

@interface BBMPhotosViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, BBMPhotoCellDelegate,BBMAlbumBrowseViewControllerDelegate>
{
    BOOL isSelectedCompletion;
}

@property(nonatomic, strong)UICollectionView *myCollectionView;

@property(nonatomic, strong)NSMutableArray *selectedAssetArray;
//@property(nonatomic, strong)NSArray *seletedInitAssetArray;

@property(nonatomic,assign) NSInteger  maxSelectedNumber;
@property(nonatomic,strong)NSArray *photoModelArray;

@property(nonatomic, strong)UIView *footerView;
@property(nonatomic, strong)UIButton *btnConfirm;

@end

@implementation BBMPhotosViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        isSelectedCompletion = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    [self initNavibar];
    [self initSubviews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.maxSelectedNumber>0 && isSelectedCompletion) {
        for(BBMPhotoModel *model in self.photoModelArray){
            if (model.isSelected == NO) {
                model.isCover = YES;
            }
        }
        [self.myCollectionView reloadData];
    }
}

- (void)initData
{
    if (!self.selectedAssetArray) {
        self.selectedAssetArray = [[NSMutableArray alloc] init];
    }
}

- (void)initNavibar
{
    self.title = @"照片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)initSubviews
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWH = (self.view.frame.size.width - 5 * (NumberOfEachRow + 1)) / NumberOfEachRow;
    flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
   
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:flowLayout];
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.alwaysBounceVertical = YES;
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.myCollectionView];
    self.myCollectionView.contentInset = UIEdgeInsetsMake(5, 5, 40, 5);
    
    //注册
    [self.myCollectionView registerClass:[BBMPhotoCell class] forCellWithReuseIdentifier:collectionViewCellID];
    
    [self setupConfirmBtn];
}

-(void)setPhotoModelArray:(NSArray *)photoModelArray selectedAssetArray:(NSMutableArray *)selectedAssetArray maxSelectedNumber:(NSInteger)maxSelectedNumber
{
    self.photoModelArray = photoModelArray;
    if (selectedAssetArray) {
        self.selectedAssetArray = selectedAssetArray;
    }
    self.maxSelectedNumber = maxSelectedNumber;
    
    if(self.maxSelectedNumber >0 && self.selectedAssetArray && self.selectedAssetArray.count>=self.maxSelectedNumber){
        isSelectedCompletion = YES;
    }
}

- (void)setupConfirmBtn
{
    if ( ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending)) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.footerView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.footerView.frame = CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40);
        
    }else{
        self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
        self.footerView.backgroundColor = [UIColor whiteColor];
    }
    
    [self.view addSubview:self.footerView];
    
    self.btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.btnConfirm.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.btnConfirm addTarget: self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:self.btnConfirm];
    
    [self changeComfirmBtnState];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:174/256.0 green:174/256.0 blue:174/256.0 alpha:1.0];
    [self.footerView addSubview:line];
    

}

- (void)confirmBtnClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bbmPhotosViewController:didSelectedAssetArray:)]) {
        [self.delegate bbmPhotosViewController:self didSelectedAssetArray:self.selectedAssetArray];
    }
    [self back];
}

/**
 *  退出
 */
- (void)back
{
    [self.selectedAssetArray removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)changeComfirmBtnState
{
    if (self.selectedAssetArray.count<=0) {
        [self.btnConfirm setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btnConfirm setEnabled:NO];
    }else{
        [self.btnConfirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnConfirm setEnabled:YES];
    }
    [self.btnConfirm setTitle:[NSString stringWithFormat:@"确认（%@张）",@(self.selectedAssetArray.count)] forState:UIControlStateNormal];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BBMPhotoCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    photoCell.delegate = self;
    photoCell.photoModel = self.photoModelArray[indexPath.row];
    
    return photoCell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BBMAlbumBrowseViewController *vc = [[BBMAlbumBrowseViewController alloc] init];
    vc.delegate = self;
    [vc setPhotoModelArray:self.photoModelArray currentIndex:indexPath.row maxSelectedNumber:self.maxSelectedNumber];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma  mark - BBMPhotoCellDelegate
- (void)bbmPhotoCell:(BBMPhotoCell *)bbmPhotoCell didSeletedAsset:(ALAsset *)seletedAsset
{
    [self.selectedAssetArray addObject:seletedAsset];
    bbmPhotoCell.photoModel.isSelected = YES;
    bbmPhotoCell.photoModel.isCover = NO;

    if (self.maxSelectedNumber>0 && self.selectedAssetArray.count == self.maxSelectedNumber) {
        
        for(BBMPhotoModel *model in self.photoModelArray){
            if (model.isSelected == NO) {
                model.isCover = YES;
            }
        }
        
        [self.myCollectionView reloadData];
    }
    
    [self changeComfirmBtnState];
}

- (void)bbmPhotoCell:(BBMPhotoCell *)bbmPhotoCell didDeseletedAsset:(ALAsset *)deseletedAsset
{
    [self.selectedAssetArray removeObject:deseletedAsset];
    bbmPhotoCell.photoModel.isSelected = NO;
    bbmPhotoCell.photoModel.isCover = NO;
    
    if (self.selectedAssetArray.count == self.maxSelectedNumber-1) {
        for(BBMPhotoModel *model in self.photoModelArray){
            if (model.isSelected == NO) {
                model.isCover = NO;
            }
        }
        [self.myCollectionView reloadData];
    }
    
    [self changeComfirmBtnState];
}

#pragma mark - BBMAlbumBrowseViewControllerDelegate

-(void)browseViewControllerSelectedAsset:(NSArray *)assetArray
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bbmPhotosViewController:didSelectedAssetArray:)]) {
        [self.delegate bbmPhotosViewController:self didSelectedAssetArray:assetArray];
    }
    [self back];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
