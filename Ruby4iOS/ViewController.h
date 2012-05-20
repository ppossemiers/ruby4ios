//
//  ViewController.h
//  Ruby4iOS
//
//  Created by Philippe Possemiers on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransparentDrawingView.h"

@interface ViewController : UIViewController {
	
	IBOutlet UITextView *scriptView;
	IBOutlet UITextView *outputTextView;
	IBOutlet UIWebView *outputWebView;
	IBOutlet TransparentDrawingView *drawingView;
}

- (IBAction)clickEval:(id)sender;

@end
