//
//  TabBarViewController.swift
//  tmdbAPI
//
//  Created by João Jacó Santos Abreu on 18/02/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = .black
        self.tabBar.tintColor = .white
        self.tabBar.isTranslucent = false
        
        let firstTab = UINavigationController(rootViewController: MainScreenViewController(viewModel: MainScreenViewModel()))
        let secondTab = UINavigationController(rootViewController: LibraryViewController())
        
        let homeImage = UIImage(systemName: "house.fill")
        firstTab.tabBarItem = UITabBarItem(title: "Home", image: homeImage, tag: 0)
        
        let libImage = UIImage(systemName: "heart.fill")
        secondTab.tabBarItem = UITabBarItem(title: "Favoritos", image: libImage, tag: 0)
        
        viewControllers = [firstTab,secondTab]
    }

}
