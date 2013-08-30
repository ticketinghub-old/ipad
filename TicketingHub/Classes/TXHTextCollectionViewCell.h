//
//  TXHTextCollectionViewCell.h
//  TicketingHub
//
//  Created by Mark on 09/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHBaseCollectionViewCell.h"

#import "TXHTextEntryView.h"

@interface TXHTextCollectionViewCell : TXHBaseCollectionViewCell

@property (readonly, nonatomic) TXHTextEntryView *textField;

@end
