//
//  TheNewVC.swift
//  Management Covid
//
//  Created by Mai Tài on 4/14/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit
import WebKit

class TheNewVC: BaseVC {

//    @IBOutlet weak var bNavigation: BaseNavigationBar!
    var webNew :WKWebView!
    var myTimer = Timer()
    var theBool = Bool()
    let pcBar = UIProgressView(progressViewStyle: .default)
    private var estimatedProgressObserver: NSKeyValueObservation?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func initUI() {
//        bNavigation.vContainer.backgroundColor = UIColor.red
//        bNavigation.setNavigate("", "Tin tức cập nhật", "")
        initNaviBar()
    }
    override func initData() {
//        bNavigation.dele = self
        loadWebNew(url: URLs.urlWebNew)
        setupProgressView()
        setupEstimatedProgressObserver()
    }
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webNew = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webNew
    }
    override func viewWillDisappear(_ animated: Bool) {
        pcBar.isHidden = true
    }
    func loadWebNew(url: String){
        let url = URL(string: url)
        let requestObj = URLRequest(url: url!)
        webNew.navigationDelegate = self
        webNew.load(requestObj)
    }
    
    private func initNaviBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.red
        titleNavibar(text: "Tin tức cập nhật")
        
        //init left button
        
    }
    func titleNavibar(text: String) {
        navigationItem.title = text
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor : UIColor.white,
            .font : DefaultSetting.boldSystemFont18
        ]
        navigationController?.navigationBar.titleTextAttributes =  strokeTextAttributes
    }
    
    private func setupEstimatedProgressObserver() {
        estimatedProgressObserver = webNew.observe(\.estimatedProgress, options: [.new]) { [weak self] webHelp, _ in
            self?.pcBar.progress = Float(webHelp.estimatedProgress)
        }
    }
    /*
     Name:setupProgressView
     Author: Truong Quoc Tai
     Description: Add a UIProgressView into navigationBar
     */
    private func setupProgressView() {
        pcBar.translatesAutoresizingMaskIntoConstraints = false
        navigationController?.navigationBar.addSubview(pcBar)
        pcBar.isHidden = true
        let leadingAnchor = pcBar.leadingAnchor.constraint(equalTo: (navigationController?.navigationBar.leadingAnchor)!)
        let trailingAnchor = pcBar.trailingAnchor.constraint(equalTo: (navigationController?.navigationBar.trailingAnchor)!)
        let bottomAnchor = pcBar.bottomAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!)
        let height = pcBar.heightAnchor.constraint(equalToConstant: 2.0)
        NSLayoutConstraint.activate([leadingAnchor,trailingAnchor, bottomAnchor, height])
    }
    
    @objc func timerCallback(){
        if theBool {
            if pcBar.progress >= 1 {
                pcBar.isHidden = true
                myTimer.invalidate()
            }else{
                pcBar.progress = Float(webNew.estimatedProgress)
            }
        }else{
            pcBar.progress = Float(webNew.estimatedProgress)
            if(webNew.estimatedProgress >= 1){
                theBool = true
            }
        }
    }
    
}
extension TheNewVC: WKNavigationDelegate{
    func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        if pcBar.isHidden {
            pcBar.isHidden = false
        }
        theBool = false
        pcBar.progress = 0
        myTimer =  Timer.scheduledTimer(timeInterval: 0.5,target: self,selector: #selector(timerCallback),userInfo: nil,repeats: true)
    }
    
    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        theBool = true
    }
}
