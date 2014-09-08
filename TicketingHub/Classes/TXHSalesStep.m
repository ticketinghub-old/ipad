//
//  TXHSalesStepAbstract.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 18/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

// TODO: convert to real objects!!!

#import "TXHSalesStep.h"

NSString * const kWizardStepTitleKey                  = @"kWizardStepTitleKey";
NSString * const kWizardStepDescriptionKey            = @"kWizardStepDescriptionKey";
NSString * const kWizardStepContinueTitleKey          = @"kWizardStepContinueTitleKey";

NSString * const kWizardStepHidesStepsList            = @"kWizardStepHidesStepsList";

NSString * const kWizardStepControllerSegueID         = @"kWizardStepControllerSegueID";

NSString * const kWizardStepLeftButtonTitle           = @"kWizardStepLeftButtonTitle";
NSString * const kWizardStepMiddleLeftButtonTitle     = @"kWizardStepMiddleLeftButtonTitle";
NSString * const kWizardStepMiddleButtonTitle         = @"kWizardStepMiddleButtonTitle";
NSString * const kWizardStepMiddleRightButtonTitle    = @"kWizardStepMiddleRightButtonTitle";
NSString * const kWizardStepRightButtonTitle          = @"kWizardStepRightButtonTitle";

NSString * const kWizardStepLeftButtonDisabled        = @"kWizardStepLeftButtonDisabled";
NSString * const kWizardStepMiddleLeftButtonDisabled  = @"kWizardStepMiddleLeftButtonDisabled";
NSString * const kWizardStepMiddleButtonDisabled      = @"kWizardStepMiddleButtonDisabled";
NSString * const kWizardStepMiddleRightButtonDisabled = @"kWizardStepMiddleRightButtonDisabled";
NSString * const kWizardStepRightButtonDisabled       = @"kWizardStepRightButtonDisabled";

NSString * const kWizardStepHidesLeftButton           = @"kWizardStepHidesLeftButton";
NSString * const kWizardStepHidesMiddleLeftButton     = @"kWizardStepHidesMiddleLeftButton";
NSString * const kWizardStepHidesMiddleButton         = @"kWizardStepHidesMiddleButton";
NSString * const kWizardStepHidesMiddleRightButton    = @"kWizardStepHidesMiddleRightButton";
NSString * const kWizardStepHidesRightButton          = @"kWizardStepHidesRightButton";

NSString * const kWizardStepShowCouponButton          = @"kWizardStepShowCouponButton";
NSString * const kWizardStepCouponButtonBlock         = @"kWizardStepCouponButtonBlock";

NSString * const kWizardStepLeftButtonBlock           = @"kWizardStepLeftButtonCustomActionBlock";
NSString * const kWizardStepMiddleLeftButtonBlock     = @"kWizardStepMiddleLeftButtonCustomActionBlock";
NSString * const kWizardStepMiddleButtonBlock         = @"kWizardStepMiddleButtonCustomActionBlock";
NSString * const kWizardStepMiddleRightButtonBlock    = @"kWizardStepMiddleRightButtonCustomActionBlock";
NSString * const kWizardStepRightButtonBlock          = @"kWizardStepRightButtonCustomActionBlock";



@interface TXHSalesStep ()

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *description;
@property (copy, nonatomic) NSString *continueTitle;

@property (copy, nonatomic) NSString *segueID;

@property (copy, nonatomic) NSString *leftButtonTitle;
@property (copy, nonatomic) NSString *middleLeftButtonTitle;
@property (copy, nonatomic) NSString *middleButtonTitle;
@property (copy, nonatomic) NSString *middleRightButtonTitle;
@property (copy, nonatomic) NSString *rightButtonTitle;

@property (assign, nonatomic) BOOL shouldHideStepsList;

@property (assign, nonatomic, getter = hasLeftButtonDisabled)   BOOL leftButtonDisabled;
@property (assign, nonatomic, getter = hasMiddleLeftButtonDisabled) BOOL middleLeftButtonDisabled;
@property (assign, nonatomic, getter = hasMiddleButtonDisabled) BOOL middleButtonDisabled;
@property (assign, nonatomic, getter = hasMiddleRightButtonDisabled) BOOL middleRightButtonDisabled;
@property (assign, nonatomic, getter = hasRightButtonDisabled)  BOOL rightButtonDisabled;

@property (assign, nonatomic, getter = hasLeftButtonHidden)   BOOL leftButtonHidden;
@property (assign, nonatomic, getter = hasMiddleLeftButtonHidden) BOOL middleLeftButtonHidden;
@property (assign, nonatomic, getter = hasMiddleButtonHidden) BOOL middleButtonHidden;
@property (assign, nonatomic, getter = hasMiddleRightButtonHidden) BOOL middleRightButtonHidden;
@property (assign, nonatomic, getter = hasRightButtonHidden)  BOOL rightButtonHidden;

@property (assign, nonatomic) BOOL hasCouponSelectionButton;

@property (copy, nonatomic) UIColor *leftButtonColor;

@property (copy, nonatomic) void (^couponButtonActionBlock)(UIButton *button);

@property (copy, nonatomic) void (^leftButtonActionBlock)(UIButton *button);
@property (copy, nonatomic) void (^middleLeftButtonActionBlock)(UIButton *button);
@property (copy, nonatomic) void (^middleButtonActionBlock)(UIButton *button);
@property (copy, nonatomic) void (^middleRightButtonActionBlock)(UIButton *button);
@property (copy, nonatomic) void (^rightButtonActionBlock)(UIButton *button);

@end

@implementation TXHSalesStep

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (!(self = [super init]))
        return nil;
    
    self.title                        = dictionary[kWizardStepTitleKey];
    self.description                  = dictionary[kWizardStepDescriptionKey];
    self.continueTitle                = dictionary[kWizardStepContinueTitleKey];
    self.segueID                      = dictionary[kWizardStepControllerSegueID];
    self.leftButtonTitle              = dictionary[kWizardStepLeftButtonTitle];
    self.middleLeftButtonTitle        = dictionary[kWizardStepMiddleLeftButtonTitle];
    self.middleButtonTitle            = dictionary[kWizardStepMiddleButtonTitle];
    self.middleRightButtonTitle       = dictionary[kWizardStepMiddleRightButtonTitle];
    self.rightButtonTitle             = dictionary[kWizardStepRightButtonTitle];
    self.leftButtonActionBlock        = dictionary[kWizardStepLeftButtonBlock];
    self.middleLeftButtonActionBlock  = dictionary[kWizardStepMiddleLeftButtonBlock];
    self.middleButtonActionBlock      = dictionary[kWizardStepMiddleButtonBlock];
    self.middleRightButtonActionBlock = dictionary[kWizardStepMiddleRightButtonBlock];
    self.rightButtonActionBlock       = dictionary[kWizardStepRightButtonBlock];
    self.couponButtonActionBlock      = dictionary[kWizardStepCouponButtonBlock];
    self.shouldHideStepsList          = [dictionary[kWizardStepHidesStepsList] boolValue];
    self.leftButtonDisabled           = [dictionary[kWizardStepLeftButtonDisabled] boolValue];
    self.middleLeftButtonDisabled     = [dictionary[kWizardStepMiddleLeftButtonDisabled] boolValue];
    self.middleButtonDisabled         = [dictionary[kWizardStepMiddleButtonDisabled] boolValue];
    self.middleRightButtonDisabled    = [dictionary[kWizardStepMiddleRightButtonDisabled] boolValue];
    self.rightButtonDisabled          = [dictionary[kWizardStepRightButtonDisabled] boolValue];
    self.leftButtonHidden             = [dictionary[kWizardStepHidesLeftButton] boolValue];
    self.middleLeftButtonHidden       = [dictionary[kWizardStepHidesMiddleLeftButton] boolValue];
    self.middleButtonHidden           = [dictionary[kWizardStepHidesMiddleButton] boolValue];
    self.middleRightButtonHidden      = [dictionary[kWizardStepHidesMiddleRightButton] boolValue];
    self.rightButtonHidden            = [dictionary[kWizardStepHidesRightButton] boolValue];
    self.hasCouponSelectionButton     = [dictionary[kWizardStepShowCouponButton] boolValue];
    
    return self;
}

@end
