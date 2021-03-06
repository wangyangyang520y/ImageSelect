//
//  BBMAlbumViewController.m
//  BBMImageViewPickerControoer
//
//  Created by BBM on 15/10/7.
//  Copyright (c) 2015年 BBM. All rights reserved.
//

#import "BBMAlbumViewController.h"
#import "BBMAlbumCell.h"
#import "BBMAlbumAssetTool.h"
#import "BBMPhotoModel.h"
#import "BBMAlbumNavigationController.h"

static BBMAlbumViewController *albumViewController;
static BBMPhotosViewController *photoVc;

@interface BBMAlbumViewController ()
@property(nonatomic, strong)UITableView *myTableView;
@property(nonatomic, strong)NSArray *assetArray;
@property(nonatomic,strong) NSMutableArray *selectedAssetArray;
@property(nonatomic,assign) NSInteger  maxSelectedNumber;
@end

@implementation BBMAlbumViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"相册";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNav];
    [self setupSubviews];
}

-(void)setAssetArray:(NSArray *)assetArray selectedAssetArray:(NSMutableArray *)selectedAssetArray maxSelectedNumber:(NSInteger)maxSelectedNumber
{
    self.assetArray = assetArray;
    self.selectedAssetArray = selectedAssetArray;
    self.maxSelectedNumber = maxSelectedNumber;
}

- (void)setupNav
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

/**
 *  退出
 */
- (void)back
{
    [self.selectedAssetArray removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupSubviews
{
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myTableView];
    
    self.title = @"相册";
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBMAlbumCell *cell = [BBMAlbumCell cellWithTableView:tableView];
    
    cell.dataDic = self.assetArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *assetArray = ((NSDictionary *)self.assetArray[indexPath.row])[BBMAssetAlbumPhotosArr];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (ALAsset *asset in assetArray) {
        BBMPhotoModel *photoModel = [[BBMPhotoModel alloc] init];
        photoModel.asset = asset;
        [tempArray addObject:photoModel];

        for (ALAsset *selectedAsset in self.selectedAssetArray) {
            if ([[selectedAsset defaultRepresentation].url isEqual:[asset defaultRepresentation].url]) {
                photoModel.isSelected = YES;
            }
        }
    }
    
    BBMPhotosViewController *photosViewController = [[BBMPhotosViewController alloc] init];
    
    if (!self.selectedAssetArray) {
        self.selectedAssetArray = [[NSMutableArray alloc] init];
    }
    
    [photosViewController setPhotoModelArray:tempArray selectedAssetArray:self.selectedAssetArray maxSelectedNumber:self.maxSelectedNumber];
    photosViewController.delegate = self;
    [self.navigationController pushViewController:photosViewController animated:YES];
}

#pragma mark - BBMPhotosViewControllerDelegate
- (void)bbmPhotosViewController:(BBMPhotosViewController *)bbmPhotosViewController didSelectedAssetArray:(NSArray *)assetArray
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bbmAlbumViewController:didSeletedAssetArrary:)]) {
        [self.delegate bbmAlbumViewController:self didSeletedAssetArrary:assetArray];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
