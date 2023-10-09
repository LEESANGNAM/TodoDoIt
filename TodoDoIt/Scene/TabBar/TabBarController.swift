//
//  TabBarController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/26.
//

import UIKit

class TabbarController: UITabBarController {
    let HomeVC = UINavigationController(rootViewController: HomeViewController())
    let DoitListVC = UINavigationController(rootViewController: DoitListViewController())
    let TodoListVC = UINavigationController(rootViewController: TodoListViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [HomeVC,DoitListVC,TodoListVC]
        setupTabbar()
    }
    
    private func setupTabbar(){
        tabBar.tintColor = Design.Color.blackFont
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.backgroundColor = Design.Color.background
        setupTabbarItem()
    }
    
    private func setupTabbarItem(){
        HomeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), tag: 0)
        DoitListVC.tabBarItem = UITabBarItem(title: "목표", image: UIImage(systemName: "book.fill"), tag: 1)
        TodoListVC.tabBarItem = UITabBarItem(title: "할일", image: UIImage(systemName: "checklist.checked"), tag: 2)
    }
    
    
}
