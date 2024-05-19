#import <Foundation/Foundation.h>
#include <ApplicationServices/ApplicationServices.h>

//Reverses mouse scrolling for non-continuous scroll devices(mice)
CGEventRef eventTapCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    if (type == kCGEventScrollWheel) {
        int64_t isContinuous = CGEventGetIntegerValueField(event, kCGScrollWheelEventIsContinuous);
        if (!isContinuous) {
                int64_t deltaY = CGEventGetIntegerValueField(event, kCGScrollWheelEventDeltaAxis1);
                CGEventSetIntegerValueField(event, kCGScrollWheelEventDeltaAxis1, -deltaY);
        }
    }
    return event;
}

CFMachPortRef eventTap = NULL;
CFRunLoopSourceRef runLoopSource = NULL;

_Bool startEventTap(void) {
    if (eventTap) return true;

    
    const NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @YES};
    _Bool isTrusted = AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options);

    if (!isTrusted) {
        NSLog(@"Please grant permission in System Preferences.");
        return false;
    }
    eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, 0, CGEventMaskBit(kCGEventScrollWheel), eventTapCallback, NULL);
    
    if (!eventTap) {
        NSLog(@"Failed to create event tap");
        return false;
    }

    runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
    CGEventTapEnable(eventTap, true);
    return true;
}

void stopEventTap(void) {
    if (!eventTap) return;

    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
    CFRelease(runLoopSource);
    CFRelease(eventTap);
    eventTap = NULL;
    runLoopSource = NULL;
}
