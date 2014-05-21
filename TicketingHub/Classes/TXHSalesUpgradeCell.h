//
//  TXHSalesUpgradeCell.h
//  TicketingHub
//
//  Created by Mark on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHSalesUpgradeCell : UICollectionViewCell

@property (strong, nonatomic) NSString *upgradeName;
@property (strong, nonatomic) NSString *upgradePrice;
@property (strong, nonatomic) NSString *upgradeDescription;
@property (assign, nonatomic, getter = isChosen) BOOL chosen;

@end
