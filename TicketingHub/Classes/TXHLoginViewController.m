//
//  TXHLoginViewController.m
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHLoginViewController.h"

#import "TXHTicketingHubManager.h"
#import "TXHUserDefaultsKeys.h"

#import <UIView+Shake/UIView+Shake.h>
#import "UIColor+TicketingHub.h"

// The storyboard identifier for this controller
NSString * const LoginViewControllerStoryboardIdentifier = @"LoginViewController";

@interface TXHLoginViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalLogoConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTofieldsContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailXAlignmentConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordXAllignmentConstraint;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIImageView *email;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIcon;
@property (weak, nonatomic) IBOutlet UIView *fieldsContainerView;

@end

@implementation TXHLoginViewController

#pragma mark - Set up and tear down

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.passwordIcon.image = [[UIImage imageNamed:@"right-arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.passwordIcon.tintColor = [UIColor txhBlueColor];
    
    [self updateFieldsConstraintsToOffScreen];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
    [self setLastLoggedInUser];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self unregisterForKeyboardNotifications];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:2
          initialSpringVelocity:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self  updateFieldsConstraintsToCenter];
                     } completion:nil];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)updateFieldsConstraintsToOffScreen
{
    self.emailXAlignmentConstrain.constant      = -self.view.width;
    self.passwordXAllignmentConstraint.constant = self.view.width;
    [self.view layoutIfNeeded];
}

- (void)updateFieldsConstraintsToCenter
{
    self.emailXAlignmentConstrain.constant      = 0.0f;
    self.passwordXAllignmentConstraint.constant = 0.0f;
    [self.view layoutIfNeeded];
}

- (void)setLastLoggedInUser
{
    NSString *lastUser = [[NSUserDefaults standardUserDefaults] stringForKey:TXHUserDefaultsLastUserKey];
    if (lastUser && [lastUser length] > 0) {
        self.userField.text = lastUser;
    } else {
        self.userField.text = @"";
    }
    
    [self resetPasswordField];
}

- (void)resetPasswordField
{
    self.passwordField.text = @"";
}

#pragma mark - Superclass overrides


#pragma mark - Notification Handlers

#pragma mark Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *keyboardAnimationDetail = [notification userInfo];
    UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{
        self.verticalLogoConstrain.constant = 250.0f;
        self.logoTofieldsContraint.constant = 30.0f;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *keyboardAnimationDetail = [notification userInfo];
    UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{
        self.verticalLogoConstrain.constant = 50.0f;
        self.logoTofieldsContraint.constant = 95.0f;
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - Private methods

- (void)loginCompleted {
    // Set the last user into the defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.userField.text forKey:TXHUserDefaultsLastUserKey];

    [self performSegueWithIdentifier:@"Show Main Interface" sender:self];
}

#pragma mark Actions

- (IBAction)login:(id)sender {
    [self.activityIndicator startAnimating];
    
    __weak typeof(self) wself = self;
    [TXHTICKETINHGUBCLIENT fetchSuppliersForUsername:self.userField.text
                                            password:self.passwordField.text
                                      withCompletion:^(NSArray *suppliers, NSError *error) {
                                          [wself.activityIndicator stopAnimating];                                          
                                          if (error)
                                          {
                                              [wself shakeFields];
                                              [wself resetPasswordField];
                                              return;
                                          }
                                          
                                          [wself loginCompleted];
                                      }];
}

- (void)shakeFields
{
    [self.fieldsContainerView shake:3 withDelta:8 andSpeed:0.08 shakeDirection:ShakeDirectionHorizontal];
}

#pragma mark - unwind action

- (IBAction)showLoginViewController:(UIStoryboardSegue *)sender;
{
    [TXHTicketingHubManager clearLocalData];
}

@end
