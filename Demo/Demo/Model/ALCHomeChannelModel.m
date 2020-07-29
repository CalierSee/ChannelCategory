//
//  ALCHomeChannelModel.m
//  Demo
//
//  Created by Macbook Pro on 2020/7/28.
//  Copyright © 2020 Category. All rights reserved.
//

#import "ALCHomeChannelModel.h"

@implementation ALCHomeCategoryModel

- (NSString *)title {
    if (_title == nil) {
        switch (self.category) {
            case ALCHomeChannelCategoryMy:
                _title = @"我的频道";
                break;
            case ALCHomeChannelCategoryHot:
                _title = @"热门精选";
                break;
            case ALCHomeChannelCategoryLife:
                _title = @"生活娱乐";
                break;
            case ALCHomeChannelCategorySport:
                _title = @"体育财经";
                break;
            case ALCHomeChannelCategoryArt:
                _title = @"教科文艺";
                break;
            case ALCHomeChannelCategoryOther:
                _title = @"其他";
                break;
                
            default:
                return @"未定义";
                break;
        }
    }
    return _title;
}

- (NSString *)subTitle {
    if (_subTitle == nil) {
        switch (self.category) {
            case ALCHomeChannelCategoryMy:
                _subTitle = @"点击进入频道";
                break;
                
            default:
                break;
        }
    }
    return _subTitle;
}

@end

@implementation ALCHomeChannelModel

- (BOOL)isCanMove {
    if (self.category == ALCHomeChannelCategoryMy) {
        return NO;
    }
    else {
        return _canMove;
    }
}

@end
