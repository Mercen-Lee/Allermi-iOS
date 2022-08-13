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
import AVKit

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

struct DevelopersView: View {
    var player = AVPlayer()
    var body: some View {
        ZStack {
            VideoPlayer(player: player)
            VStack {
                Capsule()
                        .fill(.white)
                        .frame(width: 50, height: 4)
                        .padding(10)
                Spacer()
            }
        }
        .ignoresSafeArea()
        .onAppear {
            if player.currentItem == nil {
                let item = AVPlayerItem(url: URL(string: "http://drive.google.com/uc?export=view&id=1_M4aysgitgG7aNj13pK66Vm9CIk9MeDf")!)
                player.replaceCurrentItem(with: item)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                player.play()
            })
        }
    }
}

struct SearchOption: View {
    let icon: String
    let title: String
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
            Spacer()
            Text(title)
        }
        .padding(20)
        .foregroundColor(Color(UIColor.systemBackground))
        .frame(height: 40)
        .frame(width: 130)
        .background(Color.accentColor)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding([.leading, .trailing], 3)
    }
}
struct SearchView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var text: String = ""
    @State var search = false
    @State var barcodeSearch = false
    @State var voiceSearch = false
    @State var developers = false
    var body: some View {
        VStack {
            Image("Logo2")
                .resizable()
                .scaledToFit()
                .frame(width: 270)
                .padding(.bottom, 50)
            SuperTextField(placeholder: Text("식품명을 입력해 검색하세요"), text: $text)
                .frame(height: 60)
                .multilineTextAlignment(.center)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding([.leading, .trailing], 20)
                .padding(.bottom, 15)
                .onSubmit{
                    if text.uppercased() == "DEVELOPERS" {
                        developers.toggle()
                    } else {
                        search.toggle()
                    }
                }
            NavigationLink(destination: SearchedView(text: text), isActive: $search) { EmptyView() }
            HStack {
                Button(action: {
                    barcodeSearch.toggle()
                }) {
                    SearchOption(icon: "location.fill", title: "위치")
                }
                
                Button(action: {
                    barcodeSearch.toggle()
                }) {
                    SearchOption(icon: "barcode", title: "바코드")
                }
            }
        }
        .sheet(isPresented: $barcodeSearch) {
            CodeScannerView(codeTypes: [.ean13, .ean8, .upce], simulatedData: "8801037018332", completion: handleScan)
                .overlay(ScanOverlayView())
                .ignoresSafeArea()
        }
        .sheet(isPresented: $voiceSearch) {
            SpeechView()
        }
        .sheet(isPresented: $developers) {
            DevelopersView()
        }
    }
    func handleScan(result: Result<ScanResult, ScanError>) {
        barcodeSearch = false
        switch result {
            case .success(let result):
                let details = result.string
                AF.request("http://openapi.foodsafetykorea.go.kr/api/90b5037cda5d44e7bc84/C005/json/1/5/BAR_CD=\(details)", method: .get, encoding: URLEncoding.default).responseData { response in
                    text = JSON(response.data!)["C005"]["row"][0]["PRDLST_REPORT_NO"].string ?? ""
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
