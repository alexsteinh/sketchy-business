//
//  ContentView.swift
//  SketchyBusiness
//
//  Created by Alexander Steinhauer on 08.12.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = DrawableImageViewModel(image: UIImage(named: "Tree")!)
    
    var body: some View {
        DrawableImage(viewModel: viewModel)
            .navigationTitle("Annotate ya image")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        let image = viewModel.sketchedImage
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    } label: {
                        Text("Done")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        viewModel.clearDrawing()
                    } label: {
                        Text("Clear Drawing")
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
