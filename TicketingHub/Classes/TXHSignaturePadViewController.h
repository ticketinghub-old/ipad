//
//  TXHSignaturePadViewController.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 19/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHSignaturePadViewController;

@protocol TXHSignaturePadViewControllerDelegate <NSObject>

- (void)txhSignaturePadViewController:(TXHSignaturePadViewController *)controller acceptSignatureWithImage:(UIImage *)image;
- (void)txhSignaturePadViewControllerShouldDismiss:(TXHSignaturePadViewController *)controller;

@end

@interface TXHSignaturePadViewController : UIViewController

@property (nonatomic, copy) NSString *totalPriceString;
@property (nonatomic, copy) NSString *ownerName;
@property (nonatomic, weak) id<TXHSignaturePadViewControllerDelegate> delegate;
@property (readonly, nonatomic, assign) NSString *SVGSignature;


@end
