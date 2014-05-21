//
//  TXHSalesStepAbstract.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 18/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>


// constructom method dictionary keys

extern NSString * const kWizardStepTitleKey;
extern NSString * const kWizardStepDescriptionKey;
extern NSString * const kWizardStepContinueTitleKey;

extern NSString * const kWizardStepControllerSegueID;

extern NSString * const kWizardStepLeftButtonTitle;
extern NSString * const kWizardStepMiddleButtonTitle;
extern NSString * const kWizardStepRightButtonTitle;

extern NSString * const kWizardStepLeftButtonDisabled;
extern NSString * const kWizardStepMiddleButtonDisabled;
extern NSString * const kWizardStepRightButtonDisabled;

extern NSString * const kWizardStepHidesLeftButton;
extern NSString * const kWizardStepHidesMiddleButton;
extern NSString * const kWizardStepHidesRightButton;

extern NSString * const kWizardStepMiddleButtonImage;
extern NSString * const kWizardStepRightButtonImage;

extern NSString * const kWizardStepLeftButtonColor;

extern NSString * const kWizardStepLeftButtonBlock;
extern NSString * const kWizardStepMiddleButtonBlock;
extern NSString * const kWizardStepRightButtonBlock;


@interface TXHSalesStep : NSObject

@property (readonly, copy, nonatomic) NSString *title;
@property (readonly, copy, nonatomic) NSString *description;
@property (readonly, copy, nonatomic) NSString *continueTitle;

@property (readonly, copy, nonatomic) NSString *segueID;

@property (readonly, copy, nonatomic) NSString *leftButtonTitle;
@property (readonly, copy, nonatomic) NSString *middleButtonTitle;
@property (readonly, copy, nonatomic) NSString *rightButtonTitle;

@property (readonly, assign, nonatomic, getter = hasLeftButtonDisabled)   BOOL leftButtonDisabled;
@property (readonly, assign, nonatomic, getter = hasMiddleButtonDisabled) BOOL middleButtonDisabled;
@property (readonly, assign, nonatomic, getter = hasRightButtonDisabled)  BOOL rightButtonDisabled;

@property (readonly, assign, nonatomic, getter = hasLeftButtonHidden)   BOOL leftButtonHidden;
@property (readonly, assign, nonatomic, getter = hasMiddleButtonHidden) BOOL middleButtonHidden;
@property (readonly, assign, nonatomic, getter = hasRightButtonHidden)  BOOL rightButtonHidden;

@property (readonly, copy, nonatomic) UIImage *middleButtonImage;
@property (readonly, copy, nonatomic) UIImage *rightButtonImage;

@property (readonly, copy, nonatomic) UIColor *leftButtonColor;

@property (readonly, copy, nonatomic) void (^leftButtonActionBlock)(UIButton *button);
@property (readonly, copy, nonatomic) void (^middleButtonActionBlock)(UIButton *button);
@property (readonly, copy, nonatomic) void (^rightButtonActionBlock)(UIButton *button);

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
