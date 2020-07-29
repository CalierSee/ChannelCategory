//
//  ALCHomeCategoryCollectionReusableView.m
//  Demo
//
//  Created by Macbook Pro on 2020/7/28.
//  Copyright © 2020 Category. All rights reserved.
//

#import "ALCHomeCategoryCollectionReusableView.h"
#import "ALCHomeChannelModel.h"
#import <Masonry/Masonry.h>
@interface ALCHomeCategoryCollectionReusableView ()

@property (nonatomic, strong) UILabel *subTitleLabel;

@end


@implementation ALCHomeCategoryCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI
- (void)setupUI {
    [self addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(5);
        make.left.equalTo(self);
    }];
}

#pragma mark - private method

- (void)configureWithModel:(ALCHomeCategoryModel *)model {
    self.subTitleLabel.text = model.title;
}

#pragma mark - getter & setter

- (UILabel *)subTitleLabel {
    if (_subTitleLabel == nil) {
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel = label;
    }
    return _subTitleLabel;
}
    
@end
