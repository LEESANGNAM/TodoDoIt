//
//  MemoListViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/11/04.
//

import UIKit


class MemoListViewController: BaseViewController {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private typealias MemoCellRegistration = UICollectionView.CellRegistration<MemoListCollectionViewCell,Memo>
    var dataSource: UICollectionViewDiffableDataSource<Int,Memo>?
    let viewmodel = MemoListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bind()
        title = "모든 메모"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewmodel.fetchData()
    }
    func bind(){
        viewmodel.memoResult.bind { [weak self] _ in
            self?.viewmodel.changeMemoArray()
            self?.updateSnapshot()
        }
    }
    override func setHierarchy() {
        view.addSubview(collectionView)
    }
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}

//MARK: CollectionView
extension MemoListViewController{
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                   heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            var containerGroup: NSCollectionLayoutGroup!
            
                containerGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(0.3)),
                    subitem: item, count: 2)
            let section = NSCollectionLayoutSection(group: containerGroup)
            return section

        }
        return layout
    }
    
    func configureDataSource() {
        let memoCellRegistration = MemoCellRegistration { cell, indexPath, identifier in
            cell.setUpData(memo: identifier)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
                let cell = collectionView.dequeueConfiguredReusableCell(using: memoCellRegistration, for: indexPath, item: itemIdentifier )
                return cell
        }
        

    }
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Memo>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewmodel.getMemoArray())
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
}
