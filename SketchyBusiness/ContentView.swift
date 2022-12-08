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
        VStack {
            DrawableImage(viewModel: viewModel)
                .frame(maxHeight: .infinity)
            
            ToolbarView(viewModel: viewModel)
        }
        .navigationTitle("Annotate your image")
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
        }
    }
}

struct ToolbarView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: DrawableImageViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            Spacer()
            
            Button {
                viewModel.pencil = .redPen
            } label: {
                Circle()
                    .fill(.red)
                    .frame(width: 30, height: 30)
            }
            
            Button {
                viewModel.pencil = .greenPen
            } label: {
                Circle()
                    .fill(.green)
                    .frame(width: 30, height: 30)
            }
            
            Button {
                viewModel.clearDrawing()
            } label: {
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
            
            Button {
                viewModel.undoStroke()
            } label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
            
            Button {
                viewModel.redoStroke()
            } label: {
                Image(systemName: "arrow.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
            
            Spacer()
        }
        .frame(maxHeight: 90)
        .background {
            RoundedRectangle(cornerRadius: 10).fill(Color(uiColor: .init(white: colorScheme == .light ? 0.9 : 0.1, alpha: 1)))
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
