//
//  SearchView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/11.
//

import SwiftUI

struct SuperTextField: View {
    var placeholder: Text
    @FocusState private var isFocused: Bool
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty && !isFocused {
                placeholder
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                .focused($isFocused)
        }
    }
}

struct SearchView: View {
    @State var text: String = ""
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .padding(EdgeInsets(top: 0, leading: 80, bottom: 25, trailing: 80))
                SuperTextField(placeholder: Text("식품명 또는 식당 상호명을 입력하세요"), text: $text)
                .frame(height: 60)
                .multilineTextAlignment(.center)
                .background(RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(Color.gray, lineWidth: 1)
                    .background(Color(.systemGray6)))
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(20)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
        //.preferredColorScheme(.dark)
    }
}
