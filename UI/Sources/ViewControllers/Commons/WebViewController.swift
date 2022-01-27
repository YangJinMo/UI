//
//  WebViewController.swift
//  UI
//
//  Created by Jmy on 2021/11/06.
//

import UIKit
import WebKit

final class WebViewController: BaseNavigationViewController {
    // MARK: - Constants

    private let scriptMessageHandler = "scriptHandler"

    // MARK: - Variables

    private var urlString: String?
    private var titleText = ""

    // MARK: - Initialization

    init(urlString: String, titleText: String = "") {
        self.urlString = urlString
        self.titleText = titleText

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Views

    private var webView: BaseWebView!
    private lazy var activityIndicatorView = BaseActivityIndicatorView()
    private lazy var progressView = BaseProgressView()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setWebView()
        setupViews()
        setTitleLabel(titleText)
        removeCache()
        loadWebView()
    }

    // MARK: - Methods

    private func removeCache() {
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date, completionHandler: { })
    }

    private func setWebView() {
        let contentController = WKUserContentController()
        contentController.add(self, name: scriptMessageHandler)

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController

        webView = BaseWebView(configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    private func setupViews() {
        view.addSubviews(
            webView,
            activityIndicatorView,
            progressView
        )

        Constraint.activate([
            webView.topAnchor.constraint(equalTo: contentView.topAnchor),
            webView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            webView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            webView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            activityIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            progressView.leftAnchor.constraint(equalTo: titleView.leftAnchor),
            progressView.rightAnchor.constraint(equalTo: titleView.rightAnchor),
            progressView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
        ])
    }

    private func loadWebView() {
        guard
            let urlString = urlString,
            let encodedString = urlString.encode,
            let url = encodedString.url,
            url.canOpenURL
        else {
//            alert(
//                title: "실행 오류",
//                message: "주소가 유효하지 않기 때문에\n해당 페이지를 열 수 없습니다."
//            ) { _ in
//                self.popViewController()
//            }
            toast("실행 오류\n\n주소가 유효하지 않기 때문에\n해당 페이지를 열 수 없습니다.")
            popViewController()
            return
        }
        webView.load(url)
    }

    var passMessage: ((String) -> Void)?

    private func passMessage(_ message: String) {
        if let pm: ((String) -> Void) = passMessage {
            pm(message)
            popViewController()
        }
    }
}

// MARK: - WKUIDelegate

extension WebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        alert(message: message) { _ in
            completionHandler()
        }
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        alertOption(
            message: message,
            confirmHandler: { _ in
                completionHandler(true)
            },
            cancelHandler: { _ in
                completionHandler(false)
            }
        )
    }
}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicatorView.startAnimating()
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { return }
        url.absoluteString.log()

        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView.stopAnimating()
        progressView.isHidden = true

        // Disable WKActionSheet on WKWebView
        webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none';")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        error.localizedDescription.log()
    }
}

// MARK: - WKScriptMessageHandler

extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == scriptMessageHandler {
            passMessage(message.body as! String)
        }
    }
}