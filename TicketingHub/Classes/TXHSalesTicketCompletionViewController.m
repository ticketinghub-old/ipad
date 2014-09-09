//
//  TXHSalesTicketCompletionViewController.m
//  TicketingHub
//
//  Created by Mark on 31/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesTicketCompletionViewController.h"

#import "TXHFullScreenKeyboardViewController.h"

#import "TXHActivityLabelView.h"
#import "TXHBorderedButton.h"
#import "TXHDataEntryFieldErrorView.h"

#import "TXHOrderManager.h"
#import "TXHProductsManager.h"

#import "UIFont+TicketingHub.h"
#import "UIColor+TicketingHub.h"

#import <QuartzCore/QuartzCore.h>

static NSString * const kFirstNameKey = @"first_name";
static NSString * const kSurnameKey   = @"last_name";
static NSString * const kEmailKey     = @"email";
static NSString * const kTelephoneKey = @"telephone";
static NSString * const kNotesKey     = @"notes";

@interface TXHSalesTicketCompletionViewController () <UITextFieldDelegate, TXHFullScreenKeyboardViewControllerDelegate>

@property (readwrite, assign, nonatomic, getter = isValid) BOOL valid;
@property (readwrite, assign, nonatomic) BOOL shouldBeSkiped;

@property (weak, nonatomic) IBOutlet UILabel *referenceNumberLabel;

@property (weak, nonatomic) IBOutlet UIView *fieldsContainerView;
@property (weak, nonatomic) IBOutlet UIView *firstNameBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *surnameBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *emailBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *telephoneBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *notesBackgroundView;

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *surnameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *telephoneField;
@property (weak, nonatomic) IBOutlet UITextField *notesField;
@property (weak, nonatomic) UITextField *currentField;

@property (weak, nonatomic) IBOutlet TXHDataEntryFieldErrorView *firstNameErrorView;
@property (weak, nonatomic) IBOutlet TXHDataEntryFieldErrorView *surnameErrorView;
@property (weak, nonatomic) IBOutlet TXHDataEntryFieldErrorView *emailErrorView;
@property (weak, nonatomic) IBOutlet TXHDataEntryFieldErrorView *telephoneErrorView;
@property (weak, nonatomic) IBOutlet TXHDataEntryFieldErrorView *notesErrorView;

@property (weak, nonatomic) IBOutlet TXHBorderedButton *updateButton;

@property (strong, nonatomic) TXHActivityLabelView *activityView;
@property (strong, nonatomic) TXHFullScreenKeyboardViewController *fullScreenController;

@end

@implementation TXHSalesTicketCompletionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupFields];
    
    self.valid = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateView];
}

- (TXHActivityLabelView *)activityView
{
    if (!_activityView)
        _activityView = [TXHActivityLabelView getInstanceInView:self.view];
    
    return _activityView;
}


- (void)setupFields
{
#define FIELD_CORNER_RADIUS 10.0f
    
    self.firstNameBackgroundView.layer.cornerRadius = FIELD_CORNER_RADIUS;
    self.surnameBackgroundView.layer.cornerRadius   = FIELD_CORNER_RADIUS;
    self.emailBackgroundView.layer.cornerRadius     = FIELD_CORNER_RADIUS;
    self.telephoneBackgroundView.layer.cornerRadius = FIELD_CORNER_RADIUS;
    self.notesBackgroundView.layer.cornerRadius     = FIELD_CORNER_RADIUS;
    
    [self setupErrorViews];
}

- (void)setupErrorViews
{
    UIFont *font = [UIFont txhThinFontWithSize:18.0];
    self.firstNameErrorView.textFont = font;
    self.surnameErrorView.textFont   = font;
    self.emailErrorView.textFont     = font;
    self.telephoneErrorView.textFont = font;
    self.notesErrorView.textFont     = font;

    UIColor *textColor = [UIColor whiteColor];
    self.firstNameErrorView.messageColor = textColor;
    self.surnameErrorView.messageColor   = textColor;
    self.emailErrorView.messageColor     = textColor;
    self.telephoneErrorView.messageColor = textColor;
    self.notesErrorView.messageColor     = textColor;
}

- (void)setOrderManager:(TXHOrderManager *)orderManager
{
    _orderManager = orderManager;

    [self updateView];
}

- (void)setProductManager:(TXHProductsManager *)productManager
{
    _productManager = productManager;
    
    [self updateView];
}

- (void)updateView
{
    self.updateButton.enabled = [self areFieldsValid];
    self.referenceNumberLabel.text = self.orderManager.order.reference;
}

- (BOOL)areFieldsValid
{
    BOOL firstNameValid = [self isFirstNameValid];
    BOOL surameValid    = [self isSurnameValid];
    BOOL emailValid     = [self isEmailValid];
    BOOL telephoneValid = [self isTelephoneValid];
    
    return firstNameValid || surameValid || emailValid || telephoneValid;
}


- (void)showFieldsFullScreen
{
    if (self.fullScreenController)
        return;
    
    TXHFullScreenKeyboardViewController *full = [[TXHFullScreenKeyboardViewController alloc] init];
    full.destinationBackgroundColor = [UIColor whiteColor];
    full.delegate = self;

    self.fullScreenController = full;
    
    __weak typeof(self) wself = self;
    
    [full showWithView:self.fieldsContainerView
            completion:^{
                [wself.currentField becomeFirstResponder];
            }];
}

- (void)hideFieldsFullScreen
{
    [self.currentField resignFirstResponder];
    
    __weak typeof(self) wself = self;
    
    [self.fullScreenController hideAniamted:YES
                                 completion:^{
                                     [wself.activityView.superview bringSubviewToFront:wself.activityView];
                                 }];
    self.fullScreenController = nil;
}

// TODO: implement proper field validation

- (BOOL)isFirstNameValid
{
    return [self.firstNameField.text length] > 0;
}

- (BOOL)isSurnameValid
{
    return [self.firstNameField.text length] > 0;
}

- (BOOL)isEmailValid
{
    return [self.firstNameField.text length] > 0;
}

- (BOOL)isTelephoneValid
{
    return [self.firstNameField.text length] > 0;
}


- (IBAction)updateCustomerAction:(id)sender
{
    [self.activityView showWithMessage:NSLocalizedString(@"SALESMAN_COMPLETION_UPDATING_CUTOMER_MESSAGE", nil)
                       indicatorHidden:NO];
    
    __weak typeof(self) wself = self;
    
    [self.orderManager updateOrderWithOwnerInfo:[self customerInfo]
                                     completion:^(TXHOrder *order, NSError *error) {
                                         [wself.activityView hide];
                                         [wself setFieldsErrorsFromInfo:order.customer.errors];
//                                         if (!error)
//                                         {
//                                             wself.updateButton.enabled = NO;
//                                             wself.fieldsContainerView.alpha = 0.5;
//                                             wself.fieldsContainerView.userInteractionEnabled = NO;
//                                         }
                                         
                                     }];
}

- (void)setFieldsErrorsFromInfo:(NSDictionary *)fieldsErrors
{
    [self.firstNameErrorView setMessage:[fieldsErrors[kFirstNameKey] firstObject]];
    [self.surnameErrorView   setMessage:[fieldsErrors[kSurnameKey] firstObject]];
    [self.emailErrorView     setMessage:[fieldsErrors[kEmailKey] firstObject]];
    [self.telephoneErrorView setMessage:[fieldsErrors[kTelephoneKey] firstObject]];
    [self.notesErrorView     setMessage:[fieldsErrors[kNotesKey] firstObject]];
}

- (NSDictionary *)customerInfo
{
    NSMutableDictionary *customerInfo = [NSMutableDictionary dictionary];
    
    if ([self.firstNameField.text length])
        customerInfo[kFirstNameKey] = self.firstNameField.text;

    if ([self.surnameField  .text length])
        customerInfo[kSurnameKey] = self.surnameField.text;
    
    if ([self.emailField.text length])
        customerInfo[kEmailKey] = self.emailField.text;
    
    if ([self.telephoneField.text length])
        customerInfo[kTelephoneKey] = self.telephoneField.text;
    
    if ([self.notesField.text length])
        customerInfo[kNotesKey] = self.notesField.text;
    
    return customerInfo;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *nextField = [self nextField];

    if (nextField)
        [nextField becomeFirstResponder];
    else
    {
        [textField resignFirstResponder];
        [self hideFieldsFullScreen];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self showFieldsFullScreen];
    
    self.currentField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self updateView];
}

- (UITextField *)nextField
{
    if (self.currentField == self.firstNameField)
        return self.surnameField;
    else if (self.currentField == self.surnameField)
        return self.emailField;
    else if (self.currentField == self.emailField)
        return self.telephoneField;
    else if (self.currentField == self.telephoneField)
        return self.notesField;
    
    return nil;
}

#pragma mark - TXHFullScreenKeyboardViewControllerDelegate

- (void)txhFullScreenKeyboardViewControllerDismiss:(TXHFullScreenKeyboardViewController *)controller
{
    [self hideFieldsFullScreen];
}


@end
