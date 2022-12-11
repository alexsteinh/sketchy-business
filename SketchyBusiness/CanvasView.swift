//
//  CanvasView.swift
//  SketchyBusiness
//
//  Created by Alexander Steinhauer on 08.12.22.
//

import PencilKit
import SwiftUI

/// Simple SwiftUI wrapper for PKCanvasView
struct CanvasView: UIViewRepresentable {
    typealias UIViewType = PKCanvasView
    
    @Environment(\.undoManager) private var undoManager
    @ObservedObject var viewModel: CanvasViewModel
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        
        // Make it transparent, so we can see the image underneath
        canvasView.backgroundColor = .clear
        
        // By default, the canvas only detects input from the  Pencil. Make it detect our finger as well
        canvasView.drawingPolicy = .anyInput
        
        // Create a default red pencil
        canvasView.tool = PKInkingTool(.pen, color: .red, width: 2)
        
        // Make drawing accessable to our parent view in SwiftUIy way
        viewModel.imageGetter = { [weak canvasView] in
            guard let canvasView else {
                return .init()
            }
            
            return canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
        }
        
        // Expose clearing functionality to SwiftUI
        viewModel.clearDrawing = { [weak canvasView] in
            canvasView?.drawing.strokes = []
        }
        
        // Set current pencil
        viewModel.selectPencil = { [weak canvasView] pencil, pencilWidth in
            switch pencil {
            case .redPen:
                canvasView?.tool = PKInkingTool(.monoline, color: .red, width: pencilWidth)
            case .greenPen:
                canvasView?.tool = PKInkingTool(.monoline, color: .green, width: pencilWidth)
            }
        }
        
        // Set undo manager for undo/redo of drawn strokes
        viewModel.undoManager = undoManager
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
}

class CanvasViewModel: ObservableObject {
    fileprivate var undoManager: UndoManager?
    
    fileprivate(set) var imageGetter: () -> UIImage = { .init() }
    fileprivate(set) var clearDrawing: () -> Void = { }
    fileprivate(set) var selectPencil: (Pencil, CGFloat) -> Void = { _, _ in }
    
    func undoStroke() {
        undoManager?.undo()
    }
    
    func redoStroke() {
        undoManager?.redo()
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(viewModel: .init())
    }
}
