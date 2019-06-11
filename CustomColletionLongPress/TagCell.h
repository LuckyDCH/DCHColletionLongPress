//
//  TagCell.h
//  GuoHongPublish
//
//  Created by dch on 2019/6/4.
//  Copyright © 2019年 CityDO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagCell : UICollectionViewCell

@property(copy, nonatomic)void (^tagCellBlock)(BOOL isMore);
- (void)udpateIconStatus:(BOOL)isMore;
- (void)configWithContent:(NSString *)content isMore:(BOOL)isMore isEdit:(BOOL)isEdit isDefault:(BOOL)isDefault;

@end

NS_ASSUME_NONNULL_END
