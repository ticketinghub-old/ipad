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

// A popover controller allowing an item to be selected
@property (strong, nonatomic) UIPopoverController *selectionPopover;

@end

@implementation TXHDataSelectionView

- (void)setupDataContent {
    [super setupDataContent];
    _selectionButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _selectionButton.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"Counter"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [_selectionButton addTarget:self action:@selector(chooseItem:) forControlEvents:UIControlEventTouchUpInside];
    [self updateDataContentView:_selectionButton];
}

- (void)reset {
    self.text = @"";
}

- (void)chooseItem:(id)sender {
    if (self.selectionPopover.isPopoverVisible) {
        [self.selectionPopover dismissPopoverAnimated:YES];
    }
    TXHDataSelectionViewController *dataSelector = [[TXHDataSelectionViewController alloc] initWithStyle:UITableViewStylePlain];
    dataSelector.items = self.selectionList;

    self.selectionPopover = [[UIPopoverController alloc] initWithContentViewController:dataSelector];
    self.selectionPopover.popoverContentSize = CGSizeMake(210.0f, (self.selectionList.count * 44.0f));
    [self.selectionPopover presentPopoverFromRect:self.selectionButton.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)dataSelectionViewController:(TXHDataSelectionViewController *)controller didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected %@", [self.selectionList objectAtIndex:indexPath.row]);
}

@end
