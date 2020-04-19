import SwiftUI
import PDFKit

struct ContentView: View {
    @State private var isPdfLoaded = false
    @State private var showingAlert = false
    @State private var document = PDFDocument()
    
    private let model = Model()
    private let webView = MyWebView(url: URL(string: "https://file-examples.com/wp-content/uploads/2017/08/file_example_PPT_500kB.ppt")!)
    
    var body: some View {
        ZStack {
            self.webView
            
            Button(action: {
                if (self.webView.originalWKWebView.isLoading) {
                    self.showingAlert = true
                    return
                }
                
                self.model.convertWKWebView2Pdf(webView: self.webView.originalWKWebView) {document in
                    self.document = document!
                    self.isPdfLoaded = true
                }
            }) {
                Text("Convert To Pdf")
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("WebView is still loading!"))
            }
            .sheet(isPresented: $isPdfLoaded) {
                MyPDFView(document: self.document)
            }
        }
    }
}
