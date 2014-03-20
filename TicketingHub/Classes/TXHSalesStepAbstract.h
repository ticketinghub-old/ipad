//
//  TXHSalesStepAbstract.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 18/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kWizardStepTitleKey;
extern NSString * const kWizardStepDescriptionKey;

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

@interface TXHSalesStepAbstract : NSObject

@end
