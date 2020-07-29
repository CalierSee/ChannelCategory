//
//  ALCHomeCategoryCollectionReusableView.h
//  Demo
//
//  Created by Macbook Pro on 2020/7/28.
//  Copyright © 2020 Category. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ALCHomeCategoryModel;

@interface ALCHomeCategoryCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong, readonly) UILabel *subTitleLabel;

- (void)configureWithModel:(ALCHomeCategoryModel *)model;

@end

NS_ASSUME_NONNULL_END
