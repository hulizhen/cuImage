#ifdef __OBJC__
#import <Cocoa/Cocoa.h>
#endif

#import "MASDictionaryTransformer.h"
#import "MASHotKey.h"
#import "MASKeyCodes.h"
#import "MASKeyMasks.h"
#import "MASLocalization.h"
#import "MASShortcut.h"
#import "MASShortcutBinder.h"
#import "MASShortcutMonitor.h"
#import "MASShortcutValidator.h"
#import "MASShortcutView+Bindings.h"
#import "MASShortcutView.h"
#import "Shortcut.h"

FOUNDATION_EXPORT double MASShortcutVersionNumber;
FOUNDATION_EXPORT const unsigned char MASShortcutVersionString[];

