//
//  WebViewController.swift
//  ARTSPerience
//
//  Created by Hafiz on 07/01/2018.
//  Copyright © 2018 Derp. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    var webURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomBackButton()
        
        print(webURL, "200")
        webView.delegate = self
        
        if let url = webURL.url {
            webView.loadRequest(URLRequest(url: url))
        }
        else {
            print("url not ok")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showNavbar()
        self.title = "Loading.."
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // need to clear before checkout, else will crash
        if webView.isLoading{
            webView.stopLoading()
        }
        webView.delegate = nil
    }
    
}

extension WebViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        if !webView.isLoading {
            webView.isHidden = false
            self.title = webURL
            blurView.removeFromSuperview()
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error)
    }
}
