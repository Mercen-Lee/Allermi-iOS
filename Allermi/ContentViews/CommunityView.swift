//
//  CommunityView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/11.
//

import SwiftUI

struct CommunityDatas: Decodable {
    let id: Int
    let author: String
    let body: String
    let image: String
    let likes: Int
    let liked: Bool
    let date: String
}

let dummyData: [CommunityDatas] = [
    CommunityDatas(id: 1, author: "Majora", body: "누텔라에 헤이즐넛 들어있대요.. 먹었으면 큰일날 뻔 했네요!", image: "http://res.heraldm.com/phpwas/restmb_idxmake.php?idx=507&simg=/content/image/2018/03/26/20180326000863_0.jpg", likes: 20, liked: true, date: "2022년 8월 7일"),
    CommunityDatas(id: 2, author: "Saria", body: "향긋한 바질 페스토에는 사실 잣이 들어가 있다는 사실, 아셨나요?", image: "https://recipe1.ezmember.co.kr/cache/recipe/2015/06/09/26d4ce4ad73291e4040ec53434582c24.jpg", likes: 5, liked: false, date: "2022년 8월 7일")
]

struct CommunityView: View {
    
    @State private var imagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<dummyData.count, id: \.self) { idx in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(dummyData[idx].author)
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(dummyData[idx].likes)")
                            Button(action: {
                                
                            }) {
                            Image(systemName: dummyData[idx].liked ? "heart.fill" : "heart")
                                .foregroundColor(dummyData[idx].liked ? .accentColor : Color(.label))
                                .font(.title2)
                            }
                        }
                        .padding([.leading, .trailing], 20)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color("InvertedGrayColor").opacity(colorScheme == .dark ? 0.05 : 0.1))
                        Text(dummyData[idx].body)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding([.leading, .trailing], 20)
                            .padding(.top, 5)
                        VStack(alignment: .trailing) {
                            AsyncImage(url: URL(string: dummyData[idx].image)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 200)
                                    .frame(maxWidth: .infinity)
                                    .clipShape(RoundedRectangle(cornerRadius: 7))
                                    .clipped()
                            } placeholder: {
                                ProgressView()
                                    .frame(height: 200)
                                    .frame(maxWidth: .infinity)
                            }
                            Text(dummyData[idx].date)
                                .font(.caption2)
                                .opacity(0.5)
                        }
                        .padding([.leading, .trailing, .bottom], 20)
                    }
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: .infinity)
                    .background(Color("GrayColor").opacity(colorScheme == .dark ? 0.7 : 0.9))
                    .listRowInsets(EdgeInsets())
                    .padding(.bottom, dummyData.count == idx + 1 ? 100 : 20)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .listStyle(PlainListStyle())
            .navigationTitle("소통")
            .navigationBarItems(trailing: Button(action: {
                imagePickerPresented.toggle()
            }) {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(.accentColor)
            })
            .sheet(isPresented: $imagePickerPresented,
                   content: { ImagePicker(image: $selectedImage) })
            .refreshable { }
        }
    }
}

struct CommunityWriteView: View {
    var body: some View {
        Text("a")
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var mode
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            self.parent.image = image
            self.parent.mode.wrappedValue.dismiss()
        }
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityWriteView()//.preferredColorScheme(.dark)
    }
}
