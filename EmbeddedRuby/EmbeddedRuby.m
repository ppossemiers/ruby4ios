//
//  EmbeddedRuby.m
//  EmbeddedRuby
//
//  Created by Philippe Possemiers on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmbeddedRuby.h"

@implementation EmbeddedRuby

@synthesize uiElements;

static EmbeddedRuby *myGlobal = nil;

+ (EmbeddedRuby *)sharedInstance {
	
    if (myGlobal == nil) {
		myGlobal = [[self alloc] init];
    }
    return myGlobal;
}

- (id)init {
	
	if (self = [super init]) {
		uiElements = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)start:(UIWindow *)window withDelegate:(id)appDelegate {
	
	{
		RUBY_INIT_STACK;
		ruby_init();
		Init_zlib();
		//Init_thread();
		Init_RB2ObjC();
	}
	
	_appDelegate = appDelegate;
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
	[window setUserInteractionEnabled:YES];
	[window setMultipleTouchEnabled:YES];
	[window makeKeyAndVisible];
}

- (void)stop {
	
	ruby_finalize();
	ruby_stop(0);
}

- (void)registerUIElement:(UIView *)elem forKey:(NSString *)key {
	
	[uiElements setObject:elem forKey:key];
}

- (NSString *)getScriptPath {
	
	return [NSString stringWithFormat:@"%@/scripts", [[NSBundle mainBundle] resourcePath]];
}

- (void)executeCommand:(NSString *)command {
	
	rb_eval_string([command UTF8String]);
}

- (void)executeScript:(NSString *)script {
	
	int status;
	rb_load_protect(rb_str_new2([script UTF8String]), 0, &status);
	
	if (status) {
		em_error(status);
	}
}

- (void)printCommunicationArray {
	
	VALUE temp = rb_gv_get("$RB2OBJCArray");
	int c;
	for (c = 0; c < RARRAY(temp)->len; c++) {
		NSLog(@"%s", RSTRING(RARRAY(temp)->ptr[c])->ptr);
	}		
}

- (void)dealloc {
	
	[super dealloc];
	[uiElements dealloc];
	[myGlobal dealloc];
}

void em_error(int state) {
	
	VALUE err = rb_funcall(rb_gv_get("$!"), Qnil, 0, 0);
	
	NSLog(@"RubyError : %s", StringValueCStr(err));
	if (!NIL_P(ruby_errinfo)) {
		VALUE ary = rb_funcall(ruby_errinfo, rb_intern("backtrace"), 0);
		int c;
		for (c = 0; c < RARRAY(ary)->len; c++) {
			NSLog(@"\tfrom %s", RSTRING(RARRAY(ary)->ptr[c])->ptr);
		}		
	}
}

@end