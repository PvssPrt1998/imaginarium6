import UIKit
import SwiftUI
import WebKit
import Combine

struct GalleryView: UIViewRepresentable {
    
    enum URLType {
        case local, `public`
    }
    
    var dataM: ViewModelFactory?
    var type: URLType
    var url: String?
    
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let urlValue = url  {
            if let requestUrl = URL(string: urlValue) {
                webView.load(URLRequest(url: requestUrl))
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: GalleryView
        var webViewNavigationSubscriber: AnyCancellable? = nil
        
        init(_ webView: GalleryView) {
            self.parent = webView
        }
        
        deinit {
            webViewNavigationSubscriber?.cancel()
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
            if let urlStr = navigationAction.request.url?.absoluteString {
                if let dataM = parent.dataM {
                    if verifyUrl(urlString: urlStr) {
                        //dataM.str1 = urlStr
                        
                    }
                    
                }
            }
            decisionHandler(.allow, preferences)
        }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
           
            if let url = webView.url?.absoluteString{
                if let dataM = parent.dataM {
                    if verifyUrl(urlString: url) {
                        dataM.str1 = url
                        print(dataM.str1)
                    }
                    
                }
            }
        }
        
        func verifyUrl (urlString: String?) -> Bool {
            if let urlString = urlString {
                if let url = NSURL(string: urlString) {
                    return UIApplication.shared.canOpenURL(url as URL)
                }
            }
            return false
        }
    }
}
