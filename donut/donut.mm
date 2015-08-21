#import <Preferences/Preferences.h>

@interface donutListController: PSListController {
}
@end

@implementation donutListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"donut" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
