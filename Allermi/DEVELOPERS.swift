//
//  DEVELOPERS.swift
//  Allermi
//
//  Created by Mercen on 2022/07/18.
//

import SwiftUI
import WebKit

struct DEVELOPERS: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView { WKWebView() }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
        let path = "https://www.youtube.com/watch?v=KMU0tzLwhbE"
        guard let url = URL(string: path) else { return }
        
        uiView.scrollView.isScrollEnabled = false
        uiView.load(.init(url: url))
    }
}


struct DEVELOPERS_Previews: PreviewProvider {
    static var previews: some View {
        DEVELOPERS()
    }
}
