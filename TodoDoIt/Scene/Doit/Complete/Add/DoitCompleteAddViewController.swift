//
//  DoitCompleteAddViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/11.
//

import UIKit
import PhotosUI

class DoitCompleteAddViewController: BaseViewController {
    
    let mainView = DoitCompleteAddView()
    var picker: PHPickerViewController!
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPHPicker()
        setTapGesture()
    }
    
    private func setPHPicker(){
        var phPickerConfiguration = PHPickerConfiguration()
        phPickerConfiguration.filter = .any(of: [.images,.livePhotos])
        picker = PHPickerViewController(configuration: phPickerConfiguration)
        picker.delegate = self
    }
    
    
    private func setTapGesture(){
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(TapGestureTapped))
        mainView.imageView.addGestureRecognizer(tapgesture)
        mainView.imageView.isUserInteractionEnabled = true
    }
    
    @objc private func TapGestureTapped() {
        print("탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭탭")
        present(picker, animated: true)
    }
    
}

//MARK: - PHPicker
extension DoitCompleteAddViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        let itemProvider = results.first?.itemProvider // 2
                
                if let itemProvider = itemProvider,
                   itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
                    itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in // 4
                        DispatchQueue.main.async {
                            self.mainView.imageView.image = image as? UIImage // 5
                            self.mainView.plusImageView.isHidden = true
                        }
                    }
                } else {
                    // TODO: Handle empty results or item provider not being able load UIImage
                }
    }
    
    
}
