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
    @Environment(\.colorScheme) var colorScheme
    @State var text: String = ""
    let icons = ["link", "location.fill", "barcode", "mic.fill"]
    let titles = ["링크로 검색", "위치로 검색", "바코드 검색", "음성 검색"]
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .padding(EdgeInsets(top: 0, leading: 70, bottom: 45, trailing: 70))
            SuperTextField(placeholder: Text("식품명 또는 식당 상호명을 입력하세요"), text: $text)
                .frame(height: 60)
                .multilineTextAlignment(.center)
                .background(RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(Color.gray, lineWidth: 1)
                    .background(colorScheme == .dark ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1)))
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
            HStack {
                ForEach(1..<5, id: \.self) { number in
                    if number != 1 { Spacer() }
                    VStack {
                        Button(action: {
                            switch number {
                                case 1: print("a")
                                case 2: LocationSearchView()
                                case 3: BarcodeSearchView()
                                default: print("a")
                            }
                        }) {
                            Image(systemName: icons[number-1])
                                .font(.system(size: 27))
                                .foregroundColor(Color(UIColor.systemBackground))
                        }
                            .frame(width: 55, height: 55)
                            .background(ColorManager.LightColor)
                            .clipShape(Circle())
                        Text(titles[number-1])
                            .font(.system(size: 14, weight: .bold, design: .default))
                            .foregroundColor(.gray)
                    }.frame(width: 80)
                }
            }.padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
        //.preferredColorScheme(.dark)
    }
}
