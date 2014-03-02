//
//  TXHSalesInformationSelectionCell.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 02/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHSalesInformationSelectionCell.h"
#import "TXHDataEntryFieldErrorView.h"
#import "TXHDataSelectionViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TXHSalesInformationSelectionCell () <TXHDataSelectionDelegate>

@property (weak, nonatomic) IBOutlet TXHDataEntryFieldErrorView *errorMessageView;
@property (weak, nonatomic) IBOutlet UIButton *selectionField;

@property (strong, nonatomic) UIPopoverController *selectionPopover;

@end

@implementation TXHSalesInformationSelectionCell

+ (UIColor *)errorBackgroundColor
{
    static UIColor *_errorBackgroundColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _errorBackgroundColor = [UIColor colorWithRed:255.0f / 255.0f
                                                green:213.0f / 255.0f
                                                 blue:216.0f / 255.0f
                                                alpha:1.0f];
    });
    return _errorBackgroundColor;
}

+ (UIColor *)normalBackgroundColor
{
    static UIColor *_normalBackgroundColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _normalBackgroundColor = [UIColor colorWithRed:238.0f / 255.0f
                                                 green:241.0f / 255.0f
                                                  blue:243.0f / 255.0f
                                                 alpha:1.0f];
    });
    return _normalBackgroundColor;
}

+ (UIColor *)errorTextColor
{
    static UIColor *_errorTextColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _errorTextColor = [UIColor redColor];
    });
    return _errorTextColor;
}

+ (UIColor *)normalTextColor
{
    static UIColor *_normalTextColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _normalTextColor = [UIColor colorWithRed:37.0f / 255.0f
                                           green:16.0f / 255.0f
                                            blue:87.0f / 255.0f
                                           alpha:1.0f];
    });
    return _normalTextColor;
}

+ (UIColor *)placeholderTextColor
{
    static UIColor *_normalTextColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _normalTextColor = [UIColor colorWithRed:37.0f / 255.0f
                                           green:16.0f / 255.0f
                                            blue:87.0f / 255.0f
                                           alpha:0.5f];
    });
    return _normalTextColor;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupSeletionField];
    [self.selectionField addTarget:self action:@selector(chooseItem:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setupSeletionField
{
    self.selectionField.layer.borderColor  = self.selectionField.tintColor.CGColor;
    self.selectionField.layer.cornerRadius = 5.0;
    self.selectionField.layer.borderWidth  = 1.0;
}


- (void)chooseItem:(id)sender {
    if (self.selectionPopover.isPopoverVisible) {
        [self.selectionPopover dismissPopoverAnimated:YES];
    }
    TXHDataSelectionViewController *dataSelector = [[TXHDataSelectionViewController alloc] initWithStyle:UITableViewStylePlain];
    dataSelector.items = self.options;
    dataSelector.delegate = self;
    
    self.selectionPopover = [[UIPopoverController alloc] initWithContentViewController:dataSelector];
    self.selectionPopover.popoverContentSize = CGSizeMake(210.0f, (MIN(4,[self.options count]) * 44.0f));
    [self.selectionPopover presentPopoverFromRect:self.selectionField.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (BOOL)hasErrors
{
    return (self.errorMessageView.message.length > 0);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)setValue:(NSString *)value
{
    _value = value;
    [self updateTitle];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    [self updateTitle];
}

- (void)setErrorMessage:(NSString *)errorMessage
{
    self.errorMessageView.message = errorMessage;
    [self updateColors];
}

- (void)updateTitle
{
    if ([self.value length])
    {
        [self.selectionField setTitle:self.value forState:UIControlStateNormal];
    }
    else
    {
        [self.selectionField setTitle:self.placeholder forState:UIControlStateNormal];
    }
    [self updateColors];
}

- (void)updateColors
{
    UIColor *textColor;
    UIColor *backgroundColor;
    
    if ([self hasErrors])
    {
        textColor       = [[self class] errorTextColor];
        backgroundColor = [[self class] errorBackgroundColor];
    }
    else
    {
        backgroundColor = [[self class] normalBackgroundColor];
        
        if ([self.value length])
            textColor = [[self class] normalTextColor];
        else
            textColor = [[self class] placeholderTextColor];
    }
    
    [self.selectionField setTitleColor:textColor forState:UIControlStateNormal];
    [self.selectionField setBackgroundColor:backgroundColor];
}

#pragma mark - TXHDataSelectionDelegate

- (void)dataSelectionViewController:(TXHDataSelectionViewController *)controller didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedValue = [self.options objectAtIndex:indexPath.row];
    self.value = selectedValue;
    
    [self.selectionPopover dismissPopoverAnimated:YES];
    [self.delegate txhSalesInformationSelectionCellDidChangeOption:self];
}


@end
