import SwiftUI
import WebKit


func getWebConfiguration() -> WKWebViewConfiguration {
    let webConfiguration = WKWebViewConfiguration()
    
    // remove margin
    let bodyStyle = "body { margin: 0px } div.slide { margin: 0px }"
    let source = "var node = document.createElement(\"style\"); node.innerHTML = \"\(bodyStyle)\";document.body.appendChild(node);"
    let script = WKUserScript(
        source: source,
        injectionTime: .atDocumentEnd,
        forMainFrameOnly: false
    )
    
    webConfiguration.userContentController.addUserScript(script)
    return webConfiguration
}


struct MyWebView: UIViewRepresentable {
    var url: URL
    let originalWKWebView = WKWebView(frame: .zero, configuration: getWebConfiguration())

    func makeUIView(context: Context) -> WKWebView {
        return originalWKWebView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}
