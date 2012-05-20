//
//  ViewController.m
//  Ruby4iOS
//
//  Created by Philippe Possemiers on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "EmbeddedRuby.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	[[EmbeddedRuby sharedInstance] registerUIElement:outputTextView forKey:@"outputTextView"];
	[[EmbeddedRuby sharedInstance] registerUIElement:outputWebView forKey:@"outputWebView"];
	[[EmbeddedRuby sharedInstance] registerUIElement:drawingView forKey:@"drawingView"];
	
	NSString* path = [NSString stringWithFormat:@"%@/%@", [[EmbeddedRuby sharedInstance] getScriptPath], @"main.rb"];
	scriptView.text = [NSString stringWithContentsOfFile:path
												  encoding:NSUTF8StringEncoding
												  error:NULL];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} 
	else {
	    return YES;
	}
}

- (IBAction)clickEval:(id)sender {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//make a file name to write the data to using the documents directory:
	NSString *path = [NSString stringWithFormat:@"%@/new.rb", documentsDirectory];
	[scriptView.text writeToFile:path 
					  atomically:NO 
						encoding:NSStringEncodingConversionAllowLossy 
						   error:nil];
	
	[[EmbeddedRuby sharedInstance] executeScript:path];
}

@end
