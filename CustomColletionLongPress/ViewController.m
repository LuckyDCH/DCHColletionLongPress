//
//  ViewController.m
//  CollectionViewLongPressDemo
//
//  Created by dch on 2019/6/6.
//  Copyright © 2019年 dch. All rights reserved.
//

#import "ViewController.h"
#import "TagCell.h"
#import "TagCollectionSectionHeaderView.h"
#import "Masonry/Masonry.h"

static CGFloat const tagSpacing = 20.0;
static CGFloat const itemSpacing = 10.0;

#define TagCellIdentifire @"TagCellIdentifire"
#define TagHeaderIdentifier @"TagHeaderIdentifier"
#define screenWidth() [UIScreen mainScreen].bounds.size.width
#define screenHeight() [UIScreen mainScreen].bounds.size.height
#define SafeAreaTopHeight ((screenHeight() == 812.0 || screenHeight() == 896.0) ? 88 : 64)
#define itemW ((screenWidth()-2*tagSpacing-3*itemSpacing)*0.25)



@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(strong, nonatomic)UIButton *backBtn;
@property(strong, nonatomic)UIView *navView;
@property(strong, nonatomic)UILabel *titleLabel;
@property(strong, nonatomic)UIButton *rightBtn;
@property(strong, nonatomic)UICollectionViewFlowLayout *flowlayout;
@property(strong, nonatomic)UICollectionView *tagCollectionView;
@property(strong, nonatomic)NSMutableArray *dataSource;
//长按手势
@property(strong, nonatomic)UILongPressGestureRecognizer *longPress;
@property(strong, nonatomic)TagCell *currentCell;
@property (assign, nonatomic)BOOL  isEdit;

@end

@implementation ViewController

#pragma mark - lazy
- (UICollectionViewFlowLayout *)flowlayout
{
    if (!_flowlayout) {
        _flowlayout = [[UICollectionViewFlowLayout alloc] init];
        _flowlayout.itemSize = CGSizeMake(itemW, 32);
        _flowlayout.minimumInteritemSpacing = itemSpacing;
        _flowlayout.minimumLineSpacing = itemSpacing;
        _flowlayout.sectionInset = UIEdgeInsetsMake(5, tagSpacing, 0, tagSpacing);
    }
    return _flowlayout;
}

- (UICollectionView *)tagCollectionView
{
    if (!_tagCollectionView) {
        _tagCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowlayout];
        _tagCollectionView.delegate = self;
        _tagCollectionView.dataSource = self;
        _tagCollectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tagCollectionView];
        [_tagCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(SafeAreaTopHeight);
            make.left.right.bottom.mas_equalTo(self.view);
        }];
    }
    return _tagCollectionView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:@[@"十九大",@"发布",@"经济",@"文化",@"国际",@"时评",@"军事"]];
        [_dataSource addObject:@[@"要闻",@"新思想",@"综合",@"快闪",@"实践",@"订阅",@"人物",@"科技",@"党史",@"人事",@"法纪",@"纪实",@"用典"]];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavView];
    [self setupView];
}

- (void)setupView
{
    [self.tagCollectionView registerClass:[TagCell class] forCellWithReuseIdentifier:TagCellIdentifire];
    [self.tagCollectionView registerClass:[TagCollectionSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TagHeaderIdentifier];
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMoving:)];
    self.longPress.minimumPressDuration = 0.3;
    [self.tagCollectionView addGestureRecognizer:self.longPress];
    self.tagCollectionView.userInteractionEnabled = YES;
}

- (void)setupNavView
{
    self.navView = [UIView new];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(SafeAreaTopHeight);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    [self.navView addSubview:self.titleLabel];
    _titleLabel.text = @"全部分类";
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:20];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.navView);
        make.bottom.mas_equalTo(self.navView).offset(-10);
    }];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self.navView addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.navView).offset(13);
        make.centerY.mas_equalTo(self.titleLabel);
        make.height.mas_equalTo(26);
        make.width.mas_equalTo(26);
    }];
//    BtnAction(self.backBtn, backClick);
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_rightBtn setTitle:@"完成" forState:UIControlStateSelected];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.navView addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.navView).offset(-15);
        make.centerY.mas_equalTo(self.titleLabel);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
    }];
//    BtnAction(self.rightBtn, editAction:);
    [_rightBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - action
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.isEdit = btn.selected;
    if (btn.selected) {
        [self.tagCollectionView removeGestureRecognizer:self.longPress];
    }else{
        [self.tagCollectionView addGestureRecognizer:self.longPress];
    }
    [self.tagCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TagCellIdentifire forIndexPath:indexPath];
    [cell configWithContent:self.dataSource[indexPath.section][indexPath.row] isMore:indexPath.section!=0 isEdit:self.rightBtn.selected isDefault:(indexPath.section==0&&indexPath.item<5)];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    TagCollectionSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TagHeaderIdentifier forIndexPath:indexPath];
    [headerView configSectionHeaderWithIsMore:indexPath.section!=0];
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(screenWidth(), 46);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagCell *cell = (TagCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.isEdit) {
        if (indexPath.section==0&&indexPath.row<5) {
            return;
        }
        [self reloadTableViewDataWithTag:self.dataSource[indexPath.section][indexPath.row] isConcern:indexPath.section!=0 IndexPath:indexPath tagCell:cell];
    }else{//cell的正常点击操作
//        if (self.delegate && [self.delegate respondsToSelector:@selector(selectTag:)]) {
//            [self.delegate selectTag:self.dataSource[indexPath.section][indexPath.row]];
//        }
    }
}

-(void)reloadTableViewDataWithTag:(NSString *)tag isConcern:(BOOL)isConcern IndexPath:(NSIndexPath *)indexPath tagCell:(TagCell *)cell
{
    NSMutableArray *myArr = [NSMutableArray arrayWithArray:self.dataSource[0]];
    NSMutableArray *moreArr = [NSMutableArray arrayWithArray:self.dataSource[1]];
    NSIndexPath *destinationIndexPath;
    NSLog(@"%@",self.dataSource);
    if (isConcern) {
        if (![myArr containsObject:tag]) {
            [myArr addObject:tag];
        }
        if ([moreArr containsObject:tag]) {
            [moreArr removeObject:tag];
        }
        destinationIndexPath = [NSIndexPath indexPathForItem:myArr.count-1 inSection:0];
    }else{
        if ([myArr containsObject:tag]&&myArr.count>5) {
            [myArr removeObject:tag];
        }
        if (![moreArr containsObject:tag]) {
            [moreArr insertObject:tag atIndex:0];
        }
        destinationIndexPath = [NSIndexPath indexPathForItem:0 inSection:1];
    }
    //    [self.tagCollectionView performBatchUpdates:^{
    [self.dataSource removeAllObjects];
    [self.dataSource addObject:myArr];
    [self.dataSource addObject:moreArr];
    //        [self.tagCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    //        [self.tagCollectionView insertItemsAtIndexPaths:@[destinationIndexPath]];
    //    } completion:^(BOOL finished) {
    //        [self.tagCollectionView reloadData];
    //    }];
    
    [self.tagCollectionView moveItemAtIndexPath:indexPath toIndexPath:destinationIndexPath];
    //更新cell右上角图标状态
    [cell udpateIconStatus:isConcern];
    [self.tagCollectionView reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault; //返回黑色
}
#pragma mark - longPress
- (void)longPressMoving:(UILongPressGestureRecognizer *)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            //获取当前选中cell的indexPath
            NSIndexPath *selectIndexPath = [self.tagCollectionView indexPathForItemAtPoint:[longPress locationInView:self.tagCollectionView]];
            TagCell *cell = (TagCell *)[self.tagCollectionView cellForItemAtIndexPath:selectIndexPath];
            self.currentCell = cell;
            if (!selectIndexPath||selectIndexPath.section!=0||selectIndexPath.row<5) {return;}
            [self.tagCollectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            //获取手势所到位置
            CGFloat y = [longPress locationInView:longPress.view].y;
            CGFloat x = [longPress locationInView:longPress.view].x;
            
            //限制手势范围的 y 值
            NSInteger line = [self.dataSource[0] count]%4 == 0 ? ([self.dataSource[0] count]/4) : ([self.dataSource[0] count]/4+1);
            CGFloat limitMaxY = 46 + 5 + line*32 + (line - 1)*itemSpacing;
            CGFloat limitX = tagSpacing+itemW+itemSpacing;
            CGFloat limitMinY = 46 + 5 + 32 + itemSpacing;
            CGFloat limitMinXy = 46 + 5 + 32*2 + itemSpacing * 2;
            //            NSLog(@"x = %f  limitx = %f -- y = %f  limitMinXy = %f",x,limitX,y,limitMinXy);
            if ((y<=limitMinXy&&x<limitX)) {
                return;
            }
            if (y <= limitMaxY && y >= limitMinY ) {
                [self.tagCollectionView updateInteractiveMovementTargetPosition:[longPress locationInView:longPress.view]];
            }
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self.tagCollectionView endInteractiveMovement];
        }
            break;
        default:[self.tagCollectionView cancelInteractiveMovement];
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //        NSIndexPath *selectIndexPath = [self.tagCollectionView indexPathForItemAtPoint:[self.longPress locationInView:self.longPress.view]];
    NSLog(@"sourceIndexPath = %@ -- destinationIndexPath = %@",sourceIndexPath,destinationIndexPath);
    //同组拖动
    if (destinationIndexPath.row < 5) {
        return;
    }
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.dataSource[0]];
    [arr exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
    [self.dataSource replaceObjectAtIndex:0 withObject:arr];
    [self.tagCollectionView reloadData];
}


@end
