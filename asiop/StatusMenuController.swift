//
//  StatusMenuController.swift
//  asiop
//
//  Created by Lubomír Klimeš on 22/07/16.
//  Copyright © 2016 lubkli. All rights reserved.
//

import Cocoa

class StatusMenuController : NSObject {
    
    //@IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    override func awakeFromNib() {
        let icon = NSImage(named: "statusIcon")
        icon?.template = true // best for dark mode
        statusItem.image = icon
        //statusItem.title = "ATARI SIO"
        statusItem.menu = statusMenu
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
}
