//
//  AppDelegate.swift
//  MarkdownFormat
//
//  Created by JH on 2023/5/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    lazy var windowController: MainWindowController = .init()


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        windowController.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
