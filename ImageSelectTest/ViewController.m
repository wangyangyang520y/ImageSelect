//
//  ViewController.m
//  ImageSelectTest
//
//  Created by 王洋洋 on 15/10/8.
//  Copyright © 2015年 王洋洋. All rights reserved.
//

#import "ViewController.h"
#import "ImagePopupActionView.h"

@interface ViewController ()<ImagePopupActionViewDelegate>

@property(strong,nonatomic) UIButton *btn1;
@property(strong,nonatomic) UIButton *btn2;
@property(nonatomic,strong) ImagePopupActionView *popup1;
@property(nonatomic,strong) ImagePopupActionView *popup2;

@property(nonatomic,strong) UILabel *lbDisplay;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.btn1 = [[UIButton alloc] initWithFrame:CGRectMake(60, 200, 200, 40)];
    self.btn1.backgroundColor = [UIColor redColor];
    [self.btn1 setTitle:@"noPreviewImage测试" forState:UIControlStateNormal];
    [self.btn1 addTarget:self action:@selector(btn1Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn1];
    
    self.btn2 = [[UIButton alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(self.btn1.frame)+30, 200, 40)];
    self.btn2.backgroundColor = [UIColor redColor];
    [self.btn2 setTitle:@"previewImage测试" forState:UIControlStateNormal];
    [self.btn2 addTarget:self action:@selector(btn2Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn2];
    
    
    self.lbDisplay = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.btn2.frame)+30, self.view.frame.size.width-40, 200)];
    self.lbDisplay.textAlignment = NSTextAlignmentCenter;
    self.lbDisplay.textColor = [UIColor redColor];
    self.lbDisplay.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.lbDisplay];
    
    
    
    self.popup1 = [[ImagePopupActionView alloc] initWithFrame:[UIScreen mainScreen].bounds withViewController:self previewImage:NO];
    self.popup1.maxSelectedNumber = 5;
    self.popup1.isDispalySelectedItem = YES;
    self.popup1.delegate = self;
    
    
    self.popup2 = [[ImagePopupActionView alloc] initWithFrame:[UIScreen mainScreen].bounds withViewController:self previewImage:YES];
    self.popup2.maxSelectedNumber = 5;
    self.popup2.isDispalySelectedItem = YES;
    self.popup2.delegate = self;
}

-(void)btn1Action:(UIButton *)sender
{
    [self.popup1 showWithCompletion:^{
        
    }];
}


-(void)btn2Action:(UIButton *)sender
{
    [self.popup2 showWithCompletion:^{
        
    }];
}

#pragma mark - ImagePopupActionViewDelegate

-(void)imagePopupActionView:(ImagePopupActionView *)actionView selectedAsset:(NSArray *)assetArray{
    
    self.lbDisplay.text = [NSString stringWithFormat:@"确认提交的照片数量：%@",@(assetArray.count)];
    
}

-(void)imagePopupActionView:(ImagePopupActionView *)actionView tokePhotoAsset:(ALAsset *)asset{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
