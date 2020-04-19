import WebKit
import PDFKit

class Model {
    func convertWKWebView2Pdf(webView: WKWebView, callback: @escaping (PDFDocument?) -> Void) {
        // get size of powerpoint
        // see: https://www.jianshu.com/p/7d4c69d495ff
        let getWidthHeightScript = "function x(){var width=window.getComputedStyle(document.getElementsByClassName('slide')[0]).width;var height=window.getComputedStyle(document.getElementsByClassName('slide')[0]).height;return ''+width+' '+height;};x()"
        
        webView.evaluateJavaScript(getWidthHeightScript) { value, error in
            let widthAndHeight = (value as! String).components(separatedBy: " ")
            
            let width: CGFloat = NumberFormatter().number(from: widthAndHeight[0].replacingOccurrences(of: "px", with: "")) as! CGFloat
            let height: CGFloat = NumberFormatter().number(from: widthAndHeight[1].replacingOccurrences(of: "px", with: "")) as! CGFloat
            
            callback(webView.exportAsPDF(width: width, height: height))
        }
    }
}

extension WKWebView {
    func exportAsPDF(width: CGFloat, height: CGFloat) -> PDFDocument {
        // ????
        let pdfWidth = width *  0.800
        let pdfHeight = height * pdfWidth / width
        
        let paperRect = CGRect(origin: .zero, size: CGSize(width: pdfWidth, height: pdfHeight))
        let printableRect = CGRect(origin: .zero, size: CGSize(width: pdfWidth, height: pdfHeight))
        
        let printRenderer = UIPrintPageRenderer()
        printRenderer.addPrintFormatter(self.viewPrintFormatter(), startingAtPageAt: 0)
        printRenderer.setValue(NSValue(cgRect: paperRect), forKey: "paperRect")
        printRenderer.setValue(NSValue(cgRect: printableRect), forKey: "printableRect")

        let pdfData = printRenderer.generatePDFData()
        return PDFDocument(data: pdfData)!
    }
}


extension UIPrintPageRenderer {
    func generatePDFData() -> Data {
        let pdfData = NSMutableData()
                
        UIGraphicsBeginPDFContextToData(pdfData, self.paperRect, nil)
        
        // 1ページごとに空白ページが挟まるため、(n+1)/2が真のページ数
        let realNumberOfPages = (self.numberOfPages + 1) / 2
        self.prepare(forDrawingPages: NSMakeRange(0, realNumberOfPages))
        
        let printRect = UIGraphicsGetPDFContextBounds()

        for pdfPage in 0..<self.numberOfPages {
            // 空白ページは飛ばす
            if pdfPage % 2 == 1 {
                continue
            }
            UIGraphicsBeginPDFPage()
            self.drawPage(at: pdfPage, in: printRect)
        }
        
        UIGraphicsEndPDFContext()
        return pdfData as Data
    }
}
