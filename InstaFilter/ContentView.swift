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
    @State private var filterRadius = 0.5
    @State private var filterInputScale = 0.5
    
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    @State private var showingFilterSheet = false
    @State private var processedImage: UIImage?
    
    @State private var noImageSelected = false
    @State private var filterSelection = ""
    
    @State private var showIntensitySlider = false
    @State private var showRadiusSlider = false
    @State private var showInputScaleSlider = false
    
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
        
        let radius = Binding<Double>(
            get: {
                self.filterRadius
            },
            set: {
                self.filterRadius = $0
                self.applyProcessing()
            }
        )
        
        let inputScale = Binding<Double>(
            get: {
                self.filterInputScale
            },
            set: {
                self.filterInputScale = $0
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
                VStack {
                    if showIntensitySlider {
                        HStack {
                            Text("Intensity")
                            Slider(value: intensity)
                        }.padding(.vertical)
                    }
                    if showRadiusSlider {
                        HStack {
                            Text("Radius")
                            Slider(value: radius)
                        }.padding(.vertical)
                    }
                    if showInputScaleSlider {
                        HStack {
                            Text("Input Scale")
                            Slider(value: inputScale)
                        }.padding(.vertical)
                    }
                }
                
                HStack {
                    Button("Change Filter\(filterSelection)") {
                        //change filter
                        self.showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        // save the picture
                        guard let processedImage = self.processedImage else {
                            noImageSelected = true
                            return }
                        
                        let imageSaver = ImageSaver()
                        
                        imageSaver.successHandler = {
                            print("Success!")
                        }
                        imageSaver.errorHandler = {
                            print("Oops: \($0.localizedDescription)")
                        }
                        imageSaver.writeToPhotoAlbum(image: processedImage)
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("Instafilter")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            .actionSheet(isPresented: $showingFilterSheet) {
                //action sheet goes here
                ActionSheet(title: Text("Select a filter"), buttons: [
                    // selection of filters that are available to choose from
                    .default(Text("Crystallize")) {
                        filterSelection = ": Crystallize"
                        self.setFilter(CIFilter.crystallize()) },
                    .default(Text("Edges")) {
                        filterSelection = ": Edges"
                        self.setFilter(CIFilter.edges()) },
                    .default(Text("Gaussian Blur")) {
                        filterSelection = ": Gaussian Blur"
                        self.setFilter(CIFilter.gaussianBlur()) },
                    .default(Text("Pixellate")) {
                        filterSelection = ": Pixellate"
                        self.setFilter(CIFilter.pixellate()) },
                    .default(Text("Sepia Tone")) {
                        filterSelection = ": Sepia Tone"
                        self.setFilter(CIFilter.sepiaTone()) },
                    .default(Text("Unsharp Mask")) {
                        filterSelection = ": Unsharp Mask"
                        self.setFilter(CIFilter.unsharpMask()) },
                    .default(Text("Vignette")) {
                        filterSelection = ": Vignette"
                        self.setFilter(CIFilter.vignette()) },
                    .default(Text("Dither")) {
                        filterSelection = ": Dither"
                        self.setFilter(CIFilter.dither())
                    },
                    .cancel()
                ])
            }
            .alert(isPresented: $noImageSelected) {
                Alert(title: Text("Woops!"), message: Text("You need to select an image"), dismissButton: .cancel())
            }
        }
    }
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {
            showIntensitySlider = true
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) } else {
                showIntensitySlider = false
            }
        if inputKeys.contains(kCIInputRadiusKey) {
            showRadiusSlider = true
            currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey) } else {
                showRadiusSlider = false
            }
        if inputKeys.contains(kCIInputScaleKey) {
            showInputScaleSlider = true
            currentFilter.setValue(filterInputScale * 10, forKey:kCIInputScaleKey)} else {
                showInputScaleSlider = false
            }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
