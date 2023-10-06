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
        title = "할일리스트"
        bind()
        viewmodel.fetchData(date: today)
     }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewmodel.fetchData(date: today)
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
    
    func disMissModal() {
        viewmodel.fetchData(date: selectDate)
    }
    
    
}

// MARK: - FSCalendar
extension TodoListViewController: FSCalendarDelegate, FSCalendarDataSource{
    private func setupCalendar() {
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        calendar.scrollDirection = .horizontal
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerMinimumDissolvedAlpha = 0
//        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = .black //Today에 표시되는 특정 글자색
        calendar.scope = .week
        
         self.fsCalendar = calendar
        view.addSubview(fsCalendar)
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
        
    }
//    private func setUpSwipeGusture(){
//        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
//        swipeUp.direction = .up
//        self.view.addGestureRecognizer(swipeUp)
//
//        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
//        swipeDown.direction = .down
//        self.view.addGestureRecognizer(swipeDown)
//    }
//    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
//
//        if swipe.direction == .up {
//            fsCalendar.setScope(.week, animated: true)
//        }
//        else if swipe.direction == .down {
//            fsCalendar.setScope(.month, animated: true)
//        }
//    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { make in
            make.height.equalTo(bounds.height)
        }
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }
    //날짜 선택
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
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
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

