//
//  DrawableImage.swift
//  SketchyBusiness
//
//  Created by Alexander Steinhauer on 08.12.22.
//

import SwiftUI

struct DrawableImage: View {
    @ObservedObject var viewModel: DrawableImageViewModel
    
    init(viewModel: DrawableImageViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        // The first view in a ZStack is the first drawed one.
        // Meaning that the image will appear under the canvas view
        ZStack {
            Image(uiImage: viewModel.image)
                .resizable()
                .aspectRatio(viewModel.image.size, contentMode: .fit)
            
            CanvasView(viewModel: viewModel.canvasViewModel)
                .aspectRatio(viewModel.image.size, contentMode: .fit)
        }
    }
}

enum Pencil {
    case redPen
    case greenPen
}

class DrawableImageViewModel: ObservableObject {
    let image: UIImage
    let canvasViewModel = CanvasViewModel()
    
    var sketchedImage: UIImage {
        mergeImages(bottomImage: image, topImage: canvasViewModel.imageGetter())
    }
    
    @Published var pencil: Pencil = .redPen {
        didSet {
            updatePencil()
        }
    }
    
    @Published var pencilWidth: CGFloat = 2 {
        didSet {
            updatePencil()
        }
    }
    
    init(image: UIImage) {
        self.image = image
    }
    
    func clearDrawing() {
        canvasViewModel.clearDrawing()
    }
    
    func undoStroke() {
        canvasViewModel.undoStroke()
    }
    
    func redoStroke() {
        canvasViewModel.redoStroke()
    }
    
    private func updatePencil() {
        canvasViewModel.selectPencil(pencil, pencilWidth)
    }
    
    private func mergeImages(bottomImage: UIImage, topImage: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(bottomImage.size)

        let areaSize = CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height)

        bottomImage.draw(in: areaSize)
        topImage.draw(in: areaSize, blendMode: .normal, alpha: 1.0)

        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return mergedImage ?? .init()
    }
}

struct DrawableImage_Previews: PreviewProvider {
    static var previews: some View {
        DrawableImage(viewModel: .init(image: UIImage(named: "Tree")!))
    }
}
