//
//  StatusMenuController.swift
//  asiop
//
//  Created by Lubomír Klimeš on 22/07/16.
//  Copyright © 2016 lubkli. All rights reserved.
//

import Cocoa

class StatusMenuController : NSObject {
    
    let popover = NSPopover()
    
    var eventMonitor: EventMonitor?
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    override func awakeFromNib() {
        let icon = NSImage(named: "statusIcon")
        icon?.template = true // best for dark mode
        statusItem.image = icon
        //statusItem.title = "ATARI SIO"
        statusItem.menu = statusMenu
        
        popover.contentViewController = PreferencesViewController(nibName: "PreferencesViewController", bundle: nil)
        
        eventMonitor = EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask]) { [unowned self] event in
            if self.popover.shown {
                self.closePopover(event)
            }
        }
        eventMonitor?.start()
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
        }
        
        eventMonitor?.start()
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
        
        eventMonitor?.stop()
    }
    
    @IBAction func preferencesClicked(sender: AnyObject) {
        if (popover.shown) {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
}
