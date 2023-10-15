//
//  TodoListViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/06.
//

import UIKit
import FSCalendar
import SnapKit

class TodoListViewController: BaseViewController {
    private weak var fsCalendar: FSCalendar!
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private typealias TodoCellRegistration = UICollectionView.CellRegistration<TodoCollectionViewCell,Todo>
    
    var dataSource: UICollectionViewDiffableDataSource<Int,Todo>?

    
    let viewmodel = TodoListViewModel()
    var selectDate = Date() // 선택날짜
    let today = Date() // 오늘
    override func viewDidLoad() {
         super.viewDidLoad()
        configureDataSource()
        setNavibar()
        bind()
        viewmodel.fetchData(date: today)
     }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewmodel.fetchData(date: today)
        fsCalendar.reloadData()
    }
   
    private func setNavibar(){
        navigationItem.title = "할일목록"
        navigationItem.titleView?.tintColor = Design.Color.blackFont
        let button = UIBarButtonItem(image:UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(addButtonTapped))
        button.tintColor = Design.Color.blackFont
        navigationItem.rightBarButtonItem = button
    }
    @objc private func addButtonTapped(){
        let vc = TodoAddViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc,animated: true)
    }
    
    private func bind(){
        viewmodel.todoResult.bind { _ in
            self.viewmodel.changeTodoArray()
        }
        viewmodel.todoArray.bind { _ in
            self.updateSnapshot()
        }
    }
   
    
    private func setCollectionView(){
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = Design.Color.background
    }
    override func setHierarchy() {
        setCollectionView()
        setupCalendar()
    }
    override func setConstraints(){
        fsCalendar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(fsCalendar.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
    }
}
// MARK: - Modaldelegate
extension TodoListViewController: ModalPresentDelegate {
    
    func sendDateToModal() -> Date {
        return selectDate
    }
    
    func disMissModal(section: SectionType) {
        viewmodel.fetchData(date: selectDate)
        fsCalendar.reloadData()
    }
    
    
}

// MARK: - FSCalendar
extension TodoListViewController: FSCalendarDelegate, FSCalendarDataSource{
    private func setupCalendar() {
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        calendar.scrollDirection = .horizontal
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.scope = .week

        // Weekday 폰트 설정
        calendar.appearance.weekdayFont = UIFont(name: "NotoSansKR-Regular", size: 14)
        // 각각의 일(날짜) 폰트 설정 (ex. 1 2 3 4 5 6 ...)
        calendar.appearance.titleFont = UIFont(name: "NotoSansKR-Regular", size: 16)
        
        //요일 글자색
        calendar.appearance.headerTitleColor = Design.Color.blackFont
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
}



//MARK: - collectionView, diffableDatasource
extension TodoListViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            var containerGroup: NSCollectionLayoutGroup!
            
                containerGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(0.15)),
                    subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: containerGroup)
            return section

        }
        return layout
    }
    
    func configureDataSource() {
        let todoCellRegistration = TodoCellRegistration { cell, indexPath, identifier in
            cell.setupData(todo: identifier)
            cell.checkboxButton.tag = indexPath.item
            cell.checkboxButton.addTarget(self, action: #selector(self.checkButtonTapped), for: .touchUpInside)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
                let cell = collectionView.dequeueConfiguredReusableCell(using: todoCellRegistration, for: indexPath, item: itemIdentifier )
                return cell
        }
        

    }
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Todo>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewmodel.getTodoArray())
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }

    @objc func checkButtonTapped(_ sender: UIButton){
        let index = IndexPath(item: sender.tag, section: 0)
        if let selecteItem = dataSource?.itemIdentifier(for: index){
            var finish = selecteItem.finish
            finish.toggle()
            viewmodel.updateTodo(todo: selecteItem,finish: finish)
            viewmodel.fetchData(date: selectDate)
//            reloadDatashnpshot(index: index)
        }
    }
}

