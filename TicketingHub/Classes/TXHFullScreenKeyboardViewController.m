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

#define ANIMATION_DURATION 0.2

@interface TXHFullScreenKeyboardViewController ()

@property (nonatomic, assign) CGRect  customViewInitFrame;

@property (nonatomic, strong) UIView  *customView;
@property (nonatomic, strong) UIView  *customViewInitSuperview;

@property (nonatomic, strong) UIView *containerView;

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
        wself.containerView.height = wself.view.height - keyboardFrame.size.width;
        [wself.view layoutIfNeeded];
    }];
    
    [self setKeyboardWillHideAnimationBlock:^(CGRect keyboardFrame) {
        wself.containerView.frame = wself.view.bounds;
        [wself.view layoutIfNeeded];
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

- (UIView *)containerView
{
    if (!_containerView)
    {
        UIView *containerView = [[UIView alloc] initWithFrame:self.view.bounds];
        containerView.translatesAutoresizingMaskIntoConstraints = YES;
        containerView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:containerView];
        _containerView = containerView;
    }
    return _containerView;
}

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
                         [self setBeginEndBackgroundColor];
                         [self moveCustomViewToInitConvertedFrame];
                     }
                     completion:^(BOOL finished) {
                         [self addCustomViewToInitSuperview];
                         [self removeSelfFromViewHierarchy];
                         
                         if (completion)
                             completion();
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
    [self.customView removeConstraints:self.customView.constraints];

    [self.customView constrainToSize:self.customViewInitFrame.size];
    [self.customView centerInView:self.containerView];
    
    [self.view layoutIfNeeded];
}

- (void)moveCustomViewToInitFrame
{
    self.customView.frame = self.customViewInitFrame;
    [self.customViewInitSuperview layoutIfNeeded];
}

- (void)moveCustomViewToInitConvertedFrame
{
    self.customView.frame = [self customViewConvertedInitFrameFromSuperview];
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
    self.view.frame = topController.view.bounds;
    
    [topController addChildViewController:self];
    
    [self viewWillAppear:NO];
    [topController.view addSubview:self.view];
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
                        options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationCurveEaseIn
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
