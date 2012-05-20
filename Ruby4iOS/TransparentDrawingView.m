//
//  TransparentDrawingView.m
//  Ruby4iOS
//
//  Created by Philippe Possemiers on 15/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TransparentDrawingView.h"

@implementation TransparentDrawingView

- (void)initObject {
    // Initialization code
    [super setBackgroundColor:[UIColor clearColor]];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        [self initObject];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
	CGContextSetLineWidth(ctx, 5.0);

	CGContextMoveToPoint(ctx, fromPoint.x, fromPoint.y);
	CGContextAddLineToPoint(ctx, toPoint.x, toPoint.y);
	
	CGContextStrokePath(ctx);
}

- (void)drawLineFromX1:(int)X1 andX2:(int)X2 toY1:(int)Y1 andY2:(int)Y2 {
    
	fromPoint = CGPointMake(X1, X2);
    toPoint = CGPointMake(Y1, Y2);;
	
    // Refresh
    [self setNeedsDisplay];
}

@end
