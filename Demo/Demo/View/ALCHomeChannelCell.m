//
//  ALCHomeChannelCell.m
//  Demo
//
//  Created by Macbook Pro on 2020/7/28.
//  Copyright © 2020 Category. All rights reserved.
//

#import "ALCHomeChannelCell.h"
#import <Masonry/Masonry.h>
#import "ALCHomeChannelModel.h"
@interface ALCHomeChannelCell ()

/// 背景
@property (nonatomic, strong) UIView *backgroundClipView;

/// 频道title
@property (nonatomic, strong) UILabel *channelTitleLabel;

/// icon
@property (nonatomic, strong) UIImageView *iconImageView;

/// icon是否隐藏
@property (nonatomic, assign, getter=isHiddenRound) BOOL hiddenIcon;

/// 是否为新增频道
@property (nonatomic, assign, getter=isNewly) BOOL newly;

/// 是否可以移动
@property (nonatomic, assign, getter=isCanMove) BOOL canMove;

@end

@implementation ALCHomeChannelCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    [self.contentView addSubview:self.backgroundClipView];
    [self.backgroundClipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.backgroundClipView addSubview:self.channelTitleLabel];
    [self.channelTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.backgroundClipView);
    }];
    
    [self.backgroundClipView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundClipView).offset(4);
        make.right.equalTo(self.backgroundClipView).offset(-4);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
}

#pragma mark - private method

- (void)configureWithModel:(ALCHomeChannelModel *)model editEnabled:(BOOL)enabled {
    self.hiddenIcon = NO;
    self.iconImageView.hidden = NO;
    self.newly = model.isNewly;
    self.canMove = model.canMove;
    self.channelTitleLabel.text = model.title;
    
    if (self.canMove) {
        self.backgroundClipView.backgroundColor = [UIColor lightGrayColor];
    }
    else {
        self.backgroundClipView.backgroundColor = [UIColor clearColor];
    }
    
    if (self.isNewly) {
        self.iconImageView.image = [UIImage imageNamed:@"icon_home_channel_round"];
    }
    else {
        if (self.canMove) {
            self.iconImageView.hidden = YES;
            self.hiddenIcon = YES;
        }
        else {
            self.iconImageView.image = [UIImage imageNamed:@"icon_home_chanel_add"];
        }
    }
    [self editEnabled:enabled];
}

- (void)editEnabled:(BOOL)enabled {
    if (enabled && self.canMove) {
        if (![self.backgroundClipView.layer animationForKey:@"shake"]) {
            CABasicAnimation * animate = [CABasicAnimation animationWithKeyPath:@"transform"];
            animate.fromValue = [NSValue valueWithCATransform3D: CATransform3DRotate(self.backgroundClipView.layer.transform, -M_PI_4 / 15, 0, 0, 1)];
            animate.toValue = [NSValue valueWithCATransform3D: CATransform3DRotate(self.backgroundClipView.layer.transform, M_PI_4 / 15, 0, 0, 1)];
            animate.duration = 0.1;
            animate.removedOnCompletion = NO;
            animate.fillMode = kCAFillModeForwards;
            animate.repeatCount = CGFLOAT_MAX;
            animate.autoreverses = YES;
            [self.backgroundClipView.layer addAnimation:animate forKey:@"shake"];
            if (self.hiddenIcon) {
                self.iconImageView.hidden = NO;
            }
            self.iconImageView.image = [UIImage imageNamed:@"icon_home_channel_close"];
        }
    }
    else {
        [self.backgroundClipView.layer removeAllAnimations];
        if (self.hiddenIcon) {
            self.iconImageView.hidden = YES;
        }
        else {
            if (self.isNewly) {
                self.iconImageView.image = [UIImage imageNamed:@"icon_home_channel_round"];
            }
            else {
                self.iconImageView.image = [UIImage imageNamed:@"icon_home_channel_add"];
            }
        }
    }
}

#pragma mark - getter & setter

- (UIView *)backgroundClipView {
    if (_backgroundClipView == nil) {
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        // TODO: 边框颜色
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        view.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        view.layer.cornerRadius = 8;
        _backgroundClipView = view;
    }
    return _backgroundClipView;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        UIImageView * imageView = [[UIImageView alloc]init];
        _iconImageView = imageView;
    }
    return _iconImageView;
}

- (UILabel *)channelTitleLabel {
    if (_channelTitleLabel == nil) {
        UILabel * label = [[UILabel alloc]init];
        // TODO: 暗黑模式适配
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        _channelTitleLabel = label;
    }
    return _channelTitleLabel;
}

@end
