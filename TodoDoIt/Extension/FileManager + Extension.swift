//
//  FileManager + Extension.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/13.
//

import Foundation
import UIKit

extension FileManager {
    static func saveImageToDocumentDirectory(image: UIImage, fileName: String) -> String? {
        //document 경로
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        // Images 디렉토리 경로 생성
        let imagesDirectory = documentsDirectory.appendingPathComponent("Images")
        
        // 디렉토리가 없으면 생성
        if !FileManager.default.fileExists(atPath: imagesDirectory.path) {
            do {
                try FileManager.default.createDirectory(atPath: imagesDirectory.path, withIntermediateDirectories: true, attributes: nil)
                print("Images 디렉토리 생성 성공")
            } catch {
                print("Images 디렉토리 생성 실패: \(error.localizedDescription)")
                return nil
            }
        }
        // 이미지 디렉토리에 저장
        let fileURL = imagesDirectory.appendingPathComponent(fileName)
        //        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality: 0.0) {
            do {
                try data.write(to: fileURL)
                return fileURL.path
            } catch {
                print("Error saving image: \(error)")
                return nil
            }
        }
        return nil
    }
    
    static func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
        // document경로
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        // Images 디렉토리 경로 설정
        let imagesDirectory = documentsDirectory.appendingPathComponent("Images")
        
        // 이미지를 Images 디렉토리에서 가져오기
        let fileURL = imagesDirectory.appendingPathComponent(fileName)
        
        //        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image: \(error)")
            return nil
        }
    }
    
    static func deleteImageFromDocumentDirectory(imageName: String) {
        // Documents 폴더 경로 가져오기
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        // Images 디렉토리 경로 설정
        let imagesDirectory = documentsDirectory.appendingPathComponent("Images")
        
        // 이미지를 Images 디렉토리에서 삭제
        let imageURL = imagesDirectory.appendingPathComponent(imageName)
        if FileManager.default.fileExists(atPath: imageURL.path) {
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제 완료")
            } catch {
                print("이미지를 삭제하지 못했습니다.")
            }
        }
    }
}


