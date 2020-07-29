//
//  ALCHomeMyChannelCollectionReusableView.m
//  Demo
//
//  Created by Macbook Pro on 2020/7/28.
//  Copyright © 2020 Category. All rights reserved.
//

#import "ALCHomeMyChannelCollectionReusableView.h"
#import <Masonry/Masonry.h>
#import "ALCHomeChannelModel.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface ALCHomeMyChannelCollectionReusableView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *editButton;

@end

@implementation ALCHomeMyChannelCollectionReusableView

#pragma mark - UI
- (void)setupUI {
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
    [self addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.titleLabel.mas_right).offset(6);
    }];
    [self addSubview:self.editButton];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.equalTo(self);
        make.right.equalTo(self).offset(-10);
    }];
}

#pragma mark - private method

- (void)configureWithModel:(ALCHomeCategoryModel *)model editing:(BOOL)editing {
    self.editButton.selected = editing;
    self.titleLabel.text = model.title;
    self.subTitleLabel.text = model.subTitle;
}

#pragma mark - getter & setter

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        label.textAlignment = NSTextAlignmentLeft;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIButton *)editButton {
    if (_editButton == nil) {
        UIButton * button = [UIButton  buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        [button setTitle:@"完成" forState:UIControlStateSelected];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        _editButton = button;
    }
    return _editButton;
}


@end
