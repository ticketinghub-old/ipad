
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

@interface TXHSignaturePadViewController ()

@property (weak, nonatomic) IBOutlet UILabel *totalPriceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIView  *contentView;

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
    self.userNameLabel.text        = self.ownerName;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self customizeContentView];
    [self setupBackground];
    [self setupDismissRecognizer];
    [self updateLabels];
}

- (void)customizeContentView
{
    self.contentView.layer.cornerRadius = 5;
}

- (void)setupBackground
{
    UIColor *blurTintColor = [[UIColor txhDarkBlueColor] colorWithAlphaComponent:0.6];
    
    UIImage *bgImage = [[UIImage screenshot] applyBlurWithRadius:3
                                                       tintColor:blurTintColor
                                           saturationDeltaFactor:1.8
                                                       maskImage:nil];
    
    UIColor *bgImgColor = [UIColor colorWithPatternImage:bgImage];
    self.view.backgroundColor = bgImgColor;
}

- (void)setupDismissRecognizer
{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
    [self.view addGestureRecognizer:recognizer];
}


- (IBAction)acceptSignatureAction:(id)sender
{
    [self.delegate txhSignaturePadViewController:self acceptSignatureWithImage:nil];
}


- (IBAction)closeButtonAction:(id)sender
{
    [self dismissSelf];
}


- (void)tapRecognized:(UITapGestureRecognizer *)recognizer
{
    [self dismissSelf];
}


- (void)dismissSelf
{
    [self.delegate txhSignaturePadViewControllerShouldDismiss:self];
}


@end
