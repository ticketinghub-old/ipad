//
//  TXHSensorView.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 03/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHSensorView;

@protocol TXHSensorViewDelegate

- (void)sensorViewDidRecognizeTap:(TXHSensorView *)view;

@end

@interface TXHSensorView : UIView

@property (weak, nonatomic) id<TXHSensorViewDelegate> delegate;

@end
