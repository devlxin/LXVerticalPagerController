//
//  LXVerticalTabPagerController.m
//  UniversallyFramework
//
//  Created by lxin on 2018/5/8.
//  Copyright © 2018年 CDITV. All rights reserved.
//

#import "LXVerticalTabPagerController.h"

#define kCollectionViewBarHieght 36
#define kUnderLineViewHeight 2

@interface LXVerticalTabPagerController ()<UICollectionViewDataSource, UICollectionViewDelegate> {
    struct {
        unsigned int configreReusableCell :1;
        unsigned int didSelectAtIndexPath :1;
        unsigned int transitionFromeCellAnimated :1;
        unsigned int transitionFromeCellProgress :1;
    }_tabDelegateFlags;
}

// views
@property (nonatomic, strong) UIView *pagerBarView;
@property (nonatomic, weak) UICollectionView *collectionViewBar;
@property (nonatomic, weak) UIView *progressView;

@property (nonatomic, assign) Class cellClass;
@property (nonatomic, assign) BOOL cellContainXib;
@property (nonatomic, strong) NSString *cellId;

@end

@implementation LXVerticalTabPagerController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configireTabPropertys];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self configireTabPropertys];
    }
    return self;
}

- (void)configireTabPropertys {
    _animateDuration = 0.25;
    _normalTextFont = [UIFont systemFontOfSize:15];
    _selectedTextFont = [UIFont systemFontOfSize:18];
    _cellSpacing = 0;
    _cellEdging = 0;
    _progressHeight = kUnderLineViewHeight;
    _progressEdging = 0;
    _progressWidth = 0;
    self.contentTopEdging = kCollectionViewBarHieght;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPagerBarView];
    [self addCollectionViewBar];
    [self addUnderLineView];
}

- (void)reloadData {
    [_collectionViewBar reloadData];
    [super reloadData];
}

- (void)reloadDataWithUpdateContent {
    [self reloadData];
    [self updateContentView];
}

- (void)updateContentView {
    [super updateContentView];
    
    [self setUnderLineFrameWithIndex:0 animated:NO];
    [self tabScrollToIndex:0 animated:NO];
}

- (void)addPagerBarView {
    UIView *pagerBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), self.contentTopEdging)];
    [self.view addSubview:pagerBarView];
    _pagerBarView = pagerBarView;
}

- (void)addCollectionViewBar {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    layout.minimumLineSpacing = _cellSpacing;
    layout.minimumInteritemSpacing = _cellSpacing;
    CGFloat collectionViewEaging = _collectionLayoutEdging > 0 ? _collectionLayoutEdging : -_progressEdging+_cellSpacing;
    layout.sectionInset = UIEdgeInsetsMake(0, collectionViewEaging, 0, collectionViewEaging);
    
    UICollectionView *collectionView = nil;
    if (_collectionViewBarWidth != 0) {
        collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - _collectionViewBarWidth) / 2, [self statusBarHeight], _collectionViewBarWidth, self.contentTopEdging - [self statusBarHeight]) collectionViewLayout:layout];
    } else {
        collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, [self statusBarHeight], CGRectGetWidth(self.view.frame), self.contentTopEdging - [self statusBarHeight]) collectionViewLayout:layout];
    }
    
//    [self layoutTabPagerView];
    
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.tag = 111;
    
    if ((_pagerTitleWidth <= (_collectionViewBarWidth != 0 ? _collectionViewBarWidth : [UIScreen mainScreen].bounds.size.width)) && _cellWidth == 0) {
        if (_collectionViewBarWidth != 0) {
            [layout setHeaderReferenceSize:CGSizeMake((_collectionViewBarWidth - _pagerTitleWidth) / 2.0, self.contentTopEdging - [self statusBarHeight])];
            [layout setFooterReferenceSize:CGSizeMake((_collectionViewBarWidth - _pagerTitleWidth) / 2.0, self.contentTopEdging - [self statusBarHeight])];
            [collectionView registerClass:[UIView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
            [collectionView registerClass:[UIView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"footer"];
            
            [collectionView setContentInset:UIEdgeInsetsMake(0, 3, 0, 0)];
        } else {
//            [layout setHeaderReferenceSize:CGSizeMake(self.cellSpacing, self.contentTopEdging - [self statusBarHeight])];
            //                [layout setFooterReferenceSize:CGSizeMake(self.cellSpacing - _cellEdging * 2, self.contentTopEdging - [self statusBarHeight])];
//            [collectionView registerClass:[UIView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
            //                [collectionView registerClass:[UIView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"footer"];
            //                [collectionView setContentInset:UIEdgeInsetsMake(0, 3, 0, 0)];
        }
        [collectionView setScrollEnabled:NO];
    }
    [_pagerBarView addSubview:collectionView];
    _collectionViewBar = collectionView;
    
    if (_cellContainXib) {
        UINib *nib = [UINib nibWithNibName:_cellId bundle:nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:_cellId];
    }else {
        [collectionView registerClass:_cellClass forCellWithReuseIdentifier:_cellId];
    }
}

- (void)addUnderLineView {
    UIView *underLineView = [[UIView alloc]init];
    [_collectionViewBar addSubview:underLineView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentTopEdging + [self statusBarHeight] - (SCREEN_IS_3X ? 0.3 : 0.5), SCREEN_WIDTH, SCREEN_IS_3X ? 0.3 : 0.5)];
    [line setBackgroundColor:COLOR_WITH_RGB(210, 210, 210, 1)];
    [self.pagerBarView addSubview:line];
    
    _progressView = underLineView;
}

- (void)setPagerTitleArr:(NSArray *)pagerTitleArr {
    _pagerTitleArr = pagerTitleArr;
    __block CGFloat pagerWidth = 0;
    __block CGFloat titleWidth = 0;
    [_pagerTitleArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        pagerWidth += [self getTextWidth:obj height:36 font:_normalTextFont];
        pagerWidth += _cellEdging * 2;
        pagerWidth += _cellSpacing;
        pagerWidth += 4;
        
        titleWidth += [self getTextWidth:obj height:36 font:_normalTextFont];;
        titleWidth += _cellEdging * 2;
        titleWidth += 4;
    }];
    pagerWidth -= _cellSpacing;
    _pagerTitleWidth = pagerWidth;
    _titleWidth = titleWidth;
}

- (int)getTextWidth:(NSString *)str height:(CGFloat)height font:(UIFont *)font {
    int width=[ViewTool widthNSString:str height:height font:font];
    return width;
}

- (void)registerPagerBarCellClass:(Class)cellClass isContainXib:(BOOL)isContainXib {
    _cellClass = cellClass;
    _cellId = NSStringFromClass(cellClass);
    _cellContainXib = isContainXib;
}

- (void)setTabDelegate:(id<LXVerticalTabPagerControllerDelegate>)tabDelegate {
    _tabDelegate = tabDelegate;
    _tabDelegateFlags.configreReusableCell = [self.tabDelegate respondsToSelector:@selector(pagerController:configreCell:forItemTitle:atIndexPath:)];
    _tabDelegateFlags.didSelectAtIndexPath = [self.tabDelegate respondsToSelector:@selector(pagerController:didSelectAtIndexPath:)];
    _tabDelegateFlags.transitionFromeCellAnimated = [self.tabDelegate respondsToSelector:@selector(pagerController:transitionFromeCell:toCell:animated:)];
    _tabDelegateFlags.transitionFromeCellProgress = [self.tabDelegate respondsToSelector:@selector(pagerController:transitionFromeCell:toCell:progress:)];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pagerTitleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellId forIndexPath:indexPath];
    
    NSString *title = self.pagerTitleArr[indexPath.item];
    if (_tabDelegateFlags.configreReusableCell) {
        [self.tabDelegate pagerController:self configreCell:cell forItemTitle:title atIndexPath:indexPath];
    }
    if (_tabDelegateFlags.transitionFromeCellAnimated) {
        [self.tabDelegate pagerController:self transitionFromeCell:(indexPath.item == self.curIndex ? nil : cell) toCell:(indexPath.item == self.curIndex ? cell : nil) animated:NO];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect selectRect = [self.contentView rectForSection:indexPath.item];
    [self.contentView setContentOffset:CGPointMake(0, selectRect.origin.y) animated:NO];
    [self transitionFromIndex:self.curIndex toIndex:indexPath.item animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_cellWidth > 0) {
        return CGSizeMake(_cellWidth, CGRectGetHeight(_collectionViewBar.frame));
    }else if(_pagerTitleArr.count > 0){
        NSString *title = _pagerTitleArr[indexPath.item];
        CGFloat width = [self boundingSizeWithString:title font:_selectedTextFont constrainedToSize:CGSizeMake(300, 100)].width+_cellEdging*2;
        return CGSizeMake(width+4, CGRectGetHeight(_collectionViewBar.frame));
    }
    return CGSizeZero;
}

// text size
- (CGSize)boundingSizeWithString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)size {
    CGSize textSize = CGSizeZero;
#if (__IPHONE_OS_VERSION_MIN_REQUIRED && __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0)
    if (![string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // below ios7
        textSize = [string sizeWithFont:font
                      constrainedToSize:size
                          lineBreakMode:NSLineBreakByWordWrapping];
    }
    else
#endif
    {
        //iOS 7
        CGRect frame = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:font } context:nil];
        textSize = CGSizeMake(ceil(frame.size.width), ceil(frame.size.height) + 1);
    }
    return textSize;
}

#pragma mark - override transition
- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    UICollectionViewCell *fromCell = [self cellForIndex:fromIndex];
    UICollectionViewCell *toCell = [self cellForIndex:toIndex];
    
    // if isn't progressing
    if (_tabDelegateFlags.transitionFromeCellAnimated) {
        [self.tabDelegate pagerController:self transitionFromeCell:fromCell toCell:toCell animated:animated];
    }
    [self setUnderLineFrameWithIndex:toIndex animated:fromCell && animated ? animated: NO];
    [self tabScrollToIndex:toIndex animated:toCell ? YES : fromCell && animated ? animated: NO];
    [_collectionViewBar performSelector:@selector(reloadData) withObject:nil afterDelay:self.animateDuration];
}

- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress
{
    UICollectionViewCell *fromCell = [self cellForIndex:fromIndex];
    UICollectionViewCell *toCell = [self cellForIndex:toIndex];
    
    if (_tabDelegateFlags.transitionFromeCellProgress) {
        [self.tabDelegate pagerController:self transitionFromeCell:fromCell toCell:toCell progress:progress];
    }
    
    [self setUnderLineFrameWithfromIndex:fromIndex toIndex:toIndex progress:progress];
}

#pragma mark - private method
// layout tab view
//- (void)layoutTabPagerView {
//    ((UICollectionViewFlowLayout *)_collectionViewBar.collectionViewLayout).minimumLineSpacing = _cellSpacing;
//    ((UICollectionViewFlowLayout *)_collectionViewBar.collectionViewLayout).minimumInteritemSpacing = _cellSpacing;
//    CGFloat collectionViewEaging = _collectionLayoutEdging > 0 ? _collectionLayoutEdging : -_progressEdging+_cellSpacing;
//    ((UICollectionViewFlowLayout *)self.collectionViewBar.collectionViewLayout).sectionInset = UIEdgeInsetsMake(0, collectionViewEaging, 0, collectionViewEaging);
//}

- (UICollectionViewCell *)cellForIndex:(NSInteger)index {
    if (index >= self.pagerTitleArr.count) {
        return nil;
    }
    return [_collectionViewBar cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

- (CGRect)cellFrameWithIndex:(NSInteger)index {
    if (index >= self.pagerTitleArr.count) {
        return CGRectZero;
    }
    UICollectionViewLayoutAttributes * cellAttrs = [_collectionViewBar layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return cellAttrs.frame;
}

- (void)tabScrollToIndex:(NSInteger)index animated:(BOOL)animated {
    if (index < self.pagerTitleArr.count) {
        [_collectionViewBar scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    }
}

// set up progress view frame
- (void)setUnderLineFrameWithIndex:(NSInteger)index animated:(BOOL)animated {
    if (_progressView.isHidden || self.pagerTitleArr.count == 0) {
        return;
    }
    
    CGRect cellFrame = [self cellFrameWithIndex:index];
    CGFloat progressEdging = _progressWidth > 0 ? (cellFrame.size.width - _progressWidth)/2 : _progressEdging;
    CGFloat progressX = cellFrame.origin.x+progressEdging;
    CGFloat progressY = cellFrame.size.height - _progressHeight;
    CGFloat width = cellFrame.size.width-2*progressEdging;
    
    if (animated) {
        [UIView animateWithDuration:_animateDuration animations:^{
            _progressView.frame = CGRectMake(progressX, progressY, width, _progressHeight);
        }];
    }else {
        _progressView.frame = CGRectMake(progressX, progressY, width, _progressHeight);
    }
}

- (void)setUnderLineFrameWithfromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    if (_progressView.isHidden || self.pagerTitleArr.count == 0) {
        return;
    }
    
    CGRect fromCellFrame = [self cellFrameWithIndex:fromIndex];
    CGRect toCellFrame = [self cellFrameWithIndex:toIndex];
    
    CGFloat progressFromEdging = _progressWidth > 0 ? (fromCellFrame.size.width - _progressWidth)/2 : _progressEdging;
    CGFloat progressToEdging = _progressWidth > 0 ? (toCellFrame.size.width - _progressWidth)/2 : _progressEdging;
    CGFloat progressY = toCellFrame.size.height - _progressHeight;
    CGFloat progressX, width;
    
    progressX = (toCellFrame.origin.x+progressToEdging-(fromCellFrame.origin.x+progressFromEdging))*progress+fromCellFrame.origin.x+progressFromEdging;
    width = (toCellFrame.size.width-2*progressToEdging)*progress + (fromCellFrame.size.width-2*progressFromEdging)*(1-progress);
    
    _progressView.frame = CGRectMake(progressX,progressY, width, _progressHeight);
}

#pragma mark - life cycle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
