//
//  ContentView.swift
//  Meow Meow
//
//  Created by Hai Ha on 2021/07/02.
//

import SwiftUI

struct ContentView: View {
    @State var isActive: Bool = false

    var body: some View {
        
        VStack {
            if(isActive) {
                TabView {
                    RandomCatView(urlString: "https://source.unsplash.com/featured/?cat")
                        .tabItem {
                            Label("Photo", systemImage: "photo.on.rectangle.angled")
                        }
                    FavoriteCatView()
                        .tabItem {
                            Label("Favorite", systemImage: "suit.heart.fill")
                        }
                    AboutView()
                        .tabItem {
                            Label("About", systemImage: "info.circle")
                        }
                }
            } else {
                Image("cat-logo").resizable().frame(width: 380, height: 400)
            }
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
