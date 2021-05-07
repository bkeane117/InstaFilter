//
//  ContentView.swift
//  InstaFilter
//
//  Created by Brendan Keane on 2021-05-07.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins


struct ContentView: View {
    @State private var blurAmount: CGFloat = 0
    
    @State private var showingActionSheet = false
    @State private var backgroundColor = Color.white
    @State private var image: Image?
    @State private var showingImagePicker = false
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
            Button("Select Image") {
                self.showingImagePicker = true
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker()
        }
        //.onAppear(perform: loadImage)
    }
    func loadImage() {
        guard let inputImage = UIImage(named: "bjj") else { return }
        let beginImage = CIImage(image: inputImage)
        let context = CIContext()

        guard let currentFilter = CIFilter(name: "CITwirlDistortion") else { return }
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter.setValue(500, forKey: kCIInputRadiusKey)
        currentFilter.setValue(CIVector(x: inputImage.size.width / 2, y: inputImage.size.height / 2), forKey: kCIInputCenterKey)
        /*
        let currentFilter = CIFilter.twirlDistortion()
        currentFilter.inputImage = beginImage
        currentFilter.radius = 500
        currentFilter.center = CGPoint(x: inputImage.size.width, y: inputImage.size.height)
        */
        /*
        let currentFilter = CIFilter.crystallize()
        currentFilter.inputImage = beginImage
        currentFilter.radius = 200
        */
        /*
        let currentFilter = CIFilter.pixellate()
        currentFilter.inputImage = beginImage
        currentFilter.scale = 100
 */
        /*
        let currentFilter = CIFilter.sepiaTone()
        currentFilter.inputImage = beginImage
        currentFilter.intensity = 1
        */
        
        // get a CIImage from out filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }
        //attempt to get a CGImage from our CIImage
        if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
            //convert that into a UIImage
            let uiImage = UIImage(cgImage: cgimage)
            
            // and covert that to a swiftUI image
            image = Image(uiImage: uiImage)
        }
        
        //image = Image("bjj")
    }
    /*
    {
        Text("Hello, World!")
            .frame(width: 300, height: 300)
            .background(backgroundColor)
            .onTapGesture {
                self.showingActionSheet = true
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Change background"), message: Text("Select a new color"), buttons: [
                    .default(Text("Red")) { self.backgroundColor = .red },
                    .default(Text("Green")) { self.backgroundColor = .green },
                    .default(Text("Blue")) { self.backgroundColor = .blue },
                    .cancel()
                ])
            }
        }
        */
        /*
        let blur = Binding<CGFloat>(
            get: {
                self.blurAmount
            },
            set: {
                self.blurAmount = $0
                print("New value is \(self.blurAmount)")
            }
        )
        VStack {
            Text("Hello, world!")
                .blur(radius: blurAmount)
            
            Slider(value: blur, in: 0...20)
        }
    }
 */
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
