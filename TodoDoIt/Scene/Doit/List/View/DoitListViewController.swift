//
//  DoitListViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/02.
//

import UIKit

class DoitListViewController: BaseViewController {
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private typealias DoitCellRegistration = UICollectionView.CellRegistration<DoitCollectionViewCell,DoIt>
    var dataSource: UICollectionViewDiffableDataSource<DoitSectionType,DoIt>?
    let viewmodel = DoitListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavibar()
        configureDataSource()
        bind()
        viewmodel.fetch()
    }
    
    private func setNavibar(){
        navigationItem.title = "목표리스트"
        let button = UIBarButtonItem(image:UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func addButtonTapped(){
        navigationController?.pushViewController(DoitAddViewController(), animated: true)
    }
    private func bind(){
        viewmodel.doitresult.bind { _ in
            self.viewmodel.fetchList()
        }
        viewmodel.doitList.bind { _ in
            self.updateSnapshot()
        }
    }
    override func setHierarchy() {
        view.addSubview(collectionView)
        view.backgroundColor = .white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}

//MARK: CollectionView
extension DoitListViewController{
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            let containerGroup: NSCollectionLayoutGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.2)),
                subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: containerGroup)
            return section
        }
        return layout
    }
    
    func configureDataSource() {
        let doitCellRegistration = DoitCellRegistration { cell, indexPath, identifier in
            cell.setupData(doit: identifier)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
                let cell = collectionView.dequeueConfiguredReusableCell(using: doitCellRegistration, for: indexPath, item: itemIdentifier)
                return cell
        }
    }
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<DoitSectionType, DoIt>()
        snapshot.appendSections(DoitSectionType.allCases)
        snapshot.appendItems(viewmodel.getDoitList(),toSection: .doing)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}
