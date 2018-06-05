//
//  LXVerticalTabPagerController.h
//  UniversallyFramework
//
//  Created by lxin on 2018/5/8.
//  Copyright © 2018年 lxin. All rights reserved.
//

#import "LXVerticalPagerController.h"

@class LXVerticalTabPagerController;

@protocol LXVerticalTabPagerControllerDelegate <NSObject>

@optional
// configre collectionview cell
- (void)pagerController:(LXVerticalTabPagerController *)pagerController configreCell:(UICollectionViewCell *)cell forItemTitle:(NSString *)title atIndexPath:(NSIndexPath *)indexPath;

// did select indexPath
- (void)pagerController:(LXVerticalTabPagerController *)pagerController didSelectAtIndexPath:(NSIndexPath *)indexPath;

// transition frome cell to cell with animated
- (void)pagerController:(LXVerticalTabPagerController *)pagerController transitionFromeCell:(UICollectionViewCell *)fromCell toCell:(UICollectionViewCell *)toCell animated:(BOOL)animated;

// transition frome cell to cell with progress
- (void)pagerController:(LXVerticalTabPagerController *)pagerController transitionFromeCell:(UICollectionViewCell *)fromCell toCell:(UICollectionViewCell *)toCell progress:(CGFloat)progress;

@end

@interface LXVerticalTabPagerController : LXVerticalPagerController

@property (nonatomic, weak) id<LXVerticalTabPagerControllerDelegate> tabDelegate;

// view ,don't change frame
@property (nonatomic, strong, readonly) UIView *pagerBarView; // pagerBarView height is contentTopEdging
@property (nonatomic, weak, readonly) UICollectionView *collectionViewBar;
@property (nonatomic, weak, readonly) UIView *progressView;
@property (nonatomic, assign) CGFloat collectionLayoutEdging; // collectionLayout left right edging
// progress view
@property (nonatomic, assign) CGFloat progressHeight;
@property (nonatomic, assign) CGFloat progressEdging; // if < 0 width + edge ,if >0 width - edge
@property (nonatomic, assign) CGFloat progressWidth; //if>0 progress width is equal,else progress width is cell width
// cell
@property (nonatomic, assign) CGFloat cellWidth; // if>0 cells width is equal,else if=0 cell will caculate all titles width
@property (nonatomic, assign) CGFloat cellSpacing; // cell space
@property (nonatomic, assign) CGFloat cellEdging;  // cell left right edge
//   animate duration
@property (nonatomic, assign) CGFloat animateDuration;
// text font
@property (nonatomic, strong) UIFont *normalTextFont;
@property (nonatomic, strong) UIFont *selectedTextFont;

@property (nonatomic, strong) NSArray *pagerTitleArr;
@property (nonatomic, assign, readonly) CGFloat pagerTitleWidth; // it works only pagerTitleArr had set.
@property (nonatomic, assign, readonly) CGFloat titleWidth; // it works only pagerTitleArr had set.
@property (nonatomic, assign) CGFloat collectionViewBarWidth;

- (void)registerPagerBarCellClass:(Class)cellClass isContainXib:(BOOL)isContainXib;
- (void)reloadDataWithUpdateContent;

@end
