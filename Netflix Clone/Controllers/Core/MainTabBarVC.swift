//
//  MainTabBarVC.swift
//  Netflix Clone
//
//  Created by Ahmed Darwish on 13/04/2024.
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
        createTabBar()
        UITabBar.appearance().tintColor = .label
    }
    
   
    
  private func createTabBar(){
        let homeVC       = HomeVC()
        let upcomingVC   = UpcomingVC()
        let searchVC     = SearchVC()
        let downloadsVC  = DownloadsVC()
      
        let nav1 = UINavigationController(rootViewController: homeVC)
        let nav2 = UINavigationController(rootViewController: upcomingVC)
        let nav3 = UINavigationController(rootViewController: searchVC)
        let nav4 = UINavigationController(rootViewController: downloadsVC)

     
      
      nav1.tabBarItem = UITabBarItem(title: "Home", image:Constants.SFSynmols.home, tag: 1)
      nav2.tabBarItem = UITabBarItem(title: "Upcoming", image:Constants.SFSynmols.upcoming, tag: 2)
      nav3.tabBarItem = UITabBarItem(title: "Top Search", image:Constants.SFSynmols.topSearch, tag: 3)
      nav4.tabBarItem = UITabBarItem(title: "Downloads", image:Constants.SFSynmols.downloads, tag: 4)
      
      let navs = [nav1,nav2,nav3,nav4]
      for nav in navs{
          nav.navigationBar.prefersLargeTitles = true
      }
      
      setViewControllers(navs, animated: true)

    }

}
