//
//  DFRPrivate.h
//  TouchbarTimer
//
//  Created by Mikołaj Knysak on 01/11/2018.
//  Copyright © 2018 Mikołaj Knysak. All rights reserved.
//

#ifndef DFRPrivate_h
#define DFRPrivate_h

#import <AppKit/AppKit.h>

extern void DFRElementSetControlStripPresenceForIdentifier(NSString *, BOOL);
extern void DFRSystemModalShowsCloseBoxWhenFrontMost(BOOL);

@interface NSTouchBarItem ()

+ (void)addSystemTrayItem:(NSTouchBarItem *)item;

@end

@interface NSTouchBarItem (DFRAccess)

- (void)addToControlStrip;

- (void)toggleControlStripPresence:(BOOL)present;

@end

@interface NSTouchBar ()

+ (void)presentSystemModalTouchBar:(NSTouchBar *)touchBar
             systemTrayItemIdentifier:(NSString *)identifier;

+ (void)dismissSystemModalTouchBar:(NSTouchBar *)touchBar;

+ (void)minimizeSystemModalTouchBar:(NSTouchBar *)touchBar;

@end

@interface NSTouchBar (DFRAccess)

- (void)presentAsSystemModalForItem:(NSTouchBarItem *)item;

- (void)dismissSystemModal;

- (void)minimizeSystemModal;

@end

@interface NSControlStripTouchBarItem: NSCustomTouchBarItem

@property (nonatomic) BOOL isPresentInControlStrip;

@end

#endif /* DFRPrivate_h */
