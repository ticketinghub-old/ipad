//
//  TXHBaseDataEntryView.h
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHBaseDataEntryView : UIView

// A color for the view surrounding the data entry field
@property (strong, nonatomic) UIColor *outerColor;

// A color for the view surrounding the data entry field when in an error state
@property (strong, nonatomic) UIColor *outerColorForError;

// Should the outer color be applied to the dataEntry field (default's to YES
@property (assign, nonatomic) BOOL applyOuterColorToDataEntryField;

// an error message to display above & overlapping the data content view
@property (strong, nonatomic) NSString *errorMessage;

// Use this method to provide a data content view that will be used for collecting data from a user
- (void)updateDataContentView:(UIView *)dataContentView;

// This method is called during initialization to configure cell content.
- (void)setupDataContent;

@end
