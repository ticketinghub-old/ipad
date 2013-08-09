//
//  TXHLoginViewController.m
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHLoginViewController.h"

#import "TXHCommonNames.h"
#import "TXHMenuViewController.h"
#import "TXHServerAccessManager.h"
#import "UIView+TXHAnimationConversions.h"
#import "TXHUserDefaultsKeys.h"

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

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder])) {
        return nil; // Bail!
    }

    // Set the status bar style to be light since we have a dark background
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.email.image = [[UIImage imageNamed:@"mail"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.email.tintColor = [UIColor colorWithRed:77.0f / 255.0f
                                           green:134.0f / 255.0f
                                            blue:180.0f / 255.0f
                                           alpha:1.0f];

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
    UIViewAnimationOptions options = [UIView txhAnimationOptionsFromAnimationCurve:animationCurve];
    // Beta 4 had issues with the animation options, so fixed at the moment
    options = UIViewAnimationOptionCurveEaseInOut;
    CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.verticalSpaceToLogo.constant = 40.0f;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *keyboardAnimationDetail = [notification userInfo];
    UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    UIViewAnimationOptions options = [UIView txhAnimationOptionsFromAnimationCurve:animationCurve];
    // Beta 4 had issues with the animation options, so fixed at the moment
    options = UIViewAnimationOptionCurveEaseInOut;
    CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.verticalSpaceToLogo.constant = 184.0f;
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - Private methods

- (void)loginCompleted {
    // Set the last user into the defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.userField.text forKey:TXHUserDefaultsLastUserKey];
    [userDefaults synchronize];

    // We successfully logged in, so get a list of venues for this user
    [[TXHServerAccessManager sharedInstance] getVenuesWithCompletionHandler:^(NSArray *venues){
        [self gotVenues:venues];
    }
                                                               errorHandler:^(id reason){[self loginFailed:reason];}];
}

- (void)gotVenues:(NSArray *)venues {
    // If there are no venues, display a message to the user and do not leave the login page
    if (venues.count == 0) {
        // Warn user that they cannot proceed
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Venues" message:@"You do not have access to any venues." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //    [alert setaccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tickethub"]]];
        [alert show];
    } else {
        // Notify any interested parties that the username has been set
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MENU_LOGIN object:self.userField.text];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)loginFailed:(id)reason {
    NSError *error = reason;
    NSLog(@"ERROR:%@", error.userInfo.description);
}

#pragma mark Actions

- (IBAction)login:(id)sender {
    self.loginButton.enabled = NO;
    [[TXHServerAccessManager sharedInstance] generateAccessTokenFor:self.userField.text
                                                           password:self.passwordField.text
                                                         completion:^{[self loginCompleted];}
                                                              error:^(id reason){[self loginFailed:reason];}];
}

- (IBAction)editingChanged:(id)sender {
    self.loginButton.enabled = ((self.userField.text.length > 0) && (self.passwordField.text.length > 0));
}


@end
