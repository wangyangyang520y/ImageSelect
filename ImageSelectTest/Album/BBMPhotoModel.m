//
//  BBMPhotoModel.m
//  BBMImageViewPickerControoer
//
//  Created by BBM on 15/10/8.
//  Copyright (c) 2015年 BBM. All rights reserved.
//

#import "BBMPhotoModel.h"

@implementation BBMPhotoModel

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.isSelected = NO;
        self.isCover = NO;
    }
    return self;
}

@end
