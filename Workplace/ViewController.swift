//
//  ViewController.swift
//  Workplace
//
//  Created by Pitchmak Sareerat on 5/30/2561 .
//  Copyright © 2561 Finnomena. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController {

    let webView = WebView()
    let activityIndicator = NSProgressIndicator()
    var url: URL?

    deinit {
        webView.uiDelegate = nil
        webView.policyDelegate = nil
        webView.frameLoadDelegate = nil
    }

    override func loadView() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: 1200, height: 740))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)

        webView.uiDelegate = self
        webView.policyDelegate = self
        webView.frameLoadDelegate = self
        webView.frame = NSRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height - 20)
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1 Safari/605.1.15"
        webView.autoresizingMask = [.width, .height]

        activityIndicator.isIndeterminate = true
        activityIndicator.style = .spinning
        activityIndicator.isDisplayedWhenStopped = false
        activityIndicator.controlTint = .graphiteControlTint
        webView.addSubview(activityIndicator)
        activityIndicator.startAnimation(nil)

        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
            self.activityIndicator.stopAnimation(nil)
        }
    }

    override func viewWillLayout() {
        super.viewWillLayout()
        activityIndicator.frame = NSRect(x: view.bounds.size.width / 2 - 30, y: view.bounds.size.height / 2 - 30, width: 60, height: 60)
    }

    func loadRequest(_ request: URLRequest) {
        webView.mainFrame.load(request)
        url = request.url!
    }
}

extension ViewController: WebUIDelegate, WebPolicyDelegate, WebFrameLoadDelegate {
    func webView(_ webView: WebView!, decidePolicyForMIMEType type: String!, request: URLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!) {
        if type != "text/html" {
            listener.ignore()
            NSWorkspace.shared.open(request.url!)
        }
    }

    func webView(_ webView: WebView!, decidePolicyForNewWindowAction actionInformation: [AnyHashable : Any]!, request: URLRequest!, newFrameName frameName: String!, decisionListener listener: WebPolicyDecisionListener!) {
        let viewController = ViewController()
        let window = NSWindow(contentViewController: viewController)
        window.setMinimalStyle()
        window.contentViewController = viewController
        window.makeKeyAndOrderFront(nil)
        viewController.loadRequest(request)

        listener.ignore()
    }

    func webView(_ sender: WebView!, didFinishLoadFor frame: WebFrame!) {
        self.activityIndicator.stopAnimation(nil)
        self.view.window?.title = self.webView.mainFrameTitle
    }
}
