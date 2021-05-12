//
//  ImagePicker.swift
//  InstaFilter
//
//  Created by Brendan Keane on 2021-05-07.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
/*
// this section is required to interface with UIKit Image picker
struct ImagePicker: UIViewControllerRepresentable {
    //used to create a binding from ImagePicker and ContentVIew
    @Binding var image: UIImage?
    //add this property so that we can dismiss the view programatically
    @Environment(\.presentationMode) var presentationMode
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        //tells UIImagePickerController that when something happens, tell our coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    // create a coordinator class
    /*
     1. It makes the class inherit from NSObject, which is the parent class for almost everything in UIKit. NSObject allows Objective-C to ask the object what functionality it supports at runtime, which means the image picker can say things like “hey, the user selected an image, what do you want to do?”
     2. It makes the class conform to the UIImagePickerControllerDelegate protocol, which is what adds functionality for detecting when the user selects an image. (NSObject lets Objective-C check for the functionality; this protocol is what actually provides it.)
     3. It makes the class conform to the UINavigationControllerDelegate protocol, which lets us detect when the user moves between screens in the image picker.
     */
     
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        // tell parent who it's parent is so that we cam modify it's values directly
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    // initializes our coordinator. We don not need to call it ourselves, swift does it for us when we create our ImagePicker
    func makeCoordinator() -> Coordinator {
        //pass image picker struct into the coordinator
        Coordinator(self)
    }
}
*/
