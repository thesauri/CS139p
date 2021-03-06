//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/27/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument

    @State private var chosenPalette: String = ""
    @State private var explainBackgroundPaste: Bool = false
    @State private var confirmBackgroundPaste: Bool = false

    init(document: EmojiArtDocument) {
        self.document = document
        _chosenPalette = State(wrappedValue: self.document.defaultPalette)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack {
                    PaletteChooser(document: document, chosenPalette: $chosenPalette)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(chosenPalette.map { String($0) }, id: \.self) { emoji in
                                Text(emoji)
                                    .font(Font.system(size: self.defaultEmojiSize))
                                    .onDrag { NSItemProvider(object: emoji as NSString) }
                            }
                        }
                    }
                    .padding(.horizontal)
                    if !self.selectedEmojis.isEmpty {
                        RemoveSelectedButton() {
                            for selectedEmoji in self.selectedEmojis {
                                self.document.removeEmoji(selectedEmoji)
                            }
                            withAnimation() {
                                self.selectedEmojis.removeAll()
                            }
                        }
                    }
                }
                GeometryReader { geometry in
                    self.ArtBoard(geometry: geometry)
                }
            }
        }
    }

    func ArtBoard(geometry: GeometryProxy) -> some View {
        ZStack {
            Color.white.overlay(
                OptionalImage(uiImage: document.backgroundImage)
                    .scaleEffect(zoomScale)
                    .offset(panOffset)
            )
                .gesture(doubleTapToZoom(in: geometry.size))
            if self.isLoading {
                Image(systemName: "timer")
                    .imageScale(.large)
                    .spinning()
            } else {
                ForEach(document.emojis) { emoji in
                    Text(emoji.text)
                        .font(animatableWithSize: self.fontSize(for: emoji))
                        .position(self.position(for: emoji, in: geometry.size))
                        .brightness(self.selectedEmojis.contains(emoji) ? self.selectedBrightness : 0)
                        .gesture(self.panSelectedEmojis(emoji))
                        .gesture(self.tapToSelectEmoji(emoji))
                        .transition(.opacity)
                }
            }
        }
        .clipped()
        .contentShape(Rectangle().size(geometry.size))
        .gesture(tapToDeselectAllEmojis())
        .gesture(panGesture())
        .gesture(zoomGesture())
        .edgesIgnoringSafeArea([.horizontal, .bottom])
        .onReceive(self.document.$backgroundImage) { image in
            self.zoomToFit(image, in: geometry.size)
        }
        .onDrop(of: ["public.image","public.text"], isTargeted: nil) { providers, location in
            // SwiftUI bug (as of 13.4)? the location is supposed to be in our coordinate system
            // however, the y coordinate appears to be in the global coordinate system
            var location = CGPoint(x: location.x, y: geometry.convert(location, from: .global).y)
            location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
            location = CGPoint(x: location.x - self.panOffset.width, y: location.y - self.panOffset.height)
            location = CGPoint(x: location.x / self.zoomScale, y: location.y / self.zoomScale)
            return self.drop(providers: providers, at: location)
        }
        .navigationBarItems(trailing: Button(action: {
            if let url = UIPasteboard.general.url, url != self.document.backgroundURL {
                self.confirmBackgroundPaste = true
            } else {
                self.explainBackgroundPaste = true
            }
        }, label: {
            Image(systemName: "doc.on.clipboard").imageScale(.large)
                .alert(isPresented: self.$explainBackgroundPaste) {
                   Alert(
                        title: Text("Paste background"),
                        message: Text("Copy of the URL of an image to the clipboard and touch this button to make it the background of your document."),
                        dismissButton: .default(Text("OK"))
                   )
                }
        }))
        .zIndex(-1)
        .alert(isPresented: self.$confirmBackgroundPaste) {
            Alert(
                title: Text("Paste Background"),
                message: Text("Replace your background with \(UIPasteboard.general.url?.absoluteString ?? "nothing")?."),
                primaryButton: .default(Text("OK")) {
                    self.document.backgroundURL = UIPasteboard.general.url
                },
                secondaryButton: .cancel()
            )
        }
    }

    @GestureState private var gestureZoomScale: CGFloat = 1.0
    
    private var zoomScale: CGFloat {
        if self.selectedEmojis.isEmpty {
            return self.document.steadyStateZoomScale * self.gestureZoomScale
        } else {
            return self.document.steadyStateZoomScale
        }
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, transaction in
                gestureZoomScale = latestGestureScale
            }
            .onEnded { finalGestureScale in
                if self.selectedEmojis.isEmpty {
                    self.document.steadyStateZoomScale *= finalGestureScale
                } else {
                    for selectedEmoji in self.selectedEmojis {
                        self.document.scaleEmoji(selectedEmoji, by: finalGestureScale)
                    }
                }
            }
    }

    var isLoading: Bool {
        document.backgroundURL != nil && document.backgroundImage == nil
    }
    
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    private var panOffset: CGSize {
        (document.steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, transaction in
                gesturePanOffset = latestDragGestureValue.translation / self.zoomScale
        }
        .onEnded { finalDragGestureValue in
            self.document.steadyStatePanOffset = self.document.steadyStatePanOffset + (finalDragGestureValue.translation / self.zoomScale)
        }
    }

    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    self.zoomToFit(self.document.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0, size.height > 0, size.width > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            self.document.steadyStatePanOffset = .zero
            self.document.steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
        
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        if selectedEmojis.contains(emoji) {
            location = CGPoint(x: location.x + selectedEmojisPanOffset.width, y: location.y + selectedEmojisPanOffset.height)
        }
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint(x: location.x + size.width/2, y: location.y + size.height/2)
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)
        return location
    }

    private func fontSize(for emoji: EmojiArt.Emoji) -> CGFloat {
        if selectedEmojis.contains(emoji) {
            return emoji.fontSize * (self.zoomScale * self.gestureZoomScale)
        } else {
            return emoji.fontSize * self.zoomScale
        }
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            self.document.backgroundURL = url
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                self.document.addEmoji(string, at: location, size: self.defaultEmojiSize)
            }
        }
        return found
    }

    @State var selectedEmojis = Set<EmojiArt.Emoji>()
    private let selectedBrightness: Double = 0.2

    private func tapToSelectEmoji(_ emoji: EmojiArt.Emoji) -> some Gesture {
        TapGesture()
            .onEnded {
                withAnimation() {
                    self.selectedEmojis.toggle(emoji)
                }
            }
    }

    private func tapToDeselectAllEmojis() -> some Gesture {
        TapGesture()
            .onEnded {
                withAnimation() {
                    self.selectedEmojis.removeAll()
                }
            }
    }

    @GestureState private var selectedEmojisPanOffset: CGSize = .zero

    private func panSelectedEmojis(_ tappedEmoji: EmojiArt.Emoji) -> some Gesture {
        return DragGesture()
            .updating($selectedEmojisPanOffset) { latestDragGestureValue, selectedEmojisPanOffset, transaction in
                if self.selectedEmojis.contains(tappedEmoji) {
                    selectedEmojisPanOffset = latestDragGestureValue.translation / self.zoomScale
                }
            }
            .onEnded { finalDragGestureValue in
                let scaledTranslation = finalDragGestureValue.translation / self.zoomScale
                if self.selectedEmojis.contains(tappedEmoji) {
                    for selectedEmoji in self.selectedEmojis {
                        self.document.moveEmoji(selectedEmoji, by: scaledTranslation)
                    }
                }
            }
    }

    struct RemoveSelectedButton: View {
        let action: () -> Void

        var body: some View {
            Button(action: action) {
            HStack {
                Image(systemName: "trash")
                Text("Remove selected")
            }
            .foregroundColor(.red)
            }
            .padding(.horizontal)
        }
    }


    private let defaultEmojiSize: CGFloat = 40
}
