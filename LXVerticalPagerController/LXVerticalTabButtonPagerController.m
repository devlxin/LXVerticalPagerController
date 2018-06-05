//
//  LXVerticalTabButtonPagerController.m
//  UniversallyFramework
//
//  Created by lxin on 2018/5/9.
//  Copyright © 2018年 CDITV. All rights reserved.
//

#import "LXVerticalTabButtonPagerController.h"
#import "LXTabTitleViewCell.h"

@interface LXVerticalTabButtonPagerController () <LXVerticalTabPagerControllerDelegate>

@property (nonatomic, assign) CGFloat selectFontScale;

@end

#define kUnderLineViewHeight 2

@implementation LXVerticalTabButtonPagerController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configureTabButtonPropertys];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self configureTabButtonPropertys];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _selectFontScale = self.normalTextFont.pointSize/self.selectedTextFont.pointSize;
    
    self.tabDelegate = self;
        
    [self configureSubViews];
}

- (void)configureSubViews {
    // progress
    self.progressView.backgroundColor = _progressColor;
    self.progressView.layer.cornerRadius = _progressRadius;
    self.progressView.layer.masksToBounds = YES;
    
    // tabBar
    self.pagerBarView.backgroundColor = _pagerBarColor;
    self.collectionViewBar.backgroundColor = _collectionViewBarColor;
}

- (void)configureTabButtonPropertys {
    self.cellSpacing = 2;
    self.cellEdging = 3;
    
    self.progressWidth = 0;
    self.progressHeight = kUnderLineViewHeight;
    self.progressEdging = 3;
    self.progressColor = [UIColor redColor];
    self.progressRadius = self.progressHeight/2;
    
    _normalTextColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    _selectedTextColor = [UIColor redColor];
    
    _pagerBarColor = [UIColor whiteColor];
    _collectionViewBarColor = [UIColor clearColor];
    
    _progressColor = [UIColor redColor];
    _progressRadius = self.progressHeight/2;
    
    [self registerPagerBarCellClass:[LXTabTitleViewCell class] isContainXib:NO];
}

#pragma mark - private
- (void)transitionFromCell:(UICollectionViewCell<LXTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<LXTabTitleCellProtocol> *)toCell {
    if (fromCell) {
        fromCell.titleLabel.textColor = self.normalTextColor;
        fromCell.transform = CGAffineTransformMakeScale(self.selectFontScale, self.selectFontScale);
    }
    
    if (toCell) {
        toCell.titleLabel.textColor = self.selectedTextColor;
        toCell.transform = CGAffineTransformIdentity;
    }
}

- (void)transitionFromCell:(UICollectionViewCell<LXTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<LXTabTitleCellProtocol> *)toCell progress:(CGFloat)progress {
    CGFloat currentTransform = (1.0 - self.selectFontScale)*progress;
    fromCell.transform = CGAffineTransformMakeScale(1.0-currentTransform, 1.0-currentTransform);
    toCell.transform = CGAffineTransformMakeScale(self.selectFontScale+currentTransform, self.selectFontScale+currentTransform);
    
    CGFloat narR,narG,narB,narA;
    [self.normalTextColor getRed:&narR green:&narG blue:&narB alpha:&narA];
    CGFloat selR,selG,selB,selA;
    [self.selectedTextColor getRed:&selR green:&selG blue:&selB alpha:&selA];
    CGFloat detalR = narR - selR ,detalG = narG - selG,detalB = narB - selB,detalA = narA - selA;
    
    fromCell.titleLabel.textColor = [UIColor colorWithRed:selR+detalR*progress green:selG+detalG*progress blue:selB+detalB*progress alpha:selA+detalA*progress];
    toCell.titleLabel.textColor = [UIColor colorWithRed:narR-detalR*progress green:narG-detalG*progress blue:narB-detalB*progress alpha:narA-detalA*progress];
}

#pragma mark - TYTabPagerControllerDelegate
- (void)pagerController:(LXVerticalTabPagerController *)pagerController configreCell:(LXTabTitleViewCell *)cell forItemTitle:(NSString *)title atIndexPath:(NSIndexPath *)indexPath {
    LXTabTitleViewCell *titleCell = (LXTabTitleViewCell *)cell;
    titleCell.titleLabel.text = title;
    titleCell.titleLabel.font = self.selectedTextFont;
}

- (void)pagerController:(LXVerticalTabPagerController *)pagerController transitionFromeCell:(UICollectionViewCell<LXTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<LXTabTitleCellProtocol> *)toCell animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:self.animateDuration animations:^{
            [self transitionFromCell:(LXTabTitleViewCell *)fromCell toCell:(LXTabTitleViewCell *)toCell];
        }];
    }else{
        [self transitionFromCell:fromCell toCell:toCell];
    }
}

- (void)pagerController:(LXVerticalTabPagerController *)pagerController transitionFromeCell:(UICollectionViewCell<LXTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<LXTabTitleCellProtocol> *)toCell progress:(CGFloat)progress {
    [self transitionFromCell:fromCell toCell:toCell progress:progress];
}

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
