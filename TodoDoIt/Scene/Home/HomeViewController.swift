//
//  ViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/24.
//

import UIKit
import FSCalendar
import SnapKit

enum SectionType: Int, CaseIterable {
    case one, two, three
    
    var title: String {
        switch self {
        case .one:
            return "목표"
        case .two:
            return "할일"
        case .three:
            return "메모"
        }
    }
}


class HomeViewController: BaseViewController {
    private weak var fsCalendar: FSCalendar!
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private typealias DoitCellRegistration = UICollectionView.CellRegistration<DoitCollectionViewCell,String>
    
    
    var dataSource: UICollectionViewDiffableDataSource<SectionType,String>?
    let testData1 = ["여기는", "목표", "들어가야함","자리임", "나오겠지"]
    let testData2 = ["요기는", "메모", "들어갈껄?", "자리야" ,"나와라"]
    let testData3 = ["이칸은", "할일", "들어가야지", "자리", "나와야함"]
    
    let repository = Repository<DoIt>()
    
    override func viewDidLoad() {
         super.viewDidLoad()
        setupCalendar()
        setCollectionView()
        setConstraint()
        configureDataSource()
        
//        let testModel = DoIt(title: "테스트목표 데이터", startDate: Date(), endDate: Date(), complete: 30)
//        let testModel2 = DoIt(title: "목표데이터 완료결과 넣는것", startDate: Date(), endDate: Date(), complete: 20)
//        let testComplet = DoitCompleted(title: testModel2.title, impression: "목표2를1번달성~")
//        let testMemo = Memo(title: "물챙겨야함")
//        testModel2.doitComplete.append(testComplet)
//        repository.createItem(testModel)
//        repository.createItem(testModel2)
//        repository.createItem(testMemo)
//
        let calendar = Calendar.current
        var testDateComponents = DateComponents()
        testDateComponents.year = 2023
        testDateComponents.month = 10
        testDateComponents.day = 13
        if let testDate = calendar.date(from: testDateComponents){ //2023.10.13 일자가 포함된 목표 출력 테스트
            let result = repository.fetchFilterContainsDate(date: testDate)
            print(result)
        }
        
        
        
     }
    
   
    
    private func setCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(ListCollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MySectionHeaderView")
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setConstraint() {
        fsCalendar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(fsCalendar.snp.bottom).offset(20)
            make.bottom.greaterThanOrEqualTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
    }
}

//MARK: - collectionView, diffableDatasource
extension HomeViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            var containerGroup: NSCollectionLayoutGroup!
            if sectionIndex == 0 {
                containerGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(0.3)),
                    subitem: item, count: 1)
            } else {
                containerGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(0.2)),
                    subitem: item, count: 1)
            }
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.1))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.boundarySupplementaryItems = [sectionHeader]
            return section

        }
        return layout
    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, identifier) in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = identifier
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = UIColor(red: CGFloat(Int.random(in: 0...1)), green: CGFloat(Int.random(in: 0...1)), blue: CGFloat(Int.random(in: 0...1)), alpha: 1)
            backgroundConfig.cornerRadius = 10
            cell.backgroundConfiguration = backgroundConfig
        }
        
        let doitCellRegistration = DoitCellRegistration { cell, indexPath, identifier in
            cell.titleLabel.text = "테스트요오오옹 목표에요~~"
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let section = SectionType(rawValue: indexPath.section) else { return UICollectionViewCell()}
            // 섹션별로 다른 셀
            switch section {
            case .one:
                let cell = collectionView.dequeueConfiguredReusableCell(using: doitCellRegistration, for: indexPath, item: itemIdentifier)
                return cell
            case .two:
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
                return cell
            case .three:
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
                return cell
            }
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                // 섹션 헤더를 만들고 반환
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MySectionHeaderView", for: indexPath) as! ListCollectionViewHeaderView
                // headerView의 내용 설정
                headerView.titleLabel.text = SectionType.allCases[indexPath.section].title
                headerView.addButton.tag = indexPath.section
                headerView.addButton.addTarget(self, action: #selector(self.addButtonTapped), for: .touchUpInside)
                return headerView
            } else {
                return nil
            }
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, String>()
        snapshot.appendSections(SectionType.allCases)
        snapshot.appendItems(testData1,toSection: SectionType.allCases[0])
        snapshot.appendItems(testData2,toSection: SectionType.allCases[1])
        snapshot.appendItems(testData3,toSection: SectionType.allCases[2])
        dataSource?.apply(snapshot, animatingDifferences: false)
        
    }
    @objc func addButtonTapped(_ sender: UIButton){
        switch sender.tag {
        case 0: navigationController?.pushViewController(DoitAddViewController(), animated: true)
        case 1: break
        case 2: break
        default: break
        }
    }
}

// MARK: - FSCalendar
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource{
    private func setupCalendar() {
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.backgroundColor = .white
        calendar.scrollDirection = .horizontal
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = .black //Today에 표시되는 특정 글자색
//        calendar.scope = .week // 주간 달력 설정
         view.addSubview(calendar)
         self.fsCalendar = calendar
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
    }
    
//    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        calendar.snp.updateConstraints { make in
//            make.height.equalTo(bounds.height)
//            make.top.equalTo(view.safeAreaLayoutGuide)
//        }
//        self.view.layoutIfNeeded()
//
//    }
}

