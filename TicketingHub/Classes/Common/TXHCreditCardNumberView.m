//
//  TXHCreditCardNumberView.m
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHCreditCardNumberView.h"

#import "TXHTextEntryView.h"

@interface TXHCreditCardNumberView ()

@property (strong, nonatomic) TXHTextEntryView *creditCardNumber;
@property (strong, nonatomic) UIImageView *picture;

@end

@implementation TXHCreditCardNumberView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // The text entry view occupies the left side of this view leaving space for a credit card image
    CGRect frame = self.bounds;
    
    // Credit card image dimensions
    CGFloat width = 40.0f;
    CGFloat height = 28.0f;
    
    _creditCardNumber = [[TXHTextEntryView alloc] initWithFrame:frame];
    _creditCardNumber.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_creditCardNumber];
    
    // Add image view on the right hand side
    frame.origin.y = frame.size.height - height;
    frame.origin.x = frame.size.width - width;
    frame.size = CGSizeMake(width, height);
    
    _picture = [[UIImageView alloc] initWithFrame:frame];
    _picture.contentMode = UIViewContentModeScaleAspectFit;
    _picture.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_picture];

    UIImageView *imageView = _picture;
    TXHTextEntryView *ccView = _creditCardNumber;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(ccView, imageView);
    
    // Add constraints to pin card number on the left hand side of the image
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:@"H:|[ccView]-(-40)-[imageView]|"
                            options:0
                            metrics:nil
                            views:viewsDictionary];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint
                                                              constraintsWithVisualFormat:@"V:|[ccView]|"
                                                              options:0
                                                              metrics:nil
                                                              views:viewsDictionary]];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint
                                                              constraintsWithVisualFormat:@"V:|-20-[imageView]|"
                                                              options:0
                                                              metrics:nil
                                                              views:viewsDictionary]];
    
    [self addConstraints:constraints];
}

- (void)setCardType:(NSString *)cardType {
    UIImage *creditCardImage = [UIImage imageNamed:cardType];
    if (creditCardImage) {
        CGRect frame = self.picture.frame;
        self.picture.image = creditCardImage;
        self.picture.frame = frame;
    }
}

- (void)setCardNumber:(NSString *)cardNumber {
    self.creditCardNumber.text = cardNumber;
}

@end
