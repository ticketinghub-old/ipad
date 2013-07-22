//
//  TXHMainScreenPlaceholderViewController.m
//  TicketingHub
//
//  Created by Mark on 22/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHMainScreenPlaceholderViewController.h"

@interface TXHMainScreenPlaceholderViewController ()

@property (weak, nonatomic) IBOutlet UILabel *placeholder;

@end

@implementation TXHMainScreenPlaceholderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (animated) {
        [UIView animateWithDuration:0.6f delay:0.5f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.placeholder.alpha = 1.0f;
            [self.view layoutIfNeeded];
        } completion:nil];
    } else {
        self.placeholder.alpha = 1.0f;
    }
}

@end
