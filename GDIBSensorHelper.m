//
//  GDIBSensorHelper.m
//  GDIBSensor
//
//  Created by Guru Inamdar on 2012-11-06.
//  Copyright (c) 2012 Guruprasad Inamdar.
//

#import "GDIBSensorHelper.h"
#import "JRSwizzle.h" 

#define kSourceCodeEditorArea	@"GDISourceCodeEditorPane"
#define kStoryboardArea         @"GDICanvasEditorPane"

#define GDIBCanvasNotification  @"GDIBCanvasNotification"


@interface NSObject(GDIBSensorHook)

- (id)gdib_initWithNibName:(id)arg1 bundle:(id)arg2 document:(id)arg3;
- (id)gdib_initWithNibName:(id)arg1 bundle:(id)arg2;

- (id)gdib_selectedCategory;

@end

@implementation NSObject(GDIBSensorHook)

#pragma mark - StoryboardPane 

- (id)gdib_initWithNibName:(id)arg1 bundle:(id)arg2
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kStoryboardArea];
    return [self gdib_initWithNibName:arg1 bundle:arg2];
}


#pragma mark - SourceCodePane
- (id)gdib_initWithNibName:(id)arg1 bundle:(id)arg2 document:(id)arg3
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:kStoryboardArea]){
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kStoryboardArea];
    }
    return [self gdib_initWithNibName:arg1 bundle:arg2 document:arg3];
}


- (id)gdib_selectedCategory
{
    id selectedCategory = [self gdib_selectedCategory];
    if([[NSUserDefaults standardUserDefaults] boolForKey:kStoryboardArea]){
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kStoryboardArea];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:
                                                                GDIBCanvasNotification object:self]];
    }
    return selectedCategory;
}


@end

@implementation GDIBSensorHelper

+ (void)pluginDidLoad:(NSBundle *)plugin
{
	static id sharedPlugin = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        if (NSClassFromString(@"IDESourceCodeEditor") != NULL) {
            [NSClassFromString(@"IDESourceCodeEditor")
             jr_swizzleMethod:@selector(initWithNibName:bundle:document:)
             withMethod:@selector(gdib_initWithNibName:bundle:document:)
             error:NULL];
        }
        if (NSClassFromString(@"IBCanvasViewController") != NULL){
            [NSClassFromString(@"IBCanvasViewController")
             jr_swizzleMethod:@selector(initWithNibName:bundle:)
             withMethod:@selector(gdib_initWithNibName:bundle:)
             error:NULL];
            
		}
        if (NSClassFromString(@"IDEUtilityArea") != NULL) {
            [NSClassFromString(@"IDEUtilityArea")
             jr_swizzleMethod:@selector(selectedCategory)
             withMethod:@selector(gdib_selectedCategory)
             error:NULL];
        }
		sharedPlugin = [[self alloc] init];
	});
}

- (id)init
{
    if (self = [super init]) {
		[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidFinishLaunching:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification*)notification
{
    NSLog(@"IB Sensor finish loading..");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showInspector:)
                                                 name:GDIBCanvasNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)showInspector:(NSNotification*)notification
{
    [self performSelectorOnMainThread:@selector(executeScriptlet) withObject:nil waitUntilDone:NO];
}

- (void) executeScriptlet
{
    @try {
        NSDictionary *errorInfo;
        NSBundle *pluginBundle = [NSBundle bundleForClass:[self class]];
        
        NSString *scriptlet = [pluginBundle pathForResource:@"OpenUtility" ofType:@"scpt"];
        NSLog(@"scriptlet %@", scriptlet);
        if ([scriptlet length] > 1) {
            NSAppleScript *hack = [[[NSAppleScript alloc]initWithContentsOfURL: [NSURL fileURLWithPath:scriptlet]
                                                                         error:nil]autorelease];
            if (hack) {
                NSAppleEventDescriptor *eventDescriptor = [hack executeAndReturnError:&errorInfo];
                if (!eventDescriptor) {
                    NSLog(@"Error %@", errorInfo);
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception debugDescription]);
    }
    @finally {
        
    }
}

@end
