//
//  SettingViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/19.
//

import UIKit
import RealmSwift
import Zip

class SettingViewController: BaseViewController {
    let tableView = UITableView()
    let settingList = SettingEnum.allCases
    let dataEnumList = DataEnum.allCases
    let openSourceEnumList = OpenSourceEnum.allCases
    lazy var settingDataList = [dataEnumList.map{ $0.title },openSourceEnumList.map{ $0.title }]
    
    override func setHierarchy() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Design.Color.background
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - tableViewDelegate
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = settingList[section]
        let index = data.rawValue
        
        return settingDataList[index].count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingList[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "tableViewcell")
        cell.textLabel?.font = .systemFont(ofSize: Design.Font.contentFontSize)
        cell.backgroundColor = Design.Color.background
        let data = settingDataList[indexPath.section][indexPath.row]
        cell.textLabel?.text = data
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 데이터 백업 셀을 선택했을 때의 처리
        let section = settingList[indexPath.section]
        switch section{
        case .data:
            let dataSecion = dataEnumList[indexPath.row]
            switch dataSecion {
            case .reset:
                showAlert(text: "기존 데이터가 전부 삭제됩니다. \n 정말 삭제하시겠습니까?",addButtonText: "확인") {[weak self] in
                    self?.resetData()
                }
            case .backup:
                let today = Date().changeFormatString(format: "yyyyMMdd")
                let fileName = "TodoDoIt-\(today)"
                if let zipfileURL = backupDataAndImagesToDocumentDirectory(fileNamge: fileName){
                    showActivityViewController(fileURL: zipfileURL)
                }else {
                    view.makeToast("데이터가 없습니다.")
                }
            case .restore:
                showAlert(text: "기존 데이터가 전부 삭제됩니다. \n 백업 데이터로 복구하시겠습니까?",addButtonText: "복구") {[weak self] in
                    self?.showDocumentViewController()
                }
            }
        case .opneSource:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
//MARK: didselect Event
extension SettingViewController {
    // Document 폴더에 "Images" 디렉토리와 "default.realm" 파일을 압축하여 저장하는 함수
    func backupDataAndImagesToDocumentDirectory(fileNamge: String) -> URL? {
            //1. 백업하고자 하는 파일들의 경로 배열 생성
            var urlPaths = [URL]()
            
            // Document 디렉토리 경로 가져오기
             guard let documentsDirectory = FileManager.getDocumentDirectoryPath() else {
                print("Document 디렉토리를 찾을 수 없습니다.")
                return nil
            }
        
            //3. 백업하고자 하는 파일 경로
            // "realm file","Images" 디렉토리의 경로 설정 + "backup" 경로 및 생성
            let realmFile = documentsDirectory.appendingPathComponent("default.realm")
            let imagesDirectory = documentsDirectory.appendingPathComponent("Images")
            
            //4. 3번 경로가 유효한지 확인
            guard FileManager.default.fileExists(atPath: realmFile.path) else {
                print("백업할 파일이 없습니다.")
                return nil
            }
            guard FileManager.default.fileExists(atPath: imagesDirectory.path) else {
                print("백업할 이미지파일이 없습니다.")
                return nil
            }
            do{
                //5. 압축하고자 하는 파일을 배열에 추가
                urlPaths.append(imagesDirectory)
                urlPaths.append(realmFile)
                let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: fileNamge)
                print("location: \(zipFilePath)")
                return zipFilePath
            }catch{
                print("압축실패")
                return nil
            }
        }
    
    private func showActivityViewController(fileURL: URL){
        guard let path = FileManager.getDocumentDirectoryPath() else {
            print("도큐먼트 오류")
            return
        }
        let vc = UIActivityViewController(activityItems: [fileURL], applicationActivities: [])
        present(vc,animated: true)
    }
    private func showDocumentViewController(){
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false // 여러개 선택 막기
        
        present(documentPicker, animated: true)
    }
    
    private func resetData() {
        // Realm 데이터 초기화
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
            print("Realm 데이터 초기화 성공")
        } catch {
            print("Realm 데이터 초기화 실패: \(error.localizedDescription)")
            return
        }

        // Images 디렉토리 삭제
        guard let imagesDirectory = FileManager.getDocumentDirectoryPath()?.appendingPathComponent("Images") else {
            print("Images 디렉토리를 찾을 수 없습니다.")
            return
        }

        do {
            try FileManager.default.removeItem(at: imagesDirectory)
            print("Images 디렉토리 삭제 성공")
        } catch {
            print("Images 디렉토리 삭제 실패: \(error.localizedDescription)")
        }
    }
}


//MARK: - DocumentPickerDelegate: 파일가져오기
extension SettingViewController: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { // 파일 앱에서 선택한 url
            print("선택한 파일에오류가 있어요~")
            return
        }
        guard let path = FileManager.getDocumentDirectoryPath() else{
            print("도큐먼트 위치에 오류가 있어요")
            return
        }
        print(selectedFileURL, "선택한 파일 검사")
        
        guard isValidBackupFile(fileURL: selectedFileURL) else {
            print("잘못된 zip 파일")
            return
        }
        
        // 도큐먼트 폴더 내 저장할 경로 설정
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        //경로에 복구할 파일 (zip)이 이미 있는지 확인
        if FileManager.default.fileExists(atPath: sandboxFileURL.path){
            do {                  // 어떤파일, 어디다가풀건가, 덮어쓰기, 패스워드, 압축 진행률
                try Zip.unzipFile(sandboxFileURL, destination: path, overwrite: true, password: nil,progress: { progress in
                    print("============progress: ",progress)
                },fileOutputHandler: { unzippedFile in
                    print("===========unzippedfile(압축해제 완료)",unzippedFile)
                    print("압축 종료됨이건 클로저 안쪽 호출")
                })
                dismissToast()
            }catch{
                print("압축해제실패")
            }
            
        }else {
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                try Zip.unzipFile(sandboxFileURL, destination: path, overwrite: true, password: nil,progress: { progress in
                    print("============progress: ",progress)
                },fileOutputHandler: { unzippedFile in
                    print("===========unzippedfile(압축해제 완료)",unzippedFile)
                    print("압축 종료됨이건 클로저 안쪽 호출")
                })
                dismissToast()
            } catch{
                print("여기뜨는거임?")
                print("압축해제실패 오류~")
            }
            //경로에 복구할 파일이 없을 때의 대응
        }
        
    }
    private func dismissToast(){
        self.view.makeToast("잠시뒤 앱이 종료됩니다. 다시 켜주세요")
        showAlert(text: "앱을 재실행해야 복구 데이터가 적용 됩니다. 앱을 재실행 해주세요",addButtonText: "확인") {[weak self] in
            exit(2)
        }
    }
    // 앱 이름 들어갔는지 복구파일 검사
    private func isValidBackupFile(fileURL: URL) -> Bool {
        let appName = "TodoDoIt"
        // 마지막 : 파일명 0000.zip
        let fileName = fileURL.lastPathComponent
        // 앱 이름이 포함되어 있는지 확인
        return fileName.contains(appName)
    }

}






