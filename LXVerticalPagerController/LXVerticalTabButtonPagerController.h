//
//  LXVerticalTabButtonPagerController.h
//  UniversallyFramework
//
//  Created by lxin on 2018/5/9.
//  Copyright © 2018年 CDITV. All rights reserved.
//

#import "LXVerticalTabPagerController.h"

@interface LXVerticalTabButtonPagerController : LXVerticalTabPagerController

// pagerBar color
@property (nonatomic, strong) UIColor *pagerBarColor;
@property (nonatomic, strong) UIColor *collectionViewBarColor;

// progress view
@property (nonatomic, assign) CGFloat progressRadius;
@property (nonatomic, strong) UIColor *progressColor;

// text color
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@end
