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
#define kShowUtilityVisible     @"GDIShowUtilityVisible"

#define GDIBCanvasNotification  @"GDIBCanvasNotification"
#define GDIBWorkspaceNotification @"GDIBWorkspaceNotification"

#define GDIBCURRENTWORKSPACENAME    @"GDIBCurrentWorkspace"


@interface NSObject(GDIBSensorHook)

// SourceCodeEditor
- (id)gdib_initWithNibName:(id)arg1 bundle:(id)arg2 document:(id)arg3;

// Storyboard
- (id)gdib_initWithNibName:(id)arg1 bundle:(id)arg2;
- (id)gdib_initWithDocument:(id)arg1;
@end

@implementation NSObject(GDIBSensorHook)

#pragma mark - Helper functions
- (NSString*)findProjectName:(id)arg
{
    NSString *fileName;
    if ([arg isKindOfClass:NSClassFromString(@"NSDocument")]){
        NSString *path = [[arg fileURL]path];
        NSArray *fileNamesArray = [path pathComponents];
        if (fileNamesArray.count > 0){
            NSUInteger index = fileNamesArray.count - 1;
            while (index > 0) {
                fileName = [fileNamesArray objectAtIndex:index];
                if([[fileName pathExtension] isNotEqualTo:@""]){
                    index--;
                }else{
                    break;
                }
            }
            
        }
    }
    return fileName;
}

- (NSString*)getLastFileName:(id)arg1 onlyExtension:(BOOL)ext
{
    if ([arg1 isKindOfClass:NSClassFromString(@"NSDocument")]){
        NSString *path = [[arg1 fileURL]path];
        NSArray *fileNamesArray = [path pathComponents];
        if (fileNamesArray.count > 0) {
            if (ext) {
                return [[fileNamesArray objectAtIndex:fileNamesArray.count -1] pathExtension];
            }else{
                return [fileNamesArray objectAtIndex:fileNamesArray.count -1] ;
            }
        
        }
    }
    return @"";
}

#pragma mark - StoryboardPane

- (id)gdib_initWithDocument:(id)arg1
{
    BOOL notificationEnabled = NO;
    if([[NSUserDefaults standardUserDefaults] boolForKey:kStoryboardArea])
    {
        NSString *extension = [self getLastFileName:arg1 onlyExtension:TRUE];
        if ([extension isEqualToString:@"storyboard"] || [extension isEqualToString:@"xib"]
             || [extension isEqualToString:@"nib"]){
        
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kStoryboardArea];
    
            // Get WorkspaceName for this xib
            NSDictionary *info = [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:[self findProjectName:arg1], extension, nil]
                                                             forKey:kStoryboardArea];
        
            [[NSUserDefaults standardUserDefaults]setObject:[[info valueForKey:kStoryboardArea]objectAtIndex:0]
                                                     forKey:GDIBCURRENTWORKSPACENAME];

            [[NSNotificationCenter defaultCenter]postNotificationName:GDIBWorkspaceNotification
                                                               object:self
                                                             userInfo:info];
        }
        notificationEnabled = TRUE;
    }
    return [self gdib_initWithDocument:arg1];
}

- (id)gdib_initWithNibName:(id)arg1 bundle:(id)arg2
{
    //storyboard opened up but we dont have file name yet
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kStoryboardArea];
    return [self gdib_initWithNibName:arg1 bundle:arg2];
}

#pragma mark - SourceCodePane
- (id)gdib_initWithNibName:(id)arg1 bundle:(id)arg2 document:(id)arg3
{
    NSString *fileName = [self getLastFileName:arg3 onlyExtension:NO];
    if (fileName.length > 1){
        NSLog(@"arg1 %@", arg3);
        NSString *name = [self getLastFileName:arg3 onlyExtension:NO];
        NSDictionary *info = [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:[self findProjectName:arg3], name, nil]
                                                         forKey:kSourceCodeEditorArea];
        [[NSNotificationCenter defaultCenter]postNotificationName:GDIBWorkspaceNotification
                                                           object:self
                                                         userInfo:info];
    }
    
//    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:
//                                                                GDIBCanvasNotification object:self]];
    return [self gdib_initWithNibName:arg1 bundle:arg2 document:arg3];
}

@end

@interface GDIBSensorHelper()
@property (nonatomic, strong)NSMutableDictionary *activeProjects;

@end

@implementation GDIBSensorHelper
@synthesize activeProjects;

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
        if (NSClassFromString(@"IBDocumentStructureRepresentation") != NULL){
            [NSClassFromString(@"IBDocumentStructureRepresentation")
             jr_swizzleMethod:@selector(initWithDocument:)
             withMethod:@selector(gdib_initWithDocument:)
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
        activeProjects = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification*)notification
{
    NSLog(@"IB Sensor finish loading.");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeCurrentProject:)
                                                 name:GDIBWorkspaceNotification object:nil ];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.activeProjects removeAllObjects];
    self.activeProjects = nil;
    [super dealloc];
}


#pragma mark - Notification Methods
- (void)storeCurrentProject:(NSNotification*)notification
{
    __block BOOL xibAlreadyOpened = NO;
    if (notification.userInfo) {
        NSDictionary *tempList = notification.userInfo;
        NSEnumerator *enumerateKeys = tempList.keyEnumerator;
        id key;
        while (key = [enumerateKeys nextObject]) {
            NSArray *values = [tempList objectForKey:key];
            
            // The first value in array is key but store xib's with different key
        
            NSString *tmpKey = [values objectAtIndex:0];
            NSString *xibKey = [tmpKey stringByAppendingFormat:@"-%@", @"XIB"];
            
            [self.activeProjects enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop){
                if([key isEqualTo:xibKey]){
                    *stop=YES;
                    xibAlreadyOpened = YES;
                }
            }];
            //Check if we are being called by xib
            if ([[NSUserDefaults standardUserDefaults]objectForKey:GDIBCURRENTWORKSPACENAME]) {
                [self.activeProjects setValue:[values objectAtIndex:1] forKey:xibKey];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:GDIBCURRENTWORKSPACENAME];
                if (!xibAlreadyOpened) {
                    [self showInspector];
                    break;
                }
            }else{
                if (xibAlreadyOpened) {
                    [self showInspector];
                    [self.activeProjects removeObjectForKey:xibKey];
                }
                [self.activeProjects setValue:[values objectAtIndex:1] forKey:[values objectAtIndex:0]];
            }
            NSLog(@"new Dictionary %@", self.activeProjects);
        }
    }
}

                                                               
- (void)showInspector
{
    NSLog(@"Inside showInspector condition");
    [self performSelectorOnMainThread:@selector(executeScriptlet) withObject:nil waitUntilDone:NO];
}

+ (NSString*)getProjectName
{
    NSBundle *pluginBundle = [NSBundle bundleForClass:[self class]];
    NSDictionary *bundleInfo = [pluginBundle infoDictionary];
    return [NSString stringWithFormat:@"%@",[bundleInfo objectForKey:@"CFBundleName"]];
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
