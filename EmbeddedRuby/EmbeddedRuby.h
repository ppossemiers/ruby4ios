//
//  EmbeddedRuby.h
//  EmbeddedRuby
//
//  Created by Philippe Possemiers on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ruby.h"

extern void Init_zlib();
extern void Init_thread();
extern void Init_RB2ObjC();

@interface EmbeddedRuby : NSObject {
	
	id _appDelegate;
	NSMutableDictionary *uiElements;
}

@property(nonatomic, retain) NSMutableDictionary *uiElements;

+ (EmbeddedRuby *)sharedInstance;
- (void)start:(UIWindow *)window withDelegate:(id)appDelegate;
- (void)stop;
- (void)registerUIElement:(UIView *)elem forKey:(NSString *)key;
- (NSString *)getScriptPath;
- (void)executeScript:(NSString *)script;
- (void)executeCommand:(NSString *)command;
- (void)printCommunicationArray;

@end