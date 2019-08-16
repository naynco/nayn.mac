//
//  NaynViewController.swift
//

import Cocoa
import WebKit

class NaynViewController: NSViewController {
    
    @IBOutlet weak var webView: WebView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let urlPath: String = "https://nayn.co"
        let wurl: NSURL = NSURL(string: urlPath)!

        let request = NSURLRequest(url: wurl as URL);

        self.webView.frameLoadDelegate = self
        self.webView.drawsBackground = false;
        self.webView.mainFrame.load(request as URLRequest);

    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    func windowShown() {
        self.webView.windowScriptObject.evaluateWebScript("nayn.onShow();");
    }

}

extension NaynViewController: WebFrameLoadDelegate {

    func webView(_ webView: WebView!, didClearWindowObject windowObject: WebScriptObject!, for frame: WebFrame!) {
        webView.windowScriptObject.setValue(self, forKey: "NaynApp")
    }
    

}
