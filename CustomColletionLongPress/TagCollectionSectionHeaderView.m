//
//  TagCollectionSectionHeaderView.m
//  GuoHongPublish
//
//  Created by dch on 2019/6/5.
//  Copyright © 2019年 CityDO. All rights reserved.
//

#import "TagCollectionSectionHeaderView.h"
#import "Masonry/Masonry.h"

@interface TagCollectionSectionHeaderView ()

 @property(strong, nonatomic)UIImageView *leftIcon;
@property(strong, nonatomic)UILabel *titleLabel;
@property(strong, nonatomic)UILabel *noteLabel;
@property(strong, nonatomic)UILabel *numLabel;

@end

@implementation TagCollectionSectionHeaderView

#pragma mark - lazy
- (UIImageView *)leftIcon
{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask_red"]];
        [self addSubview:_leftIcon];
        [_leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.top.mas_equalTo(self).offset(10);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(36);
        }];
    }
    return _leftIcon;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftIcon.mas_right).offset(20);
            make.centerY.mas_equalTo(self.leftIcon);
        }];
    }
    return _titleLabel;
}

- (UILabel *)noteLabel
{
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.text = @"长按拖动排序";
        _noteLabel.textColor = [UIColor grayColor];
        _noteLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:self.noteLabel];
        [_noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-20);
            make.centerY.mas_equalTo(self.titleLabel);
        }];
    }
    return _noteLabel;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = [UIFont systemFontOfSize:12];
        _numLabel.textColor = [UIColor grayColor];
        [self addSubview:_numLabel];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(5);
            make.bottom.mas_equalTo(self.titleLabel.mas_bottom).offset(-2);
        }];
    }
    return _numLabel;
}

- (void)configSectionHeaderWithIsMore:(BOOL)isMore
{
    [self addSubview:self.noteLabel];
    self.numLabel.text = @"(5/8)";
    self.numLabel.hidden = isMore;
    self.noteLabel.hidden = isMore;
    self.titleLabel.text = isMore?@"更多分类":@"我的关注";
    self.leftIcon.image = [UIImage imageNamed:isMore?@"mask_blue":@"mask_red"];
}


@end
