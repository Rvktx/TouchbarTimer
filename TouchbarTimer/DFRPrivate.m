//
//  DFRPrivate.m
//  TouchbarTimer
//
//  Created by Mikołaj Knysak on 01/11/2018.
//  Copyright © 2018 Mikołaj Knysak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFRPrivate.h"

@implementation NSTouchBarItem (DFRAccess)

- (void)addToControlStrip {
    [NSTouchBarItem addSystemTrayItem:self];
    
    [self toggleControlStripPresence:true];
}

- (void)toggleControlStripPresence:(BOOL)present {
    DFRElementSetControlStripPresenceForIdentifier(self.identifier, present);
}

@end

@implementation NSTouchBar (DFRAccess)

- (void)presentAsSystemModalForItem:(NSTouchBarItem *)item {
    [NSTouchBar presentSystemModalTouchBar:self systemTrayItemIdentifier:item.identifier];
}

- (void)dismissSystemModal {
    [NSTouchBar dismissSystemModalTouchBar:self];
}

- (void)minimizeSystemModal {
    [NSTouchBar minimizeSystemModalTouchBar:self];
}

@end

@implementation NSControlStripTouchBarItem

- (void)setIsPresentInControlStrip:(BOOL)present {
    _isPresentInControlStrip = present;
    
    if (present) {
        [super addToControlStrip];
    }
    else {
        [super toggleControlStripPresence:false];
    }
}

@end

