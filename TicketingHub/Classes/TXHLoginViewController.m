//
//  TXHLoginViewController.m
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHLoginViewController.h"

#import "TXHUserDefaultsKeys.h"

// The storyboard identifier for this controller
NSString * const LoginViewControllerStoryboardIdentifier = @"LoginViewController";

// These are application / client specific constants
static NSString * const kClientId = @"ca99032b750f829630d8c9272bb9d3d6696b10f5bddfc34e4b7610eb772d28e7";
static NSString * const kClientSecret = @"f9ce1f4e1c74cc38707e15c0a4286975898fbaaf81e6ec900c71b8f4af62d09d";

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
    [userDefaults synchronize];

    [self.networkController fetchVenuesForCurrentUserWithCompletion:^(NSError *error) {
        if (error) {
            if ([[error domain] isEqualToString:TXHNetworkControllerErrorDomain]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription] message:[error localizedFailureReason] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
            } else {
                DLog(@"Unable to fetch venues because: %@", error); // Caveman - needs to be refined.
            }

            return; // Bail on error.
        }

        // Success, the network controller handles the new object in the managed object context
        [self dismissViewControllerAnimated:YES completion:nil];

    }];
}

#pragma mark Actions

- (IBAction)login:(id)sender {
    self.loginButton.enabled = NO;

    [self.networkController loginWithUsername:self.userField.text password:self.passwordField.text completion:^(NSError *error) {
        if (error) {
            DLog(@"Unable to log in because: %@", error); // Caveman - needs to be refined.
            return;
        }
        [self loginCompleted];
    }];
}

- (IBAction)editingChanged:(id)sender {
    self.loginButton.enabled = ((self.userField.text.length > 0) && (self.passwordField.text.length > 0));
}


@end
