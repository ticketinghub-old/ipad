//
//  TXHSalesStepAbstract.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 18/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

// TODO: convert to real objects!!!

#import "TXHSalesStep.h"

NSString * const kWizardStepTitleKey             = @"kWizardStepTitleKey";
NSString * const kWizardStepDescriptionKey       = @"kWizardStepDescriptionKey";
NSString * const kWizardStepContinueTitleKey     = @"kWizardStepContinueTitleKey";

NSString * const kWizardStepControllerSegueID    = @"kWizardStepControllerSegueID";

NSString * const kWizardStepLeftButtonTitle      = @"kWizardStepLeftButtonTitle";
NSString * const kWizardStepMiddleButtonTitle    = @"kWizardStepMiddleButtonTitle";
NSString * const kWizardStepRightButtonTitle     = @"kWizardStepRightButtonTitle";

NSString * const kWizardStepLeftButtonDisabled   = @"kWizardStepLeftButtonDisabled";
NSString * const kWizardStepMiddleButtonDisabled = @"kWizardStepMiddleButtonDisabled";
NSString * const kWizardStepRightButtonDisabled  = @"kWizardStepRightButtonDisabled";

NSString * const kWizardStepHidesLeftButton      = @"kWizardStepHidesLeftButton";
NSString * const kWizardStepHidesMiddleButton    = @"kWizardStepHidesMiddleButton";
NSString * const kWizardStepHidesRightButton     = @"kWizardStepHidesRightButton";

NSString * const kWizardStepMiddleButtonImage    = @"kWizardStepMiddleButtonImage";
NSString * const kWizardStepRightButtonImage     = @"kWizardStepRightButtonImage";

NSString * const kWizardStepLeftButtonColor      = @"kWizardStepLeftButtonColor";

NSString * const kWizardStepLeftButtonBlock      = @"kWizardStepLeftButtonCustomActionBlock";
NSString * const kWizardStepMiddleButtonBlock    = @"kWizardStepMiddleButtonCustomActionBlock";
NSString * const kWizardStepRightButtonBlock     = @"kWizardStepRightButtonCustomActionBlock";



@interface TXHSalesStep ()

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *description;
@property (copy, nonatomic) NSString *continueTitle;

@property (copy, nonatomic) NSString *segueID;

@property (copy, nonatomic) NSString *leftButtonTitle;
@property (copy, nonatomic) NSString *middleButtonTitle;
@property (copy, nonatomic) NSString *rightButtonTitle;

@property (assign, nonatomic, getter = hasLeftButtonDisabled)   BOOL leftButtonDisabled;
@property (assign, nonatomic, getter = hasMiddleButtonDisabled) BOOL middleButtonDisabled;
@property (assign, nonatomic, getter = hasRightButtonDisabled)  BOOL rightButtonDisabled;

@property (assign, nonatomic, getter = hasLeftButtonHidden)   BOOL leftButtonHidden;
@property (assign, nonatomic, getter = hasMiddleButtonHidden) BOOL middleButtonHidden;
@property (assign, nonatomic, getter = hasRightButtonHidden)  BOOL rightButtonHidden;

@property (copy, nonatomic) UIImage *middleButtonImage;
@property (copy, nonatomic) UIImage *rightButtonImage;

@property (copy, nonatomic) UIColor *leftButtonColor;

@property (copy, nonatomic) void (^leftButtonActionBlock)(UIButton *button);
@property (copy, nonatomic) void (^middleButtonActionBlock)(UIButton *button);
@property (copy, nonatomic) void (^rightButtonActionBlock)(UIButton *button);

@end

@implementation TXHSalesStep

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (!(self = [super init]))
        return nil;
    
    self.title                   = dictionary[kWizardStepTitleKey];
    self.description             = dictionary[kWizardStepDescriptionKey];
    self.continueTitle           = dictionary[kWizardStepContinueTitleKey];
    self.segueID                 = dictionary[kWizardStepControllerSegueID];
    self.leftButtonTitle         = dictionary[kWizardStepLeftButtonTitle];
    self.middleButtonTitle       = dictionary[kWizardStepMiddleButtonTitle];
    self.rightButtonTitle        = dictionary[kWizardStepRightButtonTitle];
    self.leftButtonDisabled      = [dictionary[kWizardStepLeftButtonDisabled] boolValue];
    self.middleButtonDisabled    = [dictionary[kWizardStepMiddleButtonDisabled] boolValue];
    self.rightButtonDisabled     = [dictionary[kWizardStepRightButtonDisabled] boolValue];
    self.leftButtonHidden        = [dictionary[kWizardStepHidesLeftButton] boolValue];
    self.middleButtonHidden      = [dictionary[kWizardStepHidesMiddleButton] boolValue];
    self.rightButtonHidden       = [dictionary[kWizardStepHidesRightButton] boolValue];
    self.middleButtonImage       = dictionary[kWizardStepMiddleButtonImage];
    self.rightButtonImage        = dictionary[kWizardStepRightButtonImage];
    self.leftButtonColor         = dictionary[kWizardStepLeftButtonColor];
    self.leftButtonActionBlock   = dictionary[kWizardStepLeftButtonBlock];
    self.middleButtonActionBlock = dictionary[kWizardStepMiddleButtonBlock];
    self.rightButtonActionBlock  = dictionary[kWizardStepRightButtonBlock];
    
    return self;
}

@end
