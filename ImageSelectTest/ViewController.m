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

@property(strong,nonatomic) UIButton *btn;
@property(nonatomic,strong) ImagePopupActionView *popup;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    self.btn.backgroundColor = [UIColor redColor];
    [self.btn setTitle:@"测试" forState:UIControlStateNormal];
    self.btn.center = self.view.center;
    [self.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    
    
}

-(void)btnAction:(UIButton *)sender
{
    self.popup = [[ImagePopupActionView alloc] initWithFrame:[UIScreen mainScreen].bounds withViewController:self];
    self.popup.maxSelectedNumber = 0;
    self.popup.delegate = self;
    [self.popup showWithCompletion:^{
        
    }];
}

#pragma mark - ImagePopupActionViewDelegate

-(void)selectedImage:(NSArray *)imageArray
{
    for (UIImage *image in imageArray) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        NSLog(@"原始图片大小%.2f",(float)imageData.length/1024.0);
        
        imageData = UIImageJPEGRepresentation(image, 0.5);
        NSLog(@"0.5图片大小%.2f",(float)imageData.length/1024.0);
        
        imageData = UIImageJPEGRepresentation(image, 0.4);
        NSLog(@"0.4图片大小%.2f",(float)imageData.length/1024.0);
        
        imageData = UIImageJPEGRepresentation(image, 0.3);
        NSLog(@"0.3图片大小%.2f",(float)imageData.length/1024.0);
        
        imageData = UIImageJPEGRepresentation(image, 0.2);
        NSLog(@"0.2图片大小%.2f",(float)imageData.length/1024.0);
        
        imageData = UIImageJPEGRepresentation(image, 0.1);
        NSLog(@"0.1图片大小%.2f",(float)imageData.length/1024.0);
        
    }
}

-(void)imagePopupActionViewTokePhoto:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSLog(@"原始图片大小%.2f",(float)imageData.length/1024.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
