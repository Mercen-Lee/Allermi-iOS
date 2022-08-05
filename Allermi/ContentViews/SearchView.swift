//
//  SearchView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/11.
//

import SwiftUI
import CodeScanner
import SwiftSpeech
import Alamofire
import SwiftyJSON

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
    @State var search = false
    @State var barcodeSearch = false
    @State var voiceSearch = false
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
                .onSubmit{ search.toggle() }
            NavigationLink(destination: SearchedView(text: text), isActive: $search) { EmptyView() }
            HStack {
                ForEach(1..<5, id: \.self) { number in
                    if number != 1 { Spacer() }
                    VStack {
                        Button(action: {
                            switch number {
                                case 1: print("a")
                                case 2: LocationSearchView()
                            case 3: barcodeSearch.toggle()
                            default: voiceSearch.toggle()
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
        .sheet(isPresented: $barcodeSearch) {
            CodeScannerView(codeTypes: [.ean13, .ean8, .upce], simulatedData: "8801037018332", completion: handleScan)
                .overlay(ScanOverlayView())
                .ignoresSafeArea()
        }
        .sheet(isPresented: $voiceSearch) {
            SpeechView()
        }
    }
    func handleScan(result: Result<ScanResult, ScanError>) {
        barcodeSearch = false
        switch result {
            case .success(let result):
                let details = result.string
                AF.request("http://openapi.foodsafetykorea.go.kr/api/90b5037cda5d44e7bc84/C005/json/1/5/BAR_CD=\(details)", method: .get, encoding: URLEncoding.default).responseData { response in
                    text = JSON(response.data!)["C005"]["row"][0]["PRDLST_NM"].string ?? ""
                    if(!text.isEmpty) { search.toggle() }
                }
            case .failure(let error):
                print("Scanning failed: \(error.localizedDescription)")
            }
    }
}

struct ScanOverlayView: View {
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let cutoutWidth: CGFloat = min(geometry.size.width, geometry.size.height) / 1.5

                ZStack {
                    Rectangle()
                        .fill(Color.black.opacity(0.5))
                        
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black)
                        .frame(width: cutoutWidth, height: cutoutWidth, alignment: .center)
                        .blendMode(.destinationOut)
                }.compositingGroup()
                
                Path { path in
                    
                    let left = (geometry.size.width - cutoutWidth) / 2.0
                    let right = left + cutoutWidth
                    let top = (geometry.size.height - cutoutWidth) / 2.0
                    let bottom = top + cutoutWidth
                    
                    path.addPath(
                        createCornersPath(
                            left: left, top: top,
                            right: right, bottom: bottom,
                            cornerRadius: 40, cornerLength: 20
                        )
                    )
                }
                .stroke(Color.accentColor, lineWidth: 8)
                .frame(width: cutoutWidth, height: cutoutWidth, alignment: .center)
                .aspectRatio(1, contentMode: .fit)
            }
            VStack {
                Capsule()
                        .fill(.white)
                        .frame(width: 50, height: 4)
                        .padding(10)
                Spacer()
                Text("바코드를 인식해 검색합니다")
                    .foregroundColor(Color.white)
                    .padding(.bottom, 350)
                Spacer()
            }
        }
    }
    
    private func createCornersPath(
        left: CGFloat,
        top: CGFloat,
        right: CGFloat,
        bottom: CGFloat,
        cornerRadius: CGFloat,
        cornerLength: CGFloat
    ) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: left, y: (top + cornerRadius / 2.0)))
        path.addArc(
            center: CGPoint(x: (left + cornerRadius / 2.0), y: (top + cornerRadius / 2.0)),
            radius: cornerRadius / 2.0,
            startAngle: Angle(degrees: 180.0),
            endAngle: Angle(degrees: 270.0),
            clockwise: false
        )

        path.move(to: CGPoint(x: left + (cornerRadius / 2.0), y: top))
        path.addLine(to: CGPoint(x: left + (cornerRadius / 2.0) + cornerLength, y: top))

        path.move(to: CGPoint(x: left, y: top + (cornerRadius / 2.0)))
        path.addLine(to: CGPoint(x: left, y: top + (cornerRadius / 2.0) + cornerLength))

        path.move(to: CGPoint(x: right - cornerRadius / 2.0, y: top))
        path.addArc(
            center: CGPoint(x: (right - cornerRadius / 2.0), y: (top + cornerRadius / 2.0)),
            radius: cornerRadius / 2.0,
            startAngle: Angle(degrees: 270.0),
            endAngle: Angle(degrees: 360.0),
            clockwise: false
        )

        path.move(to: CGPoint(x: right - (cornerRadius / 2.0), y: top))
        path.addLine(to: CGPoint(x: right - (cornerRadius / 2.0) - cornerLength, y: top))

        path.move(to: CGPoint(x: right, y: top + (cornerRadius / 2.0)))
        path.addLine(to: CGPoint(x: right, y: top + (cornerRadius / 2.0) + cornerLength))

        path.move(to: CGPoint(x: left + cornerRadius / 2.0, y: bottom))
        path.addArc(
            center: CGPoint(x: (left + cornerRadius / 2.0), y: (bottom - cornerRadius / 2.0)),
            radius: cornerRadius / 2.0,
            startAngle: Angle(degrees: 90.0),
            endAngle: Angle(degrees: 180.0),
            clockwise: false
        )
        
        path.move(to: CGPoint(x: left + (cornerRadius / 2.0), y: bottom))
        path.addLine(to: CGPoint(x: left + (cornerRadius / 2.0) + cornerLength, y: bottom))

        path.move(to: CGPoint(x: left, y: bottom - (cornerRadius / 2.0)))
        path.addLine(to: CGPoint(x: left, y: bottom - (cornerRadius / 2.0) - cornerLength))

        path.move(to: CGPoint(x: right, y: bottom - cornerRadius / 2.0))
        path.addArc(
            center: CGPoint(x: (right - cornerRadius / 2.0), y: (bottom - cornerRadius / 2.0)),
            radius: cornerRadius / 2.0,
            startAngle: Angle(degrees: 0.0),
            endAngle: Angle(degrees: 90.0),
            clockwise: false
        )
        
        path.move(to: CGPoint(x: right - (cornerRadius / 2.0), y: bottom))
        path.addLine(to: CGPoint(x: right - (cornerRadius / 2.0) - cornerLength, y: bottom))

        path.move(to: CGPoint(x: right, y: bottom - (cornerRadius / 2.0)))
        path.addLine(to: CGPoint(x: right, y: bottom - (cornerRadius / 2.0) - cornerLength))

        return path
    }
}

struct SpeechView: View {
    var body: some View {
        Group {
            SwiftSpeech.Demos.Basic(localeIdentifier: "ko_KR")
            SwiftSpeech.Demos.Colors()
            SwiftSpeech.Demos.List(localeIdentifier: "ko_KR")
        }
        .onAppear {
            SwiftSpeech.requestSpeechRecognitionAuthorization()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
        //.preferredColorScheme(.dark)
    }
}
