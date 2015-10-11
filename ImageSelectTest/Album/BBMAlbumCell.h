//
//  BBMAlbumCell.h
//  BBMImageViewPickerControoer
//
//  Created by BBM on 15/10/7.
//  Copyright (c) 2015年 BBM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBMAlbumCell : UITableViewCell

+ (BBMAlbumCell *)cellWithTableView:(UITableView *)tableView;

@property(nonatomic, strong)NSDictionary *dataDic;

@end
