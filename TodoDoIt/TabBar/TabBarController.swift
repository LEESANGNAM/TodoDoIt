//
//  TabBarController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/26.
//

import UIKit

class TabbarController: UITabBarController {
    let HomeVC = UINavigationController(rootViewController: HomeViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [HomeVC]
        setupTabbar()
    }
    
    private func setupTabbar(){
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.backgroundColor = .white
        setupTabbarItem()
    }
    
    private func setupTabbarItem(){
        HomeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), tag: 0)
    }
    
    
}
