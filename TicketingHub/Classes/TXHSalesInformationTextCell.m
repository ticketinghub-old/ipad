//
//  TXHSalesInformationTextCell.m
//  TicketingHub
//
//  Created by Mark on 08/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesInformationTextCell.h"

@import QuartzCore;

#import "TXHDataEntryFieldErrorView.h"

@interface TXHSalesInformationTextCell ()

@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UITextField *detailField;
@property (weak, nonatomic) IBOutlet UIView *backingView;

@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;

@property (weak, nonatomic) IBOutlet TXHDataEntryFieldErrorView *dataErrorView;

@end

@implementation TXHSalesInformationTextCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTicket:(NSString *)ticket {
    self.detail.text = ticket;
    self.detailField.placeholder = ticket;
    
    // Round corners of the backing view
    self.backingView.layer.cornerRadius = 4.0f;
    
    // Round corners of the errorView
    self.errorView.layer.cornerRadius = 5.0f;
}

- (void)hasErrors:(BOOL)errors {
    if (errors) {
        UIColor *errorColor = [UIColor colorWithRed:255.0f / 255.0f
                                              green:213.0f / 255.0f
                                               blue:216.0f / 255.0f
                                              alpha:1.0f];
        self.backingView.backgroundColor = errorColor;
        self.detailField.backgroundColor = errorColor;
        self.detailField.textColor = [UIColor redColor];
        self.detailField.text = @"Oh no - this is bad!";
        
        self.dataErrorView.message = @"A really really really long test error message";
        
    } else {
        UIColor *normalColor = [UIColor colorWithRed:238.0f / 255.0f
                                              green:241.0f / 255.0f
                                               blue:243.0f / 255.0f
                                              alpha:1.0f];
        self.backingView.backgroundColor = normalColor;
        self.detailField.backgroundColor = normalColor;
        self.detailField.textColor = [UIColor colorWithRed:37.0f / 255.0f
                                                     green:16.0f / 255.0f
                                                      blue:87.0f / 255.0f
                                                     alpha:1.0f];
        self.detailField.text = @"Oh no - this is bad!";
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.dataErrorView.message = @"";
    self.detailField.text = @"";
}

@end
