# TodoDoIt

### 실행화면
<p>
<img src = "https://github.com/LEESANGNAM/TodoDoIt/assets/61412496/519d94ab-9eda-4900-bec9-8082c58d2105.png" width="20%"/>
<img src = "https://github.com/LEESANGNAM/TodoDoIt/assets/61412496/c993dd90-29fa-409e-ae6b-405eb5fa32b4.png" width="20%"/>
<img src = "https://github.com/LEESANGNAM/TodoDoIt/assets/61412496/b294beb2-fcb2-4393-9c38-82efcf36f418.png" width="20%"/>
<img src = "https://github.com/LEESANGNAM/TodoDoIt/assets/61412496/aff9d3e7-c504-47ac-9415-a690b4476885.png" width="20%"/>
</p>
<p>
<img src = "https://github.com/LEESANGNAM/TodoDoIt/assets/61412496/efbee232-b777-4114-84da-7e09a3625f9c.png" width="20%"/>
<img src = "https://github.com/LEESANGNAM/TodoDoIt/assets/61412496/d8053e92-29e7-405a-8163-d1fb2872aca5.png" width="20%"/>
<img src = "https://github.com/LEESANGNAM/TodoDoIt/assets/61412496/bbac3277-2c0e-4d2d-b71a-b343de4f271b.png" width="20%"/>
<img src = "https://github.com/LEESANGNAM/TodoDoIt/assets/61412496/4103cd94-ed0f-4e85-9495-a16b6f39059d.png" width="20%"/>
</p>


### 간단소개
목표를 설정하고 달성 현황을 확인 할 수 있는 TodoList 


## 개발기간 
2023.09.25 ~ 2023.10.20 / 1.0 출시 이후 업데이트
## 사용 기술 및 라이브러리
+ UIKit, AutoLayout
+ CompositionalLayout, DiffableDataSource
+ MVC, MVVM
+ Local Notification
+ Firebase
    + Google Analytics
    + Crashlytics
+ SnapKit, Toast, FSCalendar    
+ Realm, Zip


### 기능 소개
+ **FSCalendar** 를 활용해 날짜별 데이터 표시
+ **CompositionalLayout** 을 활용해 홈화면 구현
+ **UIBezierPath** 를 활용해 원형 프로그래스바 구현
+ **Observable** 클래스를 활용해 MVVM 패턴 적용
+ **repository pattern을**  활용해 Realm사용
+ **Realm** 을 활용해 목표,메모,할일 데이터 CRUD
+ **FileManager** 를 활용해 원본 이미지 저장
+ **Zip** 을 활용해 데이터 백업 및 복구
+ **Firebase (Analytics, Crashlytics)** 를 활용해 유저 관리 및 앱 기능 분석
+ **UNUserNotificationCenter** 를 활용해 **Local Notification** 구현

## 트러블슈팅
[트러블슈팅 전체보기](https://west-cicada-052.notion.site/dfef67fbe68d4285bdeee820cc057be2?pvs=4)

### 1. Main thread에서 이미지 불러와 리사이징 하는 과정에서 테이블뷰 스크롤시 버벅거리는 현상
1. 메인쓰레드에서 비동기로 이미지뷰의 사이즈를 가져온다.
2. 백그라운드 쓰레드에서 파일매니저를 통해 이미지를 가져 온다
3. 가져온 이미지를 이미지뷰 크기만큼 리사이징 해준다.
4. 메인쓰레드에서 이미지를 넣어준다.

```swift 
func setData(data: DoitCompleted, totalcount: Int, index: Int){
        let filename = data.imageTitle + ".jpg"
        // 이미지뷰 크기를 비동기로 가져오기
        DispatchQueue.main.async {
            let size = CGSize(width: self.completeImageView.frame.width, height: self.completeImageView.frame.height)

            self.setImage(filename: filename, size: size)
        }
        dateLabel.text = data.createDate.changeFormatString(format: "dd일")
        yearMonthLabel.text = data.createDate.changeFormatString(format: "yyyy년MM월")
        memoLabel.text = data.impression
        countLabel.text = "\(totalcount - index)회차"
    }
    func setImage(filename: String, size: CGSize) {
        DispatchQueue.global().async {
            if let fileImage = FileManager.loadImageFromDocumentDirectory(fileName: filename) {
                let image = fileImage.reSize(to: size)
                DispatchQueue.main.async {
                    self.completeImageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.completeImageView.backgroundColor = .systemGray3
                }
            }
        }
    }
```
### 2. modalPresentationStyle(OverFullscreen)이후 ViewwillAppear 실행 안되는문제
viewWillAppear 에서 데이터를 갱신하는데 갱신이 되지않아 델리게이트 패턴을 활용해 문제를 해결했다.

```swift
protocol ModalPresentDelegate: AnyObject {
    func sendDateToModal() -> Date
    func disMissModal(section: SectionType)
}
```

```swift
weak var delegate: ModalPresentDelegate?

@objc func tapgestureTapped(){
        dismissModal()
    }
    private func dismissModal(){
        titleTextField.resignFirstResponder()
        dismiss(animated: true)
        delegate?.disMissModal(section: .todo)  // 닫힐때 호출
    }
```

```swift
extension HomeViewController: ModalPresentDelegate {
    func sendDateToModal() -> Date {
        return selectDate
    }
    
    func disMissModal(section: SectionType) {
        switch section {
        case .doit:
            viewmodel.fetchDoitData(date: selectDate)
            fsCalendar.reloadData()
        case .todo:
            viewmodel.fetchTodoData(date: selectDate)
            fsCalendar.reloadData()
        case .memo:
            viewmodel.fetchMemoData(date: selectDate)
            fsCalendar.reloadData()
        }
    }
}
```
### 3. 원형 프로그래스뷰 그려지지않는 문제
+ 메인스레드에서 데이터를넣어 그려지게해서 해결
```swift
 DispatchQueue.main.async { [weak self] in
            self?.mainview.circularProgressbar.value = self?.viewmodel.getDoitProgress()
        }
  ```

## 개인일지
|날짜|이터레이션|링크|
|------|----|---|
|2023년 9월 26일|이터레이션1|[💻](https://west-cicada-052.notion.site/1-9-26-a90e18a63e704fb88af9934fb87c0e0e?pvs=4)
|2023년 9월 27일|이터레이션1|[💻](https://west-cicada-052.notion.site/1-9-27-df04d855983d497ea46e282171a9677f?pvs=4)
|2023년 9월 28일|이터레이션2|[💻](https://west-cicada-052.notion.site/2-9-28-71989bf1bdfd4d81ac0dd07999842798?pvs=4)
|2023년 9월 30일|이터레이션2|[💻](https://west-cicada-052.notion.site/2-9-30-e2c330bc02454bab8fe2bab18627cf6a?pvs=4)
|2023년 10월 1일|이터레이션2|[💻](https://west-cicada-052.notion.site/2-10-1-f064f08c0c6a4f4fada1de4f946455f4?pvs=4)
|2023년 10월 2일|이터레이션3|[💻](https://west-cicada-052.notion.site/3-10-2-376c165bdf844437a574b3448b1c2570?pvs=4)
|2023년 10월 3일|이터레이션3|[💻](https://www.notion.so/3-10-3-b035ddcd0c7045f7bcf4620aeec6c943?pvs=4)
|2023년 10월 4일|이터레이션3|[💻](https://www.notion.so/3-10-4-d785f0a3628c462783ff945414eb7135?pvs=4)
|2023년 10월 5일|이터레이션3|[💻](https://www.notion.so/4-10-5-f7d5349f7fd342209907f2cfaed84a48?pvs=4)
|2023년 10월 6일|이터레이션4|[💻](https://www.notion.so/4-10-6-18fdcc601aa44e87a06840f1c7829325?pvs=4)
|2023년 10월 7일|이터레이션4|[💻](https://www.notion.so/4-10-7-8a89c75cf64e45d18c48d697c48bb248?pvs=4)
|2023년 10월 8일|이터레이션4|[💻](https://www.notion.so/4-10-8-3044a3e6afa7415894fed7fb9f35b921?pvs=4)
|2023년 10월 9일|이터레이션5|[💻](https://www.notion.so/5-10-9-c25b179051c14d399fd607e2138352fe?pvs=4)
|2023년 10월 10일|이터레이션5|[💻](https://www.notion.so/5-10-10-e4ea8ed2da8b46a6a7329277d3b88d7a?pvs=4)
|2023년 10월 11일|이터레이션5|[💻](https://www.notion.so/5-10-11-5e7e7a52acab4b23a3f3f4eba82067a8?pvs=4)
|2023년 10월 12일|이터레이션6|[💻](https://www.notion.so/6-10-12-5290281491514666b49ba110c547dc77?pvs=4)
|2023년 10월 13일|이터레이션6|[💻](https://www.notion.so/6-10-13-03146f57fae2406ebbb7a123ff068bcd?pvs=4)
|2023년 10월 14일|이터레이션6|[💻](https://www.notion.so/6-10-14-c43baa9601ac437d82269e8942ce5595?pvs=4)
|2023년 10월 15일|이터레이션6|[💻](https://www.notion.so/6-10-15-368304d0435742548fadafa9b5614681?pvs=4)
|2023년 10월 16일|이터레이션7|[💻](https://www.notion.so/7-10-16-70b2c4e744bf40abb1e248ecbd49e6b1?pvs=4)
|2023년 10월 17일|이터레이션7|[💻](https://www.notion.so/7-10-17-2436331457ee44108830bf69f235b586?pvs=4)
|2023년 10월 18일|이터레이션7|[💻](https://www.notion.so/7-10-18-1aa5cd2c9ec54b9d91a6a2f955cf9fa9?pvs=4)
|2023년 10월 19일|이터레이션8|[💻](https://www.notion.so/8-10-19-6b1717a97bf74b3eb46c13475a73a4ea?pvs=4)
|2023년 10월 20일|이터레이션8|[💻](https://www.notion.so/8-10-20-ac207961d7824de9a53c66ff83ac3e71?pvs=4)

	

## 업데이트 내역
+ 1.0.1 (2023.10.30)
  + 알림추가
+ 1.0.2 (2023.10.31)
  + 버그수정
+ 1.1.0 (2023.11.06)
  + 메모 모아보기 추가
+ 1.1.1 (2023.11.13)
  + 코드개선 및 버그수정 
