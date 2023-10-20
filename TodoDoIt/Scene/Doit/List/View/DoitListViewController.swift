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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewmodel.fetch()
    }
    
    private func setNavibar(){
        navigationItem.title = "목표리스트"
        navigationItem.titleView?.tintColor = Design.Color.blackFont
        let button = UIBarButtonItem(image:UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        button.tintColor = Design.Color.blackFont
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func addButtonTapped(){
        if viewmodel.getDoitList().count < 5 {
            navigationController?.pushViewController(DoitAddViewController(), animated: true)
        }else{
            view.makeToast("도전중인 목표가 있습니다. \n 도전은 5개까지 가능합니다.")
        }
    }
    private func bind(){
        viewmodel.doitresult.bind { _ in
            self.viewmodel.fetchList()
            self.updateSnapshot()
        }
    }
    override func setHierarchy() {
        view.addSubview(collectionView)
        view.backgroundColor = Design.Color.background
        collectionView.register(ListCollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MySectionHeaderView")
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = Design.Color.background
        collectionView.delegate = self
    }
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}

extension DoitListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selecteItem =
            dataSource?.itemIdentifier(for: indexPath){
            let vc = DoitDetailViewController()
            vc.viewmodel.doitkey.value = selecteItem._id
            navigationController?.pushViewController(vc, animated: true)
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
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.1))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.boundarySupplementaryItems = [sectionHeader]
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
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                // 섹션 헤더를 만들고 반환
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MySectionHeaderView", for: indexPath) as! ListCollectionViewHeaderView
                // headerView의 내용 설정
                let title = DoitSectionType.allCases[indexPath.section].title
                headerView.addButton.setTitle(title, for: .normal)
                headerView.addButton.configuration?.image = nil
                headerView.listButton.isHidden = true
                return headerView
            } else {
                return nil
            }
        }
    }
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<DoitSectionType, DoIt>()
        snapshot.appendSections(DoitSectionType.allCases)
        snapshot.appendItems(viewmodel.getDoitList(),toSection: .doing)
        snapshot.appendItems(viewmodel.getDoitFinishList(),toSection: .complete)
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
}
