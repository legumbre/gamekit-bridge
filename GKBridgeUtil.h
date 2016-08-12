//
//  GKBridgeUtil.h
//  
//
//  Created by leo on 7/23/16.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@class GKAchievement;
@class GKLocalPlayer;

@interface GKBridgeUtil : NSObject

// @property (nonatomic, assign) id delegate;

- (GKLocalPlayer *) localPlayer;
- (void) authenticateLocalUser;

@end
