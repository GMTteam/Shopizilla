//
//  WebKitVC.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 24/11/2021.
//

import UIKit
import WebKit

class WebKitVC: UIViewController {
    
    //MARK: - Properties
    private var webView: WKWebView!
    private var progressView: UIProgressView!
    
    var link = ""
    
    //MARK: - Lifecycle
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.isToolbarHidden = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            progressView.isHidden = Float(webView.estimatedProgress) == 1.0
        }
    }
}

//MARK: - Setups

extension WebKitVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "PayPal"
        
        progressView = UIProgressView(progressViewStyle: .bar)
        progressView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 5.0)
        progressView.trackTintColor = .lightGray.withAlphaComponent(0.5)
        progressView.progressTintColor = .black
        progressView.sizeToFit()
        view.insertSubview(progressView, aboveSubview: webView)
        
        guard let url = URL(string: link) else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
    }
    
    private func setupNavi() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel".localized(), style: .plain, target: self, action: #selector(cancelDidTap))
    }
    
    @objc private func cancelDidTap() {
        dismissHandler(state: "failed")
    }
    
    private func dismissHandler(state: String) {
        dismiss(animated: true)
        NotificationCenter.default.post(name: .payPalKey, object: state)
    }
}

//MARK: - WKNavigationDelegate

extension WebKitVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .other {
            if let redirectURL = navigationAction.request.url {
                let link = redirectURL.absoluteString
                print("*** link: \(link)")
                print("*** redirectPath: \(redirectURL.path)")
                
                var state = ""
                
                if link.range(of: "failed", options: [], range: nil, locale: .current) != nil {
                    state = "failed"
                }
                
                if link.range(of: "success", options: [], range: nil, locale: .current) != nil {
                    state = "success"
                }
                
                if state != "" {
                    print("*** State: \(state)")
                    dismissHandler(state: state)
                    
                    decisionHandler(.cancel)
                    return
                }
            }
        }
        
        decisionHandler(.allow)
    }
}
