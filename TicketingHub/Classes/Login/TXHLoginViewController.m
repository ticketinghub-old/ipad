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
#import "TXHTicketingHubClient.h"
#import "TXHUser.h"
#import "TXHUserDefaultsKeys.h"
#import "TXHUserMO.h"
#import "TXHVenueMO.h"
#import "UIView+TXHAnimationConversions.h"

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

    TXHTicketingHubClient *ticketingHubClient = [TXHTicketingHubClient sharedClient];

    __block TXHUserMO *userMO;
    [ticketingHubClient userInformationSuccess:^(TXHUser *user) {
        userMO = [TXHUserMO userWithObject:user inManagedObjectContext:self.managedObjectContext];

        [ticketingHubClient venuesWithSuccess:^(NSArray *venues) {
            if (isEmpty(venues)) {
                // Warn user that they cannot proceed
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Venues" message:@"You do not have access to any venues." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];

                return; // Bail!
            }

            for (TXHVenue *venue in venues) {
                TXHVenueMO *venueMO = [TXHVenueMO venueWithObjectCreateIfNeeded:venue inManagedObjectContext:self.managedObjectContext];
                venueMO.user = userMO;
                DLog(@"New venue created: %@", venueMO);
            }


            [self dismissViewControllerAnimated:YES completion:nil];

        } failure:^(NSHTTPURLResponse *response, NSError *error, id JSON) {
            DLog(@"Error: %@ with response: %@", error, JSON);
        }];

    } failure:^(NSHTTPURLResponse *response, NSError *error, id JSON) {
        DLog(@"Error: %@ with response: %@", error, JSON);
    }];

}

#pragma mark Actions

- (IBAction)login:(id)sender {
    self.loginButton.enabled = NO;

    [[TXHTicketingHubClient sharedClient] configureWithUsername:self.userField.text password:self.passwordField.text clientId:kClientId clientSecret:kClientSecret success:^(NSURLRequest *request, NSHTTPURLResponse *response) {
        [self loginCompleted];

    } failure:^(NSHTTPURLResponse *response, NSError *error, id JSON) {
        // Debug logging for now. - This needs to be tidied for production
        DLog(@"Unable to log on because: %@ with JSON: %@", error, JSON);
    }];
}

- (IBAction)editingChanged:(id)sender {
    self.loginButton.enabled = ((self.userField.text.length > 0) && (self.passwordField.text.length > 0));
}


@end
