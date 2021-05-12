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
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    
    @State private var currentFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View {
        let intensity = Binding<Double>(
            get: {
                self.filterIntensity
            },
            set: {
                self.filterIntensity = $0
                self.applyProcessing()
            }
        )
        return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    // display the image
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    // select an image
                    self.showingImagePicker = true
                }
                
                HStack {
                    Text("Intensity")
                    Slider(value: intensity)
                }.padding(.vertical)
                
                HStack {
                    Button("Change Filter") {
                        //change filter
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        // save the picture
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("Instafilter")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
        }
    }
    func applyingProcessing() {
        currentFilter.intensity = Float(filterIntensity)
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
        }
    }
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    func applyProcessing() {
        currentFilter.intensity = Float(filterIntensity)
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
        }
    }
}

/*
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

/*
 COMPLET PROCESSS FOR INTERACTING WITH UIKIT
 We created a SwiftUI view that conforms to UIViewControllerRepresentable.
 We gave it a makeUIViewController() method that created some sort of UIViewController, which in our example was a UIImagePickerController.
 We added a nested Coordinator class to act as a bridge between the UIKit view controller and our SwiftUI view.
 We gave that coordinator a didFinishPickingMediaWithInfo method, which will be triggered by UIKit when an image was selected.
 Finally, we gave our ImagePicker an @Binding property so that it can send changes back to a parent view.
*/

struct ContentView: View {
    @State private var blurAmount: CGFloat = 0
    
    @State private var showingActionSheet = false
    @State private var backgroundColor = Color.white
    @State private var image: Image?
    @State private var inputImage: UIImage?
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
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
        //.onAppear(perform: loadImage)
    }
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        //UIImageWriteToSavedPhotosAlbum(inputImage, nil, nil, nil)
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: inputImage)

    }
    /*
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
    */
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
*/
class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
