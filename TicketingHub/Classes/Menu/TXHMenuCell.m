//
//  TXHMenuCell.m
//  TicketingHub
//
//  Created by Mark on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHMenuCell.h"

@interface TXHMenuCell ()

@property (strong, nonatomic) UIImageView *shadowImage;
@property (strong, nonatomic) UIImage *shadow;

@end

@implementation TXHMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _shadow = [[UIImage imageNamed:@"shadow"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0f, 0.0f, 0.0f, 0.0f) resizingMode:UIImageResizingModeTile];
        _shadowImage = [[UIImageView alloc] initWithImage:_shadow];
        [self addSubview:_shadowImage];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.shadowImage.bounds;
    frame.size.height = self.frame.size.height;
    frame.origin.x = self.frame.size.width - frame.size.width;
    self.shadowImage.frame = frame;
}

@end
