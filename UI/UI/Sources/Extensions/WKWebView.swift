//
//  WKWebView.swift
//  UI
//
//  Created by Jmy on 2021/11/08.
//

import WebKit

extension WKWebView {
    func load(_ url: URL) {
        load(url.request)
    }
    
    // MARK: - Cookies
    
    func cleanAllCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    func refreshCookies() {
        configuration.processPool = WKProcessPool()
    }
}