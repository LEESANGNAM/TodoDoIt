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
import Toast

class HomeViewController: BaseViewController {
    private weak var fsCalendar: FSCalendar!
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private typealias DoitCellRegistration = UICollectionView.CellRegistration<DoitCollectionViewCell,DoIt>
    private typealias TodoCellRegistration = UICollectionView.CellRegistration<TodoCollectionViewCell,Todo>
    private typealias MemoCellRegistration = UICollectionView.CellRegistration<MemoCollectionViewCell,Memo>
    private typealias NotDataCellRegistration = UICollectionView.CellRegistration<NotDataCollectionViewCell,Object>
    
    var dataSource: UICollectionViewDiffableDataSource<SectionType,Object>?
    
    private let emptyDoit = DoIt()
    private let emptyTodo = Todo()
    private let emptyMemo = Memo()
    
    
    let viewmodel = HomeViewModel()
    var selectDate = Date() // 선택날짜
    let today = Date() // 오늘
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        setUpSwipeGusture()
        bind()
        setNavigationBar(title: today.changeFormatString(format: "yyyy년MM월"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewmodel.fetchData(date: selectDate)
        fsCalendar.reloadData()
    }
    
    func setNavigationBar(title: String){
        navigationItem.title = title
    }
    
    private func bind(){
        viewmodel.doitResult.bind { _ in
            self.viewmodel.changeArray()
            self.updateSnapshot()
        }
        viewmodel.todoResult.bind { _ in
            self.viewmodel.changeArray()
            self.updateSnapshot()
        }
        viewmodel.memoResult.bind { _ in
            self.viewmodel.changeArray()
            self.updateSnapshot()
        }
    }
    
    
    private func setCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(ListCollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MySectionHeaderView")
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.backgroundColor = Design.Color.background
    }
    override func setHierarchy() {
        setCollectionView()
        setupCalendar()
    }
    override func setConstraints(){
        fsCalendar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(250)
        }
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(fsCalendar.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
    }
}
// MARK: - Modaldelegate
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

// MARK: - FSCalendar
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource{
    private func setupCalendar() {
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        calendar.scrollDirection = .horizontal
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.headerHeight = 0.0
        calendar.appearance.headerMinimumDissolvedAlpha = 0

        // Weekday 폰트 설정
        calendar.appearance.weekdayFont = UIFont(name: "NotoSansKR-Regular", size: 14)
        // 각각의 일(날짜) 폰트 설정 (ex. 1 2 3 4 5 6 ...)
        calendar.appearance.titleFont = UIFont(name: "NotoSansKR-Regular", size: 16)
        
        //요일 글자색
        calendar.appearance.weekdayTextColor = Design.Color.blackFont
        calendar.appearance.titleDefaultColor = Design.Color.blackFont
        // 상단 요일을 한글로 변경
        calendar.locale = Locale(identifier: "ko_KR")
        
        // 이벤트 표시 색상
        calendar.appearance.eventDefaultColor = Design.Color.cell
        calendar.appearance.todayColor = Design.Color.cell
        calendar.appearance.selectionColor = Design.Color.cell
        

        
        self.fsCalendar = calendar
        view.addSubview(fsCalendar)
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
        
    }
    private func setUpSwipeGusture(){
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
        
        if swipe.direction == .up {
            fsCalendar.setScope(.week, animated: true)
        }
        else if swipe.direction == .down {
            fsCalendar.setScope(.month, animated: true)
        }
    }
    // 날짜 이벤트 표시
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return viewmodel.dateOfCountItem(date: date)
        }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { make in
            make.height.equalTo(bounds.height)
        }
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }
    //날짜 선택 이벤트
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = Design.Color.blackFont
        viewmodel.fetchData(date: date)
        selectDate = date
    }
    // 페이지변경 이벤트
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let pageTitle = calendar.currentPage.changeFormatString(format: "yyyy년MM월")
        setNavigationBar(title: pageTitle)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = SectionType(rawValue: indexPath.section) else { return }
        switch section {
        case .doit:
            if let selecteItem =
                dataSource?.itemIdentifier(for: indexPath) as? DoIt{
                if selecteItem._id == emptyDoit._id{
                    navigationController?.pushViewController(DoitAddViewController(), animated: true)
                }else {
                    let vc = DoitDetailViewController()
                    vc.viewmodel.doitkey.value = selecteItem._id
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        case .todo:
            if let selectItem = dataSource?.itemIdentifier(for: indexPath) as? Todo {
                if selectItem._id == emptyTodo._id{
                    let vc = TodoAddViewController()
                    vc.delegate = self
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    present(vc,animated: true)
                }else {
                    let vc = TodoDetailViewcontroller()
                    vc.delegate = self
                    if  let sheet = vc.sheetPresentationController {
                        sheet.detents = [.medium()]
                        sheet.prefersGrabberVisible = true
                    }
                    vc.viewmodel.todokey.value = selectItem._id
                    present(vc, animated: true)
                }
            }
        case .memo:
            if let selectItem = dataSource?.itemIdentifier(for: indexPath) as? Memo {
                if selectItem._id == emptyMemo._id{
                    let vm = MemoAddViewModel(memoKey: nil)
                    let vc = MemoAddViewController(viewmodel: vm)
                    vc.delegate = self
                    if  let sheet = vc.sheetPresentationController {
                        sheet.detents = [.medium(), .large()]
                        sheet.prefersGrabberVisible = true
                    }
                    present(vc, animated: true)
                } else {
                    let vm = MemoAddViewModel(memoKey: selectItem._id)
                    let vc = MemoAddViewController(viewmodel: vm)
                    vc.delegate = self
                    if  let sheet = vc.sheetPresentationController {
                        sheet.detents = [.medium(), .large()]
                        sheet.prefersGrabberVisible = true
                    }
                    present(vc, animated: true)
                }
            }
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
                                                       heightDimension: .absolute(90)),
                    subitem: item, count: 1)
            case .todo:
                containerGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(75)),
                    subitem: item, count: 1)
            case .memo:
                containerGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(75)),
                    subitem: item, count: 1)
            }
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.1))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = .paging
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
            cell.checkboxButton.tag = indexPath.item
            cell.checkboxButton.addTarget(self, action: #selector(self.checkButtonTapped), for: .touchUpInside)
            
        }
        let memoCellRegistration = MemoCellRegistration { cell, indexPath, identifier in
            cell.setupData(memo: identifier)
        }
        let notDataCellRegistraion = NotDataCellRegistration { cell, indexPath, itemIdentifier in
            guard let section = SectionType(rawValue: indexPath.section) else { return }
            cell.setupData(section: section)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let section = SectionType(rawValue: indexPath.section) else { return UICollectionViewCell()}
            
            switch section {
            case .doit:
                if self.viewmodel.getDoitArray().isEmpty {
                    let cell =  collectionView.dequeueConfiguredReusableCell(using: notDataCellRegistraion, for: indexPath, item: itemIdentifier)
                    return cell
                } else {
                    let cell = collectionView.dequeueConfiguredReusableCell(using: doitCellRegistration, for: indexPath, item: itemIdentifier as? DoIt)
                    return cell
                }
            case .todo:
                if self.viewmodel.getTodoArray().isEmpty {
                    let cell =  collectionView.dequeueConfiguredReusableCell(using: notDataCellRegistraion, for: indexPath, item: itemIdentifier)
                    return cell
                } else {
                    let cell = collectionView.dequeueConfiguredReusableCell(using: todoCellRegistration, for: indexPath, item: itemIdentifier as? Todo)
                    return cell
                }
            case .memo:
                if self.viewmodel.getMemoArray().isEmpty {
                    let cell =  collectionView.dequeueConfiguredReusableCell(using: notDataCellRegistraion, for: indexPath, item: itemIdentifier)
                    return cell
                } else {
                    let cell = collectionView.dequeueConfiguredReusableCell(using: memoCellRegistration, for: indexPath, item: itemIdentifier as? Memo)
                    return cell
                }
            }
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                // 섹션 헤더를 만들고 반환
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MySectionHeaderView", for: indexPath) as! ListCollectionViewHeaderView
                // headerView의 내용 설정
                let title = SectionType.allCases[indexPath.section].title
                headerView.addButton.setTitle(title, for: .normal)
                
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
        
        let doitArray = viewmodel.getDoitArray().isEmpty ? [emptyDoit] : viewmodel.getDoitArray()
        let todoArray = viewmodel.getTodoArray().isEmpty ? [emptyTodo] : viewmodel.getTodoArray()
        let memoArray = viewmodel.getMemoArray().isEmpty ? [emptyMemo] : viewmodel.getMemoArray()
        
        
        snapshot.appendItems(doitArray,toSection: .doit)
        snapshot.appendItems(todoArray,toSection: .todo)
        snapshot.appendItems(memoArray,toSection: .memo)
        //        dataSource?.apply(snapshot, animatingDifferences: true)
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
    
    @objc func addButtonTapped(_ sender: UIButton){
        let section = SectionType(rawValue: sender.tag)
        switch section {
        case .doit:
            if viewmodel.validDoitCount() {
                navigationController?.pushViewController(DoitAddViewController(), animated: true)
            }else{
                view.makeToast("도전중인 목표가 있습니다. \n 도전은 5개까지 가능합니다.")
            }
        case .todo:
            let vc = TodoAddViewController()
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc,animated: true)
        case .memo:
            if let memo = viewmodel.getMemoArray().first{
                self.view.makeToast("메모는 하루에 한개만 가능합니다. 메모가 이미 있습니다.")
            }else {
                let vm = MemoAddViewModel(memoKey: nil)
                let vc = MemoAddViewController(viewmodel: vm)
                vc.delegate = self
                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [.medium(),.large()]
                    sheet.prefersGrabberVisible = true
                }
                present(vc, animated: true)
            }
        case .none:
            print("error")
        }
    }
    @objc func listButtonTapped(_ sender: UIButton){
        let section = SectionType(rawValue: sender.tag)
        switch section {
        case .doit:
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 1
            }
        case .todo:
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 2
            }
        case .memo:
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 3
            }
        case .none:
            print("Error")
        }
    }
    
    @objc func checkButtonTapped(_ sender: UIButton){
        let index = IndexPath(item: sender.tag, section: 1)
        if let selecteItem = dataSource?.itemIdentifier(for: index) as? Todo {
            var finish = selecteItem.finish
            finish.toggle()
            viewmodel.updateTodo(todo: selecteItem,finish: finish)
            viewmodel.fetchTodoData(date: selectDate)
        }
    }
}
