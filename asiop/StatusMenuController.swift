//
//  StatusMenuController.swift
//  asiop
//
//  Created by Lubomír Klimeš on 22/07/16.
//  Copyright © 2016 lubkli. All rights reserved.
//

import Cocoa

class StatusMenuController : NSObject {
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    let popover = NSPopover()
    
    var eventMonitor: EventMonitor?
    
    var preferencesWindowController: PreferencesWindowController?
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    
    override func awakeFromNib() {
        let icon = NSImage(named: "statusIcon")
        icon?.template = true // best for dark mode
        statusItem.image = icon
        //statusItem.title = "ATARI SIO"
        statusItem.menu = statusMenu
        
        popover.contentViewController = PeripheralsViewController(nibName: "PeripheralsViewController", bundle: nil)
        popover.appearance = NSAppearance.init(named: NSAppearanceNameAqua)
        
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
    
    @IBAction func peripheralsClicked(sender: AnyObject) {
        if (popover.shown) {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    @IBAction func preferencesClicked(sender: AnyObject) {
        if (preferencesWindowController == nil) {
            preferencesWindowController = PreferencesWindowController(windowNibName: "PreferencesWindowController")
        }
        
        preferencesWindowController?.showWindow(self)
        preferencesWindowController?.window?.makeKeyAndOrderFront(nil)
        
        NSApplication.sharedApplication().activateIgnoringOtherApps(true)
    }
    
    @IBAction func aboutClicked(sender: AnyObject) {
        let alert = NSAlert()
        alert.messageText = "About SIO Peripherals"
        alert.informativeText = "SIO Peripherals emulator for 8-bit ATARI Computers.\n\nFor proper operation is necessary attached SIO2PC interface.\n\nProject home is at https://github.com/lubkli/asiop"
        alert.addButtonWithTitle("OK")
        alert.runModal()
        /* let result = alert.runModal()
         switch(result) {
         case NSAlertFirstButtonReturn:
         ...
         default:
         break
         } */
    }

    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
}
