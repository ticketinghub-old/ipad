//
//  TXHEventCollectionViewCell.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHEventCollectionViewCell : UICollectionViewCell

- (void)setTimeString:(NSString *)text;
- (void)setSpacesString:(NSString *)text;
- (void)setPriceString:(NSString *)text;

@end
