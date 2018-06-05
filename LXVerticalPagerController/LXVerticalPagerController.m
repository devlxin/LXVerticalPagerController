//
//  LXVerticalPagerController.m
//  UniversallyFramework
//
//  Created by lxin on 2018/5/8.
//  Copyright © 2018年 lxin. All rights reserved.
//

#import "LXVerticalPagerController.h"

typedef NS_ENUM(NSUInteger, LXVerticalPagerDirection) {
    LXVerticalPagerDirectionUP,
    LXVerticalPagerDirectionDOWN
};

@interface LXVerticalPagerController ()  <UITableViewDataSource, UITableViewDelegate> {
    CGFloat _preOffsetY;
    NSInteger _preSection;
    
    struct {
        unsigned int transitionFromIndexToIndex :1;
        unsigned int transitionFromIndexToIndexProgress :1;
    }_methodFlags;
}

@end

@implementation LXVerticalPagerController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {}
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {}
    return self;
}

- (void)configureMethods {
    _methodFlags.transitionFromIndexToIndex = [self respondsToSelector:@selector(transitionFromIndex:toIndex:animated:)];
    _methodFlags.transitionFromIndexToIndexProgress = [self respondsToSelector:@selector(transitionFromIndex:toIndex:progress:)];
}

#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureMethods];
}

- (void)addContentView {
    if (!_contentView) {
        _contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contentTopEdging, self.view.frame.size.width, self.view.frame.size.height - self.contentTopEdging) style:UITableViewStyleGrouped];
        [_contentView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if (_contentViewBgColor) {
            [_contentView setBackgroundColor:_contentViewBgColor];
        }
        [_contentView setDataSource:self];
        [_contentView setDelegate:self];
    }
    [self.view addSubview:_contentView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutContentViewIfNeed];
}

// if need layout contentView
- (void)layoutContentViewIfNeed {
    if (!CGSizeEqualToSize(_contentView.frame.size, CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - _contentTopEdging - [self statusBarHeight]))) {
        // size changed
        [self updateContentView];
    }
}

// override must call super , update contentView subviews frame
- (void)updateContentView {
    [self reSizeContentView];
}

// change content View size
- (void)reSizeContentView {
    CGFloat contentTopEdging = _contentTopEdging;
    _contentView.frame = CGRectMake(0, contentTopEdging, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - contentTopEdging);
}

#pragma mark - public method
- (void)reloadData {
    [_contentView reloadData];
    [self scrollViewDidScroll:_contentView];
}

- (void)registerCellClass:(Class)cellClass isContainXib:(BOOL)isContainXib {
    [self addContentView];
    
    NSString *cellId = NSStringFromClass(cellClass);
    if (isContainXib) {
        UINib *nib = [UINib nibWithNibName:cellId bundle:nil];
        [_contentView registerNib:nib forCellReuseIdentifier:cellId];
    }else {
        [_contentView registerClass:cellClass forCellReuseIdentifier:cellId];
    }
}

- (NSInteger)statusBarHeight {
    CGSize result = [[UIScreen mainScreen] bounds].size;
    result = CGSizeMake(result.width * [UIScreen mainScreen].scale, result.height * [UIScreen mainScreen].scale);
    return (_adjustStatusBarHeight && (!self.navigationController || self.navigationController.isNavigationBarHidden) && [[[UIDevice currentDevice] systemVersion] floatValue] >= 7) ? (((result.height > 2208.f) ? 24 : 0)+20):0;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.dataSource numberOfSectionsInTableView:tableView];
    }
    return INT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        return [self.dataSource tableView:tableView numberOfRowsInSection:section];
    }
    return INT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        return [self.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [self.delegate tableView:tableView heightForHeaderInSection:section];
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:) ]) {
        return [self.delegate tableView:tableView heightForFooterInSection:section];
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
       return  [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [self.delegate tableView:tableView viewForHeaderInSection:section];
    }
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [self.delegate tableView:tableView viewForFooterInSection:section];
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row && (indexPath.section == [self numberOfSectionsInTableView:tableView] - 1)) {
        // end of loading
        CGRect theLastSectionRect = [tableView rectForSection:indexPath.section];
        [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - theLastSectionRect.size.height - self.contentTopEdging)]];
    }
} 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _contentView && scrollView.contentOffset.y >= 0) {
        //  caculate scroll progress
//        [self configurePagerIndexByProgress];
        // caculate scroll index
        [self configurePagerIndex];
    }
}

// caculate pager index
- (void)configurePagerIndex {
//    if ([_contentView indexPathForRowAtPoint:_contentView.contentOffset] == nil) {
//        _preSection = 0;
//        _curIndex = 0;
//        return;
//    }
    NSInteger index = [_contentView indexPathForRowAtPoint:_contentView.contentOffset].section;
    
    if (index < 0) {
        index = 0;
    }else if (index >= [self numberOfSectionsInTableView:_contentView]) {
        index = [self numberOfSectionsInTableView:_contentView] - 1;
    }
    
    NSLog(@"%ld--%ld", _preSection, index);
    
    // if index not same,change index
    if (index != _preSection) {
        NSInteger fromIndex = _preSection;
        if (_methodFlags.transitionFromIndexToIndex) {
            [self transitionFromIndex:fromIndex toIndex:index animated:YES];
        }
    }
    
    _preSection = index;
    _curIndex = index;
    
    // if index not same,change index
//    if (index != _curIndex) {
//    }
}

// caculate pager index and progress
- (void)configurePagerIndexByProgress {
    CGFloat offsetY = _contentView.contentOffset.y;
    CGFloat floorIndex = [_contentView indexPathForRowAtPoint:_contentView.contentOffset].section;
    CGRect floorRect = [_contentView rectForSection:floorIndex];
    CGFloat progress = offsetY / floorRect.size.height - floorIndex;
    
    LXVerticalPagerDirection direction = offsetY >= _preOffsetY ? LXVerticalPagerDirectionDOWN : LXVerticalPagerDirectionUP;
    NSInteger fromIndex = 0, toIndex = 0;
    if (direction == LXVerticalPagerDirectionDOWN) {
        if (floorIndex >= [self numberOfSectionsInTableView:_contentView]) {
            return;
        }
        fromIndex = floorIndex;
        toIndex = MIN([self numberOfSectionsInTableView:_contentView]-1, fromIndex + 1);
    }else {
        toIndex = floorIndex;
        fromIndex = MIN([self numberOfSectionsInTableView:_contentView]-1, toIndex +1);
        progress = 1.0 - progress;
    }
    if (_methodFlags.transitionFromIndexToIndexProgress) {
        [self transitionFromIndex:fromIndex toIndex:toIndex progress:progress];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == _contentView) {
        // save offsetY ,judge scroll direction
        _preOffsetY = _contentView.contentOffset.y;
//        _preSection = [_contentView indexPathForRowAtPoint:_contentView.contentOffset].section;
    }
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
