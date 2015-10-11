//
//  BBMAlbumCell.m
//  BBMImageViewPickerControoer
//
//  Created by BBM on 15/10/7.
//  Copyright (c) 2015年 BBM. All rights reserved.
//

#import "BBMAlbumCell.h"
#import "BBMAlbumAssetTool.h"

@interface BBMAlbumCell()
@property(nonatomic, strong)UIImageView *iconImageView;
@property(nonatomic, strong)UILabel *lbcontent;
@property(nonatomic, strong)UIImageView *arrowImageView;
@property(nonatomic, strong)UIView *bottomLine;
@property(nonatomic, assign)CGSize size;
@end

@implementation BBMAlbumCell
+ (BBMAlbumCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"BBMAlbumCell";
    BBMAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BBMAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconImageView];
        
        self.lbcontent = [[UILabel alloc] init];
        [self.contentView addSubview:self.lbcontent];
        
        self.arrowImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.arrowImageView];
        
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = [UIColor colorWithRed:174/256.0 green:174/256.0 blue:174/256.0 alpha:1.0];
        [self.contentView addSubview:self.bottomLine];
        
    }
    return self;
    
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    
    self.iconImageView.image = [dataDic objectForKey:BBMAssetAlbumPosterImage];
    
    NSString *contentStr = [NSString stringWithFormat:@"%@  (%@)",[dataDic objectForKey:BBMAssetAlbumGroupName], [dataDic objectForKey:BBMAssetAlbumPhotosCount]];
    CGSize size = [contentStr sizeWithAttributes:@{NSFontAttributeName : self.lbcontent.font}];
    self.size = size;
    self.lbcontent.text = contentStr;
    
    self.arrowImageView.image = [UIImage imageNamed:@"findAccessIcon"];

}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake(10, (self.frame.size.height - 55)/2.0, 55, 55);
    self.arrowImageView.frame = CGRectMake(self.frame.size.width - 25, (self.frame.size.height  - 15)/2.0, 8, 15);
    
    
    CGFloat width = self.frame.size.width - (CGRectGetMaxX(self.iconImageView.frame) + 5) - 30;
    self.lbcontent.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 5, (self.frame.size.height - self.size.height)/2.0, MIN(self.size.width, width), self.size.height);
    
    
    self.bottomLine.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
}
@end
