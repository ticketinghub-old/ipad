//
//  TXHCouponSelectionVIewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 08/09/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHCouponSelectionViewController.h"
#import "TXHProductsManager.h"
#import "TXHCoupon+Helpers.h"

#import "ArrayDataSource.h"

#import "UIColor+TicketingHub.h"
#import "UIFont+TicketingHub.h"
#import "TXHActivityLabelView.h"

#import "TXHCoupon+Empty.h"

NSString * const TXHCouponCodeSelectedNotification = @"TXHCouponCodeSelectedNotification";
NSString * const TXHSelectedCouponCodeKey          = @"TXHSelectedCouponCodeKey";

@interface TXHCouponSelectionViewController ()

@property (nonatomic, strong) NSArray *coupons;
@property (nonatomic, strong) ArrayDataSource *datasource;
@property (nonatomic, strong) TXHProductsManager *productsManager;
@property (nonatomic, weak)   TXHActivityLabelView *activityView;

@end

@implementation TXHCouponSelectionViewController

- (instancetype)initWithProductManager:(TXHProductsManager *)manager;
{
    if (!manager || !(self = [super init]))
        return nil;
    
    self.productsManager = manager;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"printerCell"];
    self.tableView.delegate = self;
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    
    [self loadCoupons];
}

- (TXHActivityLabelView *)activityView
{
    if (!_activityView)
        _activityView = [TXHActivityLabelView getInstanceInView:self.view];
    
    return _activityView;
}

- (void)loadCoupons
{
    __weak typeof(self) wself = self;
    [self.activityView showWithMessage:nil indicatorHidden:NO];
    [self.productsManager getCouponCodesCompletion:^(NSArray *coupons, NSError *error) {
        
        NSMutableArray *array = coupons.mutableCopy;
        [array insertObject:[TXHCoupon emptyCoupon] atIndex:0];
        
        wself.coupons = array.copy;
        [wself.activityView hide];
    }];
}

- (void)setCoupons:(NSArray *)coupons
{
    _coupons = coupons;
    
    self.datasource = [[ArrayDataSource alloc] initWithItems:coupons
                                              cellIdentifier:@"printerCell"
                                          configureCellBlock:^(id cell, id item) {
                                              UITableViewCell *aCell = (UITableViewCell *)cell;
                                              aCell.textLabel.textAlignment = NSTextAlignmentCenter;
                                              aCell.textLabel.font = [UIFont txhThinFontWithSize:20.0];
                                              
                                              TXHCoupon *coupon = (TXHCoupon *)item;
                                              aCell.textLabel.text = coupon.code;
                            
                                              aCell.textLabel.textColor = [coupon disabled] ? [UIColor lightGrayColor] : [UIColor txhDarkBlueColor];
                                              aCell.selectionStyle      = [coupon disabled] ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
                                          }];
    
    [self.tableView reloadData];
}

- (void)setDatasource:(ArrayDataSource *)datasource
{
    _datasource = datasource;
    
    self.tableView.dataSource = datasource;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TXHCoupon *coupon = (TXHCoupon *)[self.datasource itemAtIndexPath:indexPath];
    
    if ([coupon disabled])
        return;
    
    if ([coupon isEmpty])
        coupon = nil;
    
    NSDictionary *userInfo;
    if (coupon)
        userInfo = @{TXHSelectedCouponCodeKey : coupon};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TXHCouponCodeSelectedNotification
                                                        object:self
                                                      userInfo:userInfo];
    
    [self.delegate txhCouponSelectionViewController:self
                                    didSelectCoupon:coupon];
}

@end
