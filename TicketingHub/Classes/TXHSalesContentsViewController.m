//
//  TXHSalesContentsViewController.m
//  TicketingHub
//
//  Created by Mark on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesContentsViewController.h"

#import "TXHEmbeddingSegue.h"
#import "TXHSalesContentProtocol.h"
#import "TXHSalesWizardViewController.h"
#import "TXHTransitionSegue.h"

@interface TXHSalesContentsViewController () <TXHSalesContentProtocol>
@property (weak, nonatomic) IBOutlet UIView *salesContentView;

// A reference to the timer view controller
@property (strong, nonatomic) TXHSalesTimerViewController *timerViewController;

// A reference to the actual content view controller
@property (strong, nonatomic) id <TXHSalesContentProtocol> contentViewController;

// A reference to the completion view controller
@property (strong, nonatomic) TXHSalesCompletionViewController *completionViewController;

@end

@implementation TXHSalesContentsViewController

@synthesize timerViewController = _timerViewController;
@synthesize completionViewController = _completionViewController;


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

	[self performSegueWithIdentifier:@"Embed Step1" sender:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (TXHSalesTimerViewController *)timerViewController {
    return _timerViewController;
}

- (void)setTimerViewController:(TXHSalesTimerViewController *)timerViewController {
    _timerViewController = timerViewController;
    if (self.contentViewController) {
        [self.contentViewController setTimerViewController:timerViewController];
    }
}

- (TXHSalesCompletionViewController *)completionViewController {
    return _completionViewController;
}

- (void)setCompletionViewController:(TXHSalesCompletionViewController *)completionViewController {
    _completionViewController = completionViewController;
    if (self.contentViewController) {
        [self.contentViewController setCompletionViewController:completionViewController];
    }
}

- (void (^)(void))completionBlock {
    return self.contentViewController.completionBlock;
}

- (void)setCompletionBlock:(void (^)(void))completionBlock {
    [self.contentViewController setCompletionBlock:completionBlock];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
#pragma unused (sender)
    if ([segue.identifier isEqualToString:@"Embed Step1"])
    {
        TXHEmbeddingSegue *embeddingSegue = (TXHEmbeddingSegue *)segue;
        embeddingSegue.containerView = self.salesContentView;
    }
    
    if ([segue isMemberOfClass:[TXHTransitionSegue class]]) {
        TXHTransitionSegue *transitionSegue = (TXHTransitionSegue *)segue;
        transitionSegue.containerView = self.salesContentView;
    }
    
    if ([segue.destinationViewController conformsToProtocol:@protocol(TXHSalesContentProtocol)]) {
        self.contentViewController = segue.destinationViewController;
        [self.contentViewController setTimerViewController:self.timerViewController];
        [self.contentViewController setCompletionViewController:self.completionViewController];
    }
}

- (void)transition:(id)sender {
    [self didChangeOption:sender];
}

#pragma mark - Payment method changed
-(void)didChangePaymentMethod:(id)sender {
    [self.contentViewController didChangePaymentMethod:sender];
}

#pragma mark - Action notifications

- (void)didChangeOption:(id)sender {
    if ([sender isKindOfClass:[TXHSalesWizardViewController class]]) {
        TXHSalesWizardViewController *controller = sender;
//        NSString *transitionId = [NSString stringWithFormat:@"Transition To Step %d", controller.step];
//        [self performSegueWithIdentifier:transitionId sender:sender];
    }
}

@end
