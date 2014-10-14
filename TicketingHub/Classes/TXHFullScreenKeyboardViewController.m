//
//  TXHFullScreenKeyboardViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 16/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHFullScreenKeyboardViewController.h"

#import "UIApplication+TopViewController.h"
#import <UIViewController+BHTKeyboardAnimationBlocks/UIViewController+BHTKeyboardNotifications.h>
#import <UIView-Autolayout/UIView+AutoLayout.h>
#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "TXHCGRectHelpers.h"


#define ANIMATION_DURATION 0.2

@interface TXHFullScreenKeyboardViewController ()

@property (nonatomic, assign) CGRect  customViewInitFrame;

@property (nonatomic, strong) UIView  *customView;
@property (nonatomic, strong) UIView  *customViewInitSuperview;

@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *containerBottomConstraint;

@end

@implementation TXHFullScreenKeyboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupKeyboardActions];
    [self addTapGestureRecognizer];
    
    [self setBeginEndBackgroundColor];
}

- (void)setupKeyboardActions
{
    __weak typeof(self) wself = self;
    
    [self setKeyboardWillShowAnimationBlock:^(CGRect keyboardFrame) {
        wself.containerBottomConstraint.constant = NormalizeKeyboardFrameRect(keyboardFrame).size.height;
        [wself.view layoutIfNeeded];
    }];
    
    [self setKeyboardWillHideAnimationBlock:^(CGRect keyboardFrame) {
        wself.containerBottomConstraint.constant = 0;
        [wself.view layoutIfNeeded];
    }];
    
    [self setKeyboardDidHideActionBlock:^(CGRect keyboardFrame) {
        [wself.delegate txhFullScreenKeyboardViewControllerDismiss:wself];
    }];
}

- (void)addTapGestureRecognizer
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)tapRecognized:(UITapGestureRecognizer *)recognizer
{
    if ([self.delegate respondsToSelector:@selector(txhFullScreenKeyboardViewControllerDismiss:)])
        [self.delegate txhFullScreenKeyboardViewControllerDismiss:self];
    else
        [self hideAniamted:YES completion:nil];
}

#pragma mark - Accessors

- (void)setCustomView:(UIView *)customView
{
    _customView = customView;
    
    self.customViewInitFrame       = customView.frame;
    self.customViewInitSuperview   = customView.superview;
}

- (UIColor *)destinationBackgroundColor
{
    if (_destinationBackgroundColor)
        return _destinationBackgroundColor;
    
    return [UIColor whiteColor];
}

#pragma mark - Public


- (void)showWithView:(UIView *)view completion:(void(^)(void))completion;
{
    self.customView = view;
    
    [self addSelfToViewHierarchy];
    [self addCustomViewWithCompletion:completion];
}

- (void)hideAniamted:(BOOL)aniamted completion:(void(^)(void))completion;
{
    [self.customView resignFirstResponder];
    
    if (aniamted)
    {
        [UIView animateWithDuration:ANIMATION_DURATION
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self moveCustomViewToInitConvertedFrame];
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:ANIMATION_DURATION
                                                   delay:0.0
                                                 options:UIViewAnimationOptionBeginFromCurrentState
                                              animations:^{
                                                  [self setBeginEndBackgroundColor];
                                              }
                                              completion:^(BOOL finished2) {
                                                  
                                                  [self addCustomViewToInitSuperview];
                                                  [self removeSelfFromViewHierarchy];
                                                  
                                                  if (completion)
                                                      completion();
                                                  
                                              }];
                         }];
    }
    else
    {
        [self addCustomViewToInitSuperview];
        [self removeSelfFromViewHierarchy];
        
        if (completion)
            completion();
    }
}

- (void)moveCustomViewToContainterCenter
{
    [self.customView removeFromSuperview]; // removing constraints
    [self.containerView addSubview:self.customView];
    
    [self.customView constrainToSize:self.customViewInitFrame.size];
    [self.customView centerInView:self.containerView];
    
    [self.view layoutIfNeeded];
}

- (void)moveCustomViewToInitFrame
{
    [self.customView constrainToSize:self.customViewInitFrame.size];
    [self.customView pinToSuperviewEdges:JRTViewPinTopEdge inset:self.customViewInitFrame.origin.y];
    [self.customView pinToSuperviewEdges:JRTViewPinLeftEdge inset:self.customViewInitFrame.origin.x];

    [self.customViewInitSuperview layoutIfNeeded];
}

- (void)moveCustomViewToInitConvertedFrame
{
    CGRect targetFrame = [self customViewConvertedInitFrameFromSuperview];
    
    [self.customView constrainToSize:targetFrame.size];
    
    [self.customView pinToSuperviewEdges:JRTViewPinTopEdge inset:targetFrame.origin.y];
    [self.customView pinToSuperviewEdges:JRTViewPinLeftEdge inset:targetFrame.origin.x];
    
    [self.view layoutIfNeeded];
}

- (CGRect)customViewConvertedInitFrameFromSuperview
{
    return [self.customViewInitSuperview convertRect:self.customViewInitFrame
                                              toView:self.containerView];
}


- (void)addCustomViewToInitSuperview
{
    [self.customView removeFromSuperview];
    [self.customViewInitSuperview addSubview:self.customView];
    
    [self moveCustomViewToInitFrame];
}

- (void)addCustomViewFromInitSuperview
{
    [self.customView removeFromSuperview];
    [self.containerView addSubview:self.customView];
    
    [self moveCustomViewToInitConvertedFrame];
}

- (void)addSelfToViewHierarchy
{
    UIViewController *topController = [[UIApplication sharedApplication] topViewController];
    
    [topController addChildViewController:self];
    [self viewWillAppear:NO];
    [topController.view addSubview:self.view];
    [self.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self.view layoutIfNeeded];
    [self viewDidAppear:NO];

    [self didMoveToParentViewController:topController];
}

- (void)removeSelfFromViewHierarchy
{
    [self willMoveToParentViewController:nil];
    [self viewWillDisappear:NO];
    [self.view removeFromSuperview];
    [self viewDidDisappear:NO];
    [self removeFromParentViewController];
}

- (void)addCustomViewWithCompletion:(void(^)(void))completion;
{
    [self addCustomViewFromInitSuperview];
    
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:0.0
                        options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self moveCustomViewToContainterCenter];
                         [self setDestinationBackgroundColor];
                     }
                     completion:^(BOOL finished) {
                         if (completion)
                             completion();
                     }];
}

- (void)setBeginEndBackgroundColor
{
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)setDestinationBackgroundColor
{
    self.view.backgroundColor = self.destinationBackgroundColor;
}


@end
