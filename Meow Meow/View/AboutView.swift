//
//  AboutView.swift
//  Meow Meow
//
//  Created by Hai Ha on 2021/07/02.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Image("my-love").resizable().frame(width: 380, height: 600).cornerRadius(30)
            Text("for my l❤ve - a c😻t lover").font(.title3)
            
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
