//
//  CMAppDelegate.m
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/5/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import "CMAppDelegate.h"

#import "CMViewController.h"
#import "CMCrashReporter.h"

@implementation CMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
   
    
    // Override point for customization after application launch.
    CGRect r = [[UIScreen mainScreen] bounds];
    CGFloat h = r.size.height;
    NSLog(@"Screen Size %lf",h);
    if(h==568.0f){
        self.iOStype=1;
    }else if(h==480.0f){
        self.iOStype=2;
    }
    
    CMViewController *vc=[[CMViewController alloc] initWithNibName:@"CMViewController" bundle:nil];
    UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:vc];
    self.viewController = nav;

    self.playerViewController=[[CMPlayerViewController alloc] initWithNibName:@"CMPlayerViewController" bundle:nil];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    
    if( [[NSUserDefaults standardUserDefaults] stringForKey:@"failLog"]){
        NSString *log=[[NSUserDefaults standardUserDefaults] stringForKey:@"failLog"];
       // NSLog(@"failLog:%@",log);
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"failLog"];
        [CMCrashReporter reportCrash:log];
    }else{
        NSLog(@"No Error");
    }

    NSSetUncaughtExceptionHandler(&exceptionHandler);
    return YES;
}



//http://www.yoheim.net/blog.php?q=20130113
void exceptionHandler(NSException *exception) {
    NSString *log = [NSString stringWithFormat:@"%@, %@, %@", exception.name, exception.reason, exception.callStackSymbols];
    [[NSUserDefaults standardUserDefaults] setValue:log forKey:@"failLog"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Respond to remote control events
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {

    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self.playerViewController play_pushed:nil];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self.playerViewController previous_pushed:nil];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [self.playerViewController next_pushed:nil];
                break;
                
            default:
                break;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
