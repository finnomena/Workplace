//
//  AppDelegate.swift
//  Workplace
//
//  Created by Pitchmak Sareerat on 5/30/2561 .
//  Copyright © 2561 Finnomena. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        window.setMinimalStyle()
        let vc = ViewController()
        window.contentViewController = vc
        window.makeKey()

        let url = URL(string: "https://work.facebook.com")
        let request = URLRequest(url: url!)
        vc.loadRequest(request)
    }

    func applicationWillBecomeActive(_ notification: Notification) {
        let windowCount = NSApplication.shared.windows.count
        if windowCount == 1 && !window.isVisible {
            window.makeKeyAndOrderFront(nil)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // MARK: - User interactions

    @IBAction func handleOpen(_ sender: Any) {
        window.makeKeyAndOrderFront(nil)
    }

    @IBAction func handleWorkplace(_ sender: Any) {
        let url = URL(string: "https://work.facebook.com")
        openWindow(url: url!)
    }

    @IBAction func handleChat(_ sender: Any) {
        let url = URL(string: "https://work.facebook.com/chat")
        openWindow(url: url!)
    }

    @IBAction func handleRefresh(_ sender: NSMenuItem) {
        guard let vc = NSApplication.shared.keyWindow?.contentViewController as? ViewController else { return }
        vc.webView.reload(nil)
    }

    // MARK: - Helpers

    func openWindow(url: URL) {
        let request = URLRequest(url: url)

        let viewController = ViewController()
        let window = NSWindow(contentViewController: viewController)
        window.setMinimalStyle()
        window.contentViewController = viewController
        window.makeKeyAndOrderFront(nil)
        viewController.url = url
        viewController.loadRequest(request)
    }
}

extension NSWindow {
    func setMinimalStyle() {
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
        backgroundColor = NSColor(red: 0.92, green: 0.91, blue: 0.91, alpha: 1)
    }
}
