//
//  ViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/24.
//

import UIKit
import FSCalendar
import SnapKit
import RealmSwift

class HomeViewController: BaseViewController {
    private weak var fsCalendar: FSCalendar!
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private typealias DoitCellRegistration = UICollectionView.CellRegistration<DoitCollectionViewCell,DoIt>
    private typealias TodoCellRegistration = UICollectionView.CellRegistration<TodoCollectionViewCell,Todo>
    private typealias MemoCellRegistration = UICollectionView.CellRegistration<MemoCollectionViewCell,Memo>
    
    
    var dataSource: UICollectionViewDiffableDataSource<SectionType,Object>?
    
    let viewmodel = HomeViewModel()
    
    override func viewDidLoad() {
         super.viewDidLoad()
        configureDataSource()
        bind()
        viewmodel.fetchData()
     }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewmodel.fetchData()
    }
    private func bind(){
        viewmodel.doitResult.bind { _ in
            self.viewmodel.changeDoitArray()
        }
        viewmodel.doitArray.bind {_ in
            self.updateSnapshot()
        }
        viewmodel.todoResult.bind { _ in
            self.viewmodel.changeTodoArray()
        }
        viewmodel.todoArray.bind {_ in
            self.updateSnapshot()
        }
        viewmodel.memoResult.bind { _ in
            self.viewmodel.changeMemoArray()
        }
        viewmodel.memoArray.bind {_ in
            self.updateSnapshot()
        }
    }
   
    
    private func setCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(ListCollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MySectionHeaderView")
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    override func setHierarchy() {
        setCollectionView()
        setupCalendar()
    }
    override func setConstraints(){
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
            
            let sectionType = SectionType.allCases[sectionIndex]
            
            switch sectionType{
            case .doit:
                containerGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(0.3)),
                    subitem: item, count: 1)
            case .todo:
                containerGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(0.2)),
                    subitem: item, count: 1)
            case .memo:
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
        
        let doitCellRegistration = DoitCellRegistration { cell, indexPath, identifier in
            cell.setupData(doit: identifier)
        }
        let todoCellRegistration = TodoCellRegistration { cell, indexPath, identifier in
            cell.setupData(todo: identifier)
        }
        let memoCellRegistration = MemoCellRegistration { cell, indexPath, identifier in
            cell.setupData(memo: identifier)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let section = SectionType(rawValue: indexPath.section) else { return UICollectionViewCell()}
            // 섹션별로 다른 셀
            switch section {
            case .doit:
                let cell = collectionView.dequeueConfiguredReusableCell(using: doitCellRegistration, for: indexPath, item: itemIdentifier as! DoIt)
                return cell
            case .todo:
                let cell = collectionView.dequeueConfiguredReusableCell(using: todoCellRegistration, for: indexPath, item: itemIdentifier as! Todo)
                return cell
            case .memo:
                let cell = collectionView.dequeueConfiguredReusableCell(using: memoCellRegistration, for: indexPath, item: itemIdentifier as! Memo)
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
                headerView.listButton.tag = indexPath.section
                headerView.listButton.addTarget(self, action: #selector(self.listButtonTapped), for: .touchUpInside)
                return headerView
            } else {
                return nil
            }
        }
    }
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, Object>()
        snapshot.appendSections(SectionType.allCases)
        snapshot.appendItems(viewmodel.getDoitArray(),toSection: .doit)
        snapshot.appendItems(viewmodel.getTodoArray(),toSection: .todo)
        snapshot.appendItems(viewmodel.getMemoArray(),toSection: .memo)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    @objc func addButtonTapped(_ sender: UIButton){
        switch sender.tag {
        case 0: navigationController?.pushViewController(DoitAddViewController(), animated: true)
        case 1:
            let vc = TodoAddViewController()
//            if let sheet = vc.sheetPresentationController{
//                sheet.detents = [.medium(), .large()]
//                sheet.prefersGrabberVisible = true
//            }
            vc.modalPresentationStyle = .overFullScreen
            present(vc,animated: true)
        case 2: break
        default: break
        }
    }
    @objc func listButtonTapped(_ sender: UIButton){
        switch sender.tag {
        case 0:
            if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1
        }
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

