//
//  AboutUsVC.swift
//  Shopizilla
//
//  Created by Anh Tu on 21/04/2022.
//

import UIKit
import WebKit

class AboutUsVC: UIViewController {
    
    //MARK: - Properties
    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        DispatchQueue.main.async {
            guard let url = Bundle.main.url(forResource: "AboutUs.html", withExtension: nil),
                let data = try? Data(contentsOf: url) else { return }
            
            let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
            self.webView.load(data, mimeType: "text/html", characterEncodingName: "URF-8", baseURL: baseURL)
        }
    }
}

//MARK: - Configures

extension AboutUsVC {
    
    func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Shopizilla"
        
        //TODO: - WebView
        webView.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20.0),
        ])
    }
}
