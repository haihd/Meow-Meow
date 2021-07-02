//
//  RandomCatView.swift
//  Meow Meow
//
//  Created by Hai Ha on 2021/07/02.
//

import SwiftUI
import AVFoundation

var audioPlayer:AVPlayer!

struct RandomCatView: View {
    @ObservedObject var urlImageModel: UrlImageModel
    var defaultImage = UIImage(named: "cat-logo")
    @State private var isShowingFavorite = false
    @State private var isFavorited = true
    
    init(urlString: String?) {
        urlImageModel = UrlImageModel(urlString: urlString)
    }
    
    var body: some View {
        VStack {
            ZStack {
                
                Image(uiImage: urlImageModel.image ?? defaultImage!)
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 380, height: 580)
                    //.border(Color.gray).cornerRadius(30)
                    //.background(Color.gray)
                    .onTapGesture(count: 2) {
                        self.isShowingFavorite.toggle()
                    }
                if(self.isShowingFavorite) {
                    Image(systemName: "heart.fill")
                        .resizable().frame(width: 100, height: 100)
                        .foregroundColor(.red).padding(.bottom).opacity(0.4)
                        .onAppear {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                                withAnimation {
//                                    self.isShowingFavorite.toggle()
//                                }
//                            }
                        }
                }
                
            }
            
            
            Button(action: {
                playCatSound()
                isShowingFavorite = false
                urlImageModel.loadImage()
            }, label: {
                Image("cat-feed").resizable().frame(width: 120, height: 120)
            })
        }
        
    }
}

func playCatSound() {
    guard let url = Bundle.main.url(forResource: "meo", withExtension: "mp3") else {
        print("error to get the mp3 file")
        return
    }

    audioPlayer = AVPlayer(url: url)
    audioPlayer?.play()
}

class UrlImageModel: ObservableObject {
    @Published var image: UIImage?
    var imageCache = ImageCache.getImageCache()
    var urlString: String?
    
    init(urlString: String?) {
        self.urlString = urlString
        loadImage()
    }
    
    func loadImage() {
//        if loadImageFromCache() {
//            return
//        }
        loadImageFromUrl()
    }
    
    func loadImageFromUrl() {
        guard let urlString = urlString else {
            return
        }
        
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
        task.resume()
    }
    
    func loadImageFromCache() -> Bool {
        guard let urlString = urlString else {
            return false
        }
        
        guard let cacheImage = imageCache.get(forKey: urlString) else {
            return false
        }
        
        image = cacheImage
        return true
    }
    
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error: \(error!)")
            return
        }
        guard let data = data else {
            print("No data found")
            return
        }
        
        DispatchQueue.main.async {
            guard let loadedImage = UIImage(data: data) else {
                return
            }
            self.imageCache.set(forKey: self.urlString!, image: loadedImage)
            self.image = loadedImage
        }
    }
}

class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}

struct RandomCatView_Previews: PreviewProvider {
    
    static var previews: some View {
        RandomCatView(urlString: "https://source.unsplash.com/featured/?cat")
    }
}
