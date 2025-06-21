//
//  QRCodeScannerView.swift
//  iotChallenge
//
//  Created by Teryl S on 6/20/25.
//

import SwiftUI

struct QRCodeScannerView: UIViewControllerRepresentable {
    var onFound: (String) -> Void

    func makeUIViewController(context: Context) -> ScannerViewController {
        let vc = ScannerViewController()
        vc.onFound = onFound
        return vc
    }

    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {}
}

struct QRScannerSheet: View {
    @Environment(\.dismiss) var dismiss
    var onScan: (String) -> Void

    var body: some View {
        NavigationStack {
            QRCodeScannerView { scanned in
                onScan(scanned)
                dismiss()
            }
            .edgesIgnoringSafeArea(.all)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
