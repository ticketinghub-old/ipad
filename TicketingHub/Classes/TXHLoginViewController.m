//
//  TXHLoginViewController.m
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHLoginViewController.h"

#import <iOS-api/iOS-api.h>
#import "TXHUserDefaultsKeys.h"

// The storyboard identifier for this controller
NSString * const LoginViewControllerStoryboardIdentifier = @"LoginViewController";

@interface TXHLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceToLogo;

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *email;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIcon;

@end

@implementation TXHLoginViewController

#pragma mark - Set up and tear down

- (void)awakeFromNib {
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.passwordIcon.image = [[UIImage imageNamed:@"right-arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.passwordIcon.tintColor = [UIColor colorWithRed:28.0f / 255.0f
                                                  green:60.0f / 255.0f
                                                   blue:54.0f / 255.0f
                                                  alpha:1.0f];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Register for keyboard notifications, so that we can reposition the entry fields to keep them visible
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    // Set up the user field with the last successfully logged on person
    NSString *lastUser = [[NSUserDefaults standardUserDefaults] stringForKey:TXHUserDefaultsLastUserKey];
    if (lastUser && [lastUser length] > 0) {
        self.userField.text = lastUser;
    } else {
        self.userField.text = @"";
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // Keyboard notifications.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Superclass overrides

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Notification Handlers

#pragma mark Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *keyboardAnimationDetail = [notification userInfo];
    UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{
        self.verticalSpaceToLogo.constant = 40.0f;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *keyboardAnimationDetail = [notification userInfo];
    UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{
        self.verticalSpaceToLogo.constant = 152.0f;
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - Private methods

- (void)loginCompleted {
    // Set the last user into the defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.userField.text forKey:TXHUserDefaultsLastUserKey];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Actions

- (IBAction)login:(id)sender {
    self.loginButton.enabled = NO;

    [self.ticketingHubClient fetchSuppliersForUsername:self.userField.text password:self.passwordField.text withCompletion:^(NSArray *suppliers, NSError *error) {
        if (error) {
            DLog(@"Unable to log in because: %@", error); // Caveman - needs to be refined.
            self.loginButton.enabled = YES;
            return;
        }

        [self loginCompleted];
    }];
}

- (IBAction)editingChanged:(id)sender {
    self.loginButton.enabled = ((self.userField.text.length > 0) && (self.passwordField.text.length > 0));
}


@end
