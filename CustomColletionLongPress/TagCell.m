//
//  TagCell.m
//  GuoHongPublish
//
//  Created by dch on 2019/6/4.
//  Copyright © 2019年 CityDO. All rights reserved.
//

#import "TagCell.h"
#import "Masonry/Masonry.h"

@interface TagCell ()

@property(strong, nonatomic)UILabel *textLabel;
@property(strong, nonatomic)UIButton *editBtn;
@property (assign, nonatomic)BOOL  isMore;

@end

@implementation TagCell

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.layer.cornerRadius = self.bounds.size.height*0.5;
        _textLabel.layer.borderWidth = 1;
//        _textLabel.layer.borderColor = colorWithRGB(0xffffff).CGColor;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.layer.masksToBounds = YES;
        [self addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(self);
        }];
    }
    return _textLabel;
}

- (UIButton *)editBtn
{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.hidden = NO;
        _editBtn.userInteractionEnabled = NO;
        [self addSubview:_editBtn];
        [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self);
            make.top.mas_equalTo(self);
            make.height.with.mas_equalTo(14);
        }];
    }
    return _editBtn;
}

- (void)configWithContent:(NSString *)content isMore:(BOOL)isMore isEdit:(BOOL)isEdit isDefault:(BOOL)isDefault
{
    self.textLabel.text = content;
    self.textLabel.layer.borderColor = (isMore ? [UIColor lightGrayColor] : [UIColor blueColor]).CGColor;
    [self.editBtn setImage:[UIImage imageNamed:isMore?@"edit_blue":@"edit_red"] forState:UIControlStateNormal];
    self.isMore = isMore;
    self.editBtn.hidden = isEdit?(isDefault?YES:NO):YES;
    if (isDefault) {
        self.textLabel.backgroundColor = [UIColor lightGrayColor];
        self.textLabel.layer.borderWidth = 0;
    }else{
        self.textLabel.layer.borderWidth = 1;
        self.textLabel.backgroundColor = [UIColor whiteColor];
    }
    //    if (isEdit) {
    //        if (isDefault) {
    //
    //        }
    //    }else{
    //
    //    }
}

- (void)udpateIconStatus:(BOOL)isMore
{
    [self.editBtn setImage:[UIImage imageNamed:!isMore?@"edit_blue":@"edit_red"] forState:UIControlStateNormal];
    self.textLabel.layer.borderColor = (!isMore ? [UIColor lightGrayColor] : [UIColor blueColor]).CGColor;
}


@end
