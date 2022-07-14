//
//  LoginView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/12.
//

import SwiftUI

struct LoginView: View {
    @State private var NextView = false
    var body: some View {
        VStack {
            Button(action: { NextView = true }) {
                Text("다음")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.accentColor)
                    .foregroundColor(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }.sheet(isPresented: $NextView) {
                IDView()
            }
        }
        .padding(20)
    }
}

struct IDView: View {
    var body: some View {
        Text("")
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
