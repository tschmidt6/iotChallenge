//
//  PDFViewerView.swift
//  iotChallenge
//
//  Created by Teryl S on 6/20/25.
//

import SwiftUI
import PDFKit

struct PDFViewerView: View {
    let pdfName: String

    var body: some View {
        PDFKitView(pdfName: pdfName)
            .navigationTitle("Manual")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct PDFKitView: UIViewRepresentable {
    let pdfName: String

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true

        if let url = Bundle.main.url(forResource: pdfName, withExtension: "pdf") {
            if let document = PDFDocument(url: url) {
                pdfView.document = document
            }
        }

        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
