//
//  TransparentDrawingView.h
//  Ruby4iOS
//
//  Created by Philippe Possemiers on 15/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransparentDrawingView : UIView {
    
	CGPoint fromPoint;
    CGPoint toPoint;
}

- (void)drawLineFromX1:(int)X1 andX2:(int)X2 toY1:(int)Y1 andY2:(int)Y2;

@end
