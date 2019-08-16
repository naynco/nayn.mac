//
//  AppDelegate.swift
//

import Cocoa

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    let popover = NSPopover();
    let dateViewController = NaynViewController(nibName: NSNib.Name(rawValue: "NaynViewController"), bundle: nil);

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name(rawValue: "StatusBarButtonImage"))
            button.action = #selector(self.statusBarButtonClicked(sender:))
            button.sendAction(on: [NSEvent.EventTypeMask.leftMouseUp, NSEvent.EventTypeMask.rightMouseUp])
        }

        popover.contentViewController = dateViewController
        popover.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
        popover.animates = false

        statusItem.highlightMode = false // Highlight bodge: Stop the highlight flicker (see async call below).

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func quit(sender: AnyObject?) {
        NSApplication.shared.terminate(nil)
    }

    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {

            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY);

            self.dateViewController.windowShown();

            DispatchQueue.main.async(execute: { // Highlight bodge: The button.action naturally adds a highlight, but is removed as soon as the popover is shown.
                    self.statusItem.highlightMode = true
                    button.isHighlighted = true
                })

        }
    }

    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
        statusItem.highlightMode = false // Highlight bodge: Stop the highlight flicker (see async call below).
    }

    @objc func statusBarButtonClicked(sender: NSStatusBarButton) {

        let event = NSApp.currentEvent!

        if event.type == NSEvent.EventType.rightMouseUp {

            closePopover(sender: nil)

            statusItem.highlightMode = true // Highlight bodge: Stop the highlight flicker (see async call below).
            statusItem.button?.isHighlighted = true

            let contextMenu = NSMenu();
            contextMenu.addItem(NSMenuItem(title: "Quit", action: #selector(self.quit(sender:)), keyEquivalent: ""))

            statusItem.menu = contextMenu
            statusItem.popUpMenu(contextMenu)
            statusItem.menu = nil // Otherwise clicks won't be processed again

        } else { // Left click

            if popover.isShown {
                closePopover(sender: sender)
            } else {
                showPopover(sender: sender)
            }

        }

    }

}

