//
//  GKBridgeUtil.m
//
//  A minimal framework that implements a C shim for a subset of GameKit (GameCenter) functions.
//
//  Why do I want this? Because:
//
//  1. I can use the exposed functions through LuaJIT's FFI
//  2. I want a drop-in shared library I can ship along a vanilla Love2D build.
//
//  Currently exposed functions so far:
//
//   - gkbridge_auth_local_user
//   - gkbridge_report_achievement
//   - gkbridge_reset_achievements
//
//  Created by Leonardo Etcheverry <leo@kalio.net> on 7/23/16.
//

#import "GKBridgeUtil.h"

@implementation GKBridgeUtil

+(id) shared
{
    // thread-safe singleton
    static dispatch_once_t pred = 0;
    __strong static id _shared = nil;
    dispatch_once(&pred, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}


- (void) authenticateLocalUser
{
  GKLocalPlayer *lp = [GKLocalPlayer localPlayer];
  
  if(lp.authenticated == NO)
    {
      lp.authenticateHandler = ^(NSViewController *viewController, NSError *error)
        {
          if (error)
            {
              NSLog(@"authCallback with error: %@", error.localizedDescription);
            }
          else
            {
              if (viewController == nil)
                {
                  NSLog(@"viewController nil, auth process completed. User authenticated: %d\n", lp.isAuthenticated);

                }
              else
                {
                  NSLog(@"viewController not nil, I don't know how to do display this yet!\n");
                }
            }
        };
    }
}

- (GKLocalPlayer *) localPlayer
{
  return [GKLocalPlayer localPlayer];
}

-(void) dealloc
{
    [super dealloc];
}

/*
**************************************************
*  Public C functions exported by this framework *
**************************************************
*/

void gkbridge_auth_local_user()
{
  NSLog(@"@gkbridge_auth_local_user");

  dispatch_async(dispatch_get_main_queue(), ^(void)
                 {
                   // non-blocking, a ProcessGameCenterAuth callback will be called when done.
                   [[GKBridgeUtil shared] authenticateLocalUser];
                 });
}

BOOL gkbridge_local_user_authenticated()
{
  return [[GKLocalPlayer localPlayer] isAuthenticated];
}

void gkbridge_report_achievement(const char *achId, float progress, bool banner)
{
  if (achId)
    {
      NSString *identifier = [NSString stringWithCString:achId encoding:NSUTF8StringEncoding];
      GKAchievement *ach = [[GKAchievement alloc] initWithIdentifier:identifier];
      ach.percentComplete = progress;
      NSArray *achs = [NSArray arrayWithObject:ach];

      [GKAchievement reportAchievements:achs withCompletionHandler:^(NSError *error)
           {
             if (error != nil)
               {
                 NSLog(@"(completionHandler) Error reporting achievement %@: %@", identifier, error);
               }
             else
               {
                 NSLog(@"(completionHandler) successfully reported achievement: %@", identifier);
               }
           }];
    }
}

void gkbridge_reset_achievements()
{
  [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
                 {
                   if (error != nil)
                     {
                       NSLog(@"Error resetting achievements: %@", error);
                     }
                 }];
}

@end
