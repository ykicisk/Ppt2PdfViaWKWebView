import SwiftUI
import PDFKit

struct MyPDFView: UIViewRepresentable {
    var document: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        return PDFView()
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = document
    }
}
