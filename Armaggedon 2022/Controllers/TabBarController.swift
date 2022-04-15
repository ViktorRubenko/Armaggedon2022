//
//  TabBarController.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)
        
        let nav1 = UINavigationController(
            rootViewController: AsteroidsListViewController(
                viewModel: AsteroidsListViewModel()))
        let nav2 = UINavigationController(
            rootViewController: DestroyAsteroidsListViewController(
                viewModel: DestroyAsteroidsListViewModel())
        )
        
        [nav1, nav2].forEach {
            $0.navigationBar.scrollEdgeAppearance = navBarAppearance
            $0.navigationBar.standardAppearance = navBarAppearance
        }
        
        nav1.tabBarItem = UITabBarItem(title: "Астероиды", image: UIImage(systemName: "globe"), tag: 0)
        nav2.tabBarItem = UITabBarItem(title: "Уничтожение", image: UIImage(systemName: "trash"), tag: 1)
        
        setViewControllers([nav1, nav2], animated: false)
    }
}
