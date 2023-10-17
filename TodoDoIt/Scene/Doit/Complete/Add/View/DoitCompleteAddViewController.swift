//
//  DoitCompleteAddViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/11.
//

import UIKit
import PhotosUI

class DoitCompleteAddViewController: BaseViewController {
    
    private let mainView = DoitCompleteAddView()
    var picker: PHPickerViewController!
    weak var delegate: ModalPresentDelegate?
    let viewmodel = DoitCompleteAddViewModel()
    let textViewPlaceHolder = "메모를 입력해주세요"
    var originImage: UIImage?
    var memoText = ""
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPHPicker()
        setmemoTextView()
        setTapGesture()
        setSaveButton()
    }
    
    private func setPHPicker(){
        var phPickerConfiguration = PHPickerConfiguration()
        phPickerConfiguration.filter = .any(of: [.images,.livePhotos])
        picker = PHPickerViewController(configuration: phPickerConfiguration)
        picker.delegate = self
    }
    
    private func setSaveButton(){
        mainView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func saveButtonTapped(){
        let completed = DoitCompleted(impression: memoText)
        let imagename = completed.imageTitle + ".jpg"
        viewmodel.updateValue(complete: completed)
        viewmodel.saveImage(image: originImage,imageName: imagename)
        dismiss(animated: true)
        delegate?.disMissModal(section: .doit)
        
    }
    
    private func setmemoTextView(){
        mainView.memoTextView.text = textViewPlaceHolder
        mainView.memoTextView.textColor = .lightGray
        mainView.memoTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        mainView.memoTextView.delegate = self
    }
    
    
    private func setTapGesture(){
        let imageViewTapgesture = UITapGestureRecognizer(target: self, action: #selector(ImageViewTapgesture))
        mainView.imageView.addGestureRecognizer(imageViewTapgesture)
        mainView.imageView.isUserInteractionEnabled = true
        
        let mainViewTapgesture = UITapGestureRecognizer(target: self, action: #selector(MainViewTapgesture))
        mainView.addGestureRecognizer(mainViewTapgesture)
        
    }
    
    @objc private func ImageViewTapgesture() {
        present(picker, animated: true)
    }
    @objc private func MainViewTapgesture() {
        mainView.endEditing(true)
    }
    
}

extension DoitCompleteAddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder{
            textView.text = nil
            textView.textColor = Design.Color.blackFont
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }else {
            memoText = textView.text
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        memoText = text
    }
    
}


//MARK: - PHPicker
extension DoitCompleteAddViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        let itemProvider = results.first?.itemProvider // 2
                
                if let itemProvider = itemProvider,
                   itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
                    itemProvider.loadObject(ofClass: UIImage.self) {[weak self] (image, error) in // 4
                        DispatchQueue.main.async { [weak self] in
                            self?.originImage = image as? UIImage
                            self?.mainView.imageView.image = image as? UIImage // 5
                            self?.mainView.plusImageView.isHidden = true
                        }
                    }
                } else {
                    // TODO: Handle empty results or item provider not being able load UIImage
                }
    }
    
    
}
