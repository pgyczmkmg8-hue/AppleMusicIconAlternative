#import <UIKit/UIKit.h>

// Plain Objective-C, so no Swift runtime is loaded, and no window is created.
//
// Default (automation mode): the app dies at once, before any scene exists, so no app switcher card is left.
// A Shortcuts automation ("When the app is opened" -> Open App: Music) is what opens Apple Music.
//
// Built with -DDIRECT_OPEN (DIRECT_OPEN=1 ./build.sh): the app opens Apple Music itself, with music://, the
// moment the scene connects. iOS 27 traps apps that do not use the scene lifecycle, hence the scene delegate.

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@end

@implementation AppDelegate
@end

@interface SceneDelegate : UIResponder <UIWindowSceneDelegate>
@end

@implementation SceneDelegate {
	BOOL _pending;
	BOOL _done;
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
	[self openMusic];
}

// Retries when the request made while connecting was not accepted yet, and reopens on every return to the app.
- (void)sceneDidBecomeActive:(UIScene *)scene {
	[self openMusic];
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
	_done = NO;
}

- (void)openMusic {
	if (_done || _pending) return;
	_pending = YES;
	[UIApplication.sharedApplication openURL:[NSURL URLWithString:@"music://"] options:@{} completionHandler:^(BOOL success) {
		self->_pending = NO;
		self->_done = success;
	}];
}

@end

int main(int argc, char *argv[]) {
#ifndef DIRECT_OPEN
	abort();
#endif
	return UIApplicationMain(argc, argv, nil, NSStringFromClass(AppDelegate.class));
}
