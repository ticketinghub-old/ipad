//
//  TXHEmbeddingSegue.h
//  TicketingHub
//
//  Created by Mark on 22/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHEmbeddingSegue : UIStoryboardSegue

// not initializers so you can st those in prepare for segue
@property (weak, nonatomic) UIView           *containerView;
@property (weak, nonatomic) UIViewController *previousController;

@end
