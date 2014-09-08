//
//  TXHCouponSelectionVIewController.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 08/09/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHProductsManager;
@class TXHCouponSelectionViewController;

extern NSString * const TXHCouponCodeSelectedNotification;
extern NSString * const TXHSelectedCouponCodeKey;

@protocol TXHCouponSelectionViewControllerDelegate <NSObject>

- (void)txhCouponSelectionViewController:(TXHCouponSelectionViewController *)controller
                         didSelectCoupon:(TXHCoupon *)coupon;
@end

@interface TXHCouponSelectionViewController : UITableViewController

- (instancetype)initWithProductManager:(TXHProductsManager *)manager;

@property (nonatomic, weak) id<TXHCouponSelectionViewControllerDelegate> delegate;

@end
