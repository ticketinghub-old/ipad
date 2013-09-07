//
//  TXHDataSelectionView.m
//  TicketingHub
//
//  Created by Mark on 19/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHDataSelectionView.h"

#import "TXHDataSelectionViewController.h"

@interface TXHDataSelectionView () <TXHDataSelectionDelegate>

@property (strong, nonatomic) UIButton *selectionButton;
@property (strong, nonatomic) UIImageView *downArrowView;

// A popover controller allowing an item to be selected
@property (strong, nonatomic) UIPopoverController *selectionPopover;

@end

@implementation TXHDataSelectionView

- (void)setupDataContent {
    [super setupDataContent];
    self.applyOuterColorToDataEntryField = NO;
    self.outerColor = [UIColor whiteColor];
    _selectionButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self updateDataContentView:_selectionButton];
    UIImage *buttonBorder = [[UIImage imageNamed:@"ButtonBorder"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_selectionButton setBackgroundImage:buttonBorder forState:UIControlStateNormal];
    [_selectionButton addTarget:self action:@selector(chooseItem:) forControlEvents:UIControlEventTouchUpInside];
    [_selectionButton setTitleColor:self.tintColor forState:UIControlStateNormal];

    UIImage *downArrow = [[UIImage imageNamed:@"DownArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _downArrowView = [[UIImageView alloc] initWithImage:downArrow];
    
    // Position the arrow centred vertically on the right hand side of the button
    CGRect frame = self.selectionButton.frame;
    CGSize arrowSize = _downArrowView.bounds.size;
    frame.origin.x += frame.size.width - (arrowSize.width * 1.4f);
    frame.origin.y += (frame.size.height - arrowSize.height);
    frame.size = arrowSize;
    _downArrowView.frame = frame;
    [self addSubview:_downArrowView];
}

- (void)reset {
    self.text = @"";
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    [self.selectionButton setTitleColor:self.downArrowView.tintColor forState:UIControlStateNormal];
}

- (void)chooseItem:(id)sender {
    if (self.selectionPopover.isPopoverVisible) {
        [self.selectionPopover dismissPopoverAnimated:YES];
    }
    TXHDataSelectionViewController *dataSelector = [[TXHDataSelectionViewController alloc] initWithStyle:UITableViewStylePlain];
    dataSelector.items = self.selectionList;
    dataSelector.delegate = self;

    self.selectionPopover = [[UIPopoverController alloc] initWithContentViewController:dataSelector];
    self.selectionPopover.popoverContentSize = CGSizeMake(210.0f, (self.selectionList.count * 44.0f));
    [self.selectionPopover presentPopoverFromRect:self.selectionButton.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)dataSelectionViewController:(TXHDataSelectionViewController *)controller didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id selectedItemId = [self.selectionList objectAtIndex:indexPath.row];
    NSLog(@"selected %@", selectedItemId);
    if ([selectedItemId isKindOfClass:[NSString class]]) {
        self.text = selectedItemId;
    }
    [self.selectionPopover dismissPopoverAnimated:YES];
    
    // Send an action to anyone interested
    [[UIApplication sharedApplication] sendAction:@selector(didPerformDataSelection:) to:nil from:self forEvent:nil];
}

- (void)setText:(NSString *)text {
    _text = text;
    NSString *textToSet = self.placeholder;
    if (text.length > 0) {
        textToSet = text;
    }
    [self.selectionButton setTitle:textToSet forState:UIControlStateNormal];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    if (self.selectionButton.titleLabel.text.length == 0) {
        [self.selectionButton setTitle:placeholder forState:UIControlStateNormal];
    }
}

@end
