//
//  LXTabTitleViewCell.h
//  UniversallyFramework
//
//  Created by lxin on 2018/5/9.
//  Copyright © 2018年 lxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXTabTitleCellProtocol.h"

@interface LXTabTitleViewCell : UICollectionViewCell<LXTabTitleCellProtocol>

@property (nonatomic, weak,readonly) UILabel *titleLabel;

@end
