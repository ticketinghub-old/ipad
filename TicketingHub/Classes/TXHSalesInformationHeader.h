//
//  TXHSalesInformationHeader.h
//  TicketingHub
//
//  Created by Mark on 08/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHSalesInformationHeader;

@protocol TXHSalesInformationHeaderDelegate <NSObject>

- (void)txhSalesInformationHeaderIsExpandedDidChange:(TXHSalesInformationHeader *)header;

@end


@interface TXHSalesInformationHeader : UICollectionReusableView

@property (weak, nonatomic) id<TXHSalesInformationHeaderDelegate> delegate;
@property (assign, nonatomic,getter = isExpanded) BOOL expanded;
@property (strong, nonatomic) NSString *tierTitle;
@property (assign, nonatomic) NSUInteger section;


@end
