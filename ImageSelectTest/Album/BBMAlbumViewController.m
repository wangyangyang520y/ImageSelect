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

@end

@implementation BBMAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupSubviews];
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
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBMAlbumCell *cell = [BBMAlbumCell cellWithTableView:tableView];
    
    cell.dataDic = self.dataArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBMPhotosViewController *photosViewController = [[BBMPhotosViewController alloc] init];
    
    if (self.maxSelectedNumber>0) {
        photosViewController.maxSelectedNumber = self.maxSelectedNumber;
    }
    photosViewController.delegate = self;
    
    NSArray *assetArray = ((NSDictionary *)self.dataArr[indexPath.row])[BBMAssetAlbumPhotosArr];
    NSMutableArray *dataArrM = [NSMutableArray array];
    for (ALAsset *asset in assetArray) {
        BBMPhotoModel *photoModel = [[BBMPhotoModel alloc] init];
        photoModel.asset = asset;
        [dataArrM addObject:photoModel];
    }
    photosViewController.dataArr = dataArrM;
    [self.navigationController pushViewController:photosViewController animated:YES];
}

#pragma mark - BBMPhotosViewControllerDelegate
- (void)bbmPhotosViewController:(BBMPhotosViewController *)bbmPhotosViewController didSeletedDataArr:(NSArray *)dataArr
{
    NSMutableArray *tempImageArray = [[NSMutableArray alloc] init];
    for (ALAsset *asset in dataArr) {
        [tempImageArray addObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]]];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(bbmAlbumViewController:didSeletedDataArr:)]) {
        [self.delegate bbmAlbumViewController:self didSeletedDataArr:tempImageArray];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
