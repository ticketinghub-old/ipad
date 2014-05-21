//
//  TXHFullScreenKeyboardViewController.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 16/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TXHFullScreenKeyboardViewController;

@protocol TXHFullScreenKeyboardViewControllerDelegate <NSObject>

@optional
- (void)txhFullScreenKeyboardViewControllerDismiss:(TXHFullScreenKeyboardViewController *)controller;

@end

@interface TXHFullScreenKeyboardViewController : UIViewController

@property (nonatomic, strong) UIColor *destinationBackgroundColor;
@property (nonatomic, weak) id<TXHFullScreenKeyboardViewControllerDelegate> delegate;

- (void)showWithView:(UIView *)view completion:(void(^)(void))completion;
- (void)hideAniamted:(BOOL)aniamted completion:(void(^)(void))completion;

@end
