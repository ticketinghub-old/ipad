
//
//  TXHSignaturePadViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 19/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHSignaturePadViewController.h"
#import "UIImage+ImageEffects.h"
#import "UIColor+TicketingHub.h"
#import "TXHBorderedButton.h"
#import <PPSSignatureView/PPSSignatureView.h>

static void * kSIgnatureViewHasSignatureContext = &kSIgnatureViewHasSignatureContext;

@interface TXHSignaturePadViewController ()

@property (weak, nonatomic) IBOutlet TXHBorderedButton *acceptButton;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceValueLabel;
@property (weak, nonatomic) IBOutlet UIView  *contentView;
@property (weak, nonatomic) IBOutlet PPSSignatureView *signatureView;

@end

@implementation TXHSignaturePadViewController

-(void)setTotalPriceString:(NSString *)totalPriceString
{
    _totalPriceString = totalPriceString;
    [self updateLabels];
}

- (void)setOwnerName:(NSString *)ownerName
{
    _ownerName = ownerName;
    [self updateLabels];
}

- (void)updateLabels
{
    self.totalPriceValueLabel.text = self.totalPriceString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self customizeContentView];
    [self setupBackground];
    [self updateLabels];
    [self observeSignatureView];
}

- (void)customizeContentView
{
    self.contentView.layer.cornerRadius = 12;
}

- (void)setupBackground
{
    UIColor *blurTintColor = [UIColor colorWithRed:6.0f / 255.0f
                                             green:69.0f / 255.0f
                                              blue:111.0f / 255.0f
                                             alpha:0.2f];
    
    UIImage *bgImage = [[UIImage screenshot] applyBlurWithRadius:20
                                                       tintColor:blurTintColor
                                           saturationDeltaFactor:1.8
                                                       maskImage:nil];
    
    UIColor *bgImgColor = [UIColor colorWithPatternImage:bgImage];
    self.view.backgroundColor = bgImgColor;
}

- (void)observeSignatureView
{
    [self.signatureView addObserver:self
                         forKeyPath:@"hasSignature"
                            options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                            context:kSIgnatureViewHasSignatureContext];
}

- (void)stopObservingSignatureView
{
    [self.signatureView removeObserver:self
                            forKeyPath:@"hasSignature"
                               context:kSIgnatureViewHasSignatureContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kSIgnatureViewHasSignatureContext)
    {
        self.acceptButton.enabled = self.signatureView.hasSignature;
    }
}

- (IBAction)acceptSignatureAction:(id)sender
{
    [self.delegate txhSignaturePadViewController:self acceptSignatureWithImage:nil];
}


- (IBAction)closeButtonAction:(id)sender
{
    [self dismissSelf];
}

- (IBAction)clearButtonAction:(id)sender
{
    [self.signatureView erase];
}

- (void)dismissSelf
{
    [self.delegate txhSignaturePadViewControllerShouldDismiss:self];
}

- (void)dealloc
{
    [self stopObservingSignatureView];
}

- (NSString *)SVGSignature
{
    return [self.signatureView svgPath];
}


@end
