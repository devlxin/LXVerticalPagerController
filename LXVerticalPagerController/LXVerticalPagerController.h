//
//  LXVerticalPagerController.h
//  UniversallyFramework
//
//  Created by lxin on 2018/5/8.
//  Copyright © 2018年 lxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LXVerticalPagerControllerDataSource <UITableViewDataSource>

@required
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol LXVerticalPagerControllerDelegate <UITableViewDelegate>

@required
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

/**
 垂直列表TabPagerController
 */
@interface LXVerticalPagerController : UIViewController

@property (nonatomic, weak) id<LXVerticalPagerControllerDataSource> dataSource;
@property (nonatomic, weak) id<LXVerticalPagerControllerDelegate> delegate;

@property (nonatomic, strong, readonly) UITableView *contentView;
@property (nonatomic, strong) UIColor *contentViewBgColor;

@property (nonatomic, assign) CGFloat contentTopEdging;
@property (nonatomic, assign) BOOL adjustStatusBarHeight;

@property (nonatomic, assign, readonly) NSInteger curIndex;

- (void)registerCellClass:(Class)cellClass isContainXib:(BOOL)isContainXib;
- (void)reloadData;

- (NSInteger)statusBarHeight;

// override must call super , update contentView subviews frame
- (void)updateContentView;

@end

@interface LXVerticalPagerController (TransitionOverride)

// subclass override
- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated;
- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;

@end
