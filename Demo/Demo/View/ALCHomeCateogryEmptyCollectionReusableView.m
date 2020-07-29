//
//  ALCHomeCateogryEmptyCollectionReusableView.m
//  Demo
//
//  Created by Macbook Pro on 2020/7/29.
//  Copyright © 2020 Category. All rights reserved.
//

#import "ALCHomeCateogryEmptyCollectionReusableView.h"
#import <Masonry.h>
@implementation ALCHomeCateogryEmptyCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    UILabel * label = [[UILabel alloc]init];
    label.text = @"已全部添加到\"我的频道\"";
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(self);
    }];
}

@end
