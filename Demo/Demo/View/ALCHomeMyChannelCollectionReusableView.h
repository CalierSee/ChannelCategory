//
//  ALCHomeMyChannelCollectionReusableView.h
//  Demo
//
//  Created by Macbook Pro on 2020/7/28.
//  Copyright © 2020 Category. All rights reserved.
//

#import "ALCHomeCategoryCollectionReusableView.h"
@class RACSignal;
NS_ASSUME_NONNULL_BEGIN

@interface ALCHomeMyChannelCollectionReusableView : ALCHomeCategoryCollectionReusableView

///编辑按钮
@property (nonatomic, strong, readonly) UIButton *editButton;

- (void)configureWithModel:(ALCHomeCategoryModel *)model editing:(BOOL)editing;

- (void)configureWithModel:(ALCHomeCategoryModel *)model NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
