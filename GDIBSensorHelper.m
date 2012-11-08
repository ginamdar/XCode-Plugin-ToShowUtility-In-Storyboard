//
//  GDIBSensorHelper.m
//  GDIBSensor
//
//  Created by Guru Inamdar on 2012-11-03.
//  Copyright (c) 2012 Guruprasad Inamdar. All rights reserved.
//

#import "GDIBSensorHelper.h"
#import "JRSwizzle.h" 

#define kSourceCodeEditorArea	@"GDISourceCodeEditorPane"
#define kStoryboardArea         @"GDICanvasEditorPane"

#define GDIBCanvasNotification  @"GDIBCanvasNotification"


@interface NSObject(GDIBSensorHook)

- (id)gdib_initWithNibName:(id)arg1 bundle:(id)arg2 document:(id)arg3;
- (id)gdib_initWithNibName:(id)arg1 bundle:(id)arg2;

- (void)gdib_noteUserDidExplicitlyChooseChoice:(id)arg1;
- (void)gdib_userSelectedCategoryChoiceFromMenu:(id)arg1;
- (id)gdib_selectedCategory;

- (void)gdib_toggleUtilitiesVisibility:(id)sender;
- (void)showUtilities;
- (void)gdib_showUtilitiesArea:(id)sender;

@end

@implementation NSObject(GDIBSensorHook)

#pragma mark - StoryboardPane 
- (id)gdib_initWithNibName:(id)arg1 bundle:(id)arg2
{
    NSLog(@"gdib_initWithNibName-IB %@, %@", arg1, arg2);
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kStoryboardArea];
    return [self gdib_initWithNibName:arg1 bundle:arg2];
}

-(void)gdib_noteUserDidExplicitlyChooseChoice:(id)arg1;
{
    NSLog(@"gdib_noteUserDidExplicitlyChooseChoice:%@",arg1);
    [self gdib_noteUserDidExplicitlyChooseChoice:arg1];
}

- (void)gdib_userSelectedCategoryChoiceFromMenu:(id)arg1
{
    NSLog(@"gdib_userSelectedCategoryChoiceFromMenu %@",arg1);
    [self gdib_userSelectedCategoryChoiceFromMenu:arg1];
}


#pragma mark - SourceCodePane
- (id)gdib_initWithNibName:(id)arg1 bundle:(id)arg2 document:(id)arg3
{
    NSLog(@"gdib_initWithNibName %@, %@, %@", arg1, arg2, arg3);
    if([[NSUserDefaults standardUserDefaults] boolForKey:kStoryboardArea]){
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kStoryboardArea];
    }
    return [self gdib_initWithNibName:arg1 bundle:arg2 document:arg3];
}


- (id)gdib_selectedCategory
{
    id selectedCategory = [self gdib_selectedCategory];
    [self showUtilities];
    return selectedCategory;
}


- (void)gdib_toggleUtilitiesVisibility:(id)sender
{
    NSLog(@"gdib_toggleUtilitiesVisibility %@", sender);
    [self gdib_toggleUtilitiesVisibility:sender];
}

- (void)gdib_showUtilitiesArea:(id)sender
{
    NSLog(@"gdib_showUtilitiesArea %@", sender);
    [self gdib_showUtilitiesArea:sender];
}

- (void)showUtilities
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kStoryboardArea] == NO) {
        return;
    }
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kStoryboardArea];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:
                                                            GDIBCanvasNotification object:self]];
}

@end

@implementation GDIBSensorHelper

+ (void)pluginDidLoad:(NSBundle *)plugin
{
	static id sharedPlugin = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        if (NSClassFromString(@"IDESourceCodeEditor") != NULL) {
//            NSLog(@"WORK ON HOOK NOW %@", plugin.description);
            
            [NSClassFromString(@"IDESourceCodeEditor")
             jr_swizzleMethod:@selector(initWithNibName:bundle:document:)
             withMethod:@selector(gdib_initWithNibName:bundle:document:)
             error:NULL];
            
            [NSClassFromString(@"IBCanvasViewController")
             jr_swizzleMethod:@selector(initWithNibName:bundle:)
             withMethod:@selector(gdib_initWithNibName:bundle:)
             error:NULL];
		}
        
        if (NSClassFromString(@"IDEUtilityArea") != NULL) {
//            NSLog(@"WORK ON HOOK NOW %@", plugin.description);
            [NSClassFromString(@"IDEUtilityArea")
             jr_swizzleMethod:@selector(noteUserDidExplicitlyChooseChoice:)
             withMethod:@selector(gdib_noteUserDidExplicitlyChooseChoice:)
             error:NULL];
            
            [NSClassFromString(@"IDEUtilityArea")
             jr_swizzleMethod:@selector(selectedCategory)
             withMethod:@selector(gdib_selectedCategory)
             error:NULL];
            
            [NSClassFromString(@"IDEUtilityArea")
             jr_swizzleMethod:@selector(userSelectedCategoryChoiceFromMenu:)
             withMethod:@selector(gdib_userSelectedCategoryChoiceFromMenu:) error:NULL];
        }
        if (NSClassFromString(@"IDEWorkspaceTabController") != NULL) {
            NSLog(@"IDEWorkspaceTabController");
            [NSClassFromString(@"IDEWorkspaceTabController")
             jr_swizzleMethod:@selector(toggleUtilitiesVisibility:)
             withMethod:@selector(gdib_toggleUtilitiesVisibility:) error:NULL];
            
            
            NSLog(@"IDEWorkspaceTabController");
            [NSClassFromString(@"IDEWorkspaceTabController")
             jr_swizzleMethod:@selector(showUtilitiesArea:)
             withMethod:@selector(gdib_showUtilitiesArea:) error:NULL];
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
    NSLog(@"XCODE DIDFINISH LAUNCHING");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showInspector:)
                                                 name:GDIBCanvasNotification object:nil];
}

- (void)activateFileInspector:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSLog(@"GDBISensor userInfo %@", userInfo);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)showInspector:(NSNotification*)notification
{
    NSBundle *pluginBundle = [NSBundle bundleForClass:[self class]];
    
    NSDictionary *errorInfo;
    NSString *scriptlet = [pluginBundle pathForResource:@"OpenUtility" ofType:@"scpt"];
    NSLog(@"scriptlet %@", scriptlet);
    if ([scriptlet length] > 1) {
        NSAppleScript *hack = [[[NSAppleScript alloc]initWithContentsOfURL: [NSURL fileURLWithPath:scriptlet]
                                                                     error:&errorInfo]autorelease];
        if (hack) {
            NSLog(@"success in script");
            NSAppleEventDescriptor *eventDescriptor = [hack executeAndReturnError:&errorInfo];
            if (!eventDescriptor) {
                NSLog(@"ERROR/SUCCESS %@", errorInfo);
            }
            else{
                NSLog(@"ERROR %@", errorInfo);
            }
        }
    }

}

@end
