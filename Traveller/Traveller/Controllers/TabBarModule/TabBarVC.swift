//
//  HomeTabBarVC.swift
//  DatingKinky
//
//  Created by Ubuntu on 7/24/20.
//  Copyright © 2020 Ubuntu. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController, UITabBarControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let items = tabBar.items else { return }
            if language.language == .eng{
                items[0].title = "Search"
                items[1].title = "My trips"
                items[2].title = "Chat"
                items[3].title = "Rating"
                items[4].title = "Profile"
            }else{
                items[0].title = RUS.SEARCH
                items[1].title = RUS.MY_TRIPS
                items[2].title = RUS.CHAT
                items[3].title = RUS.RATING
                items[4].title = RUS.PROFILE
            }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        /*let attributes = [NSAttributedString.Key.font: UIFont(name: "TrueMegaMaru-Ultra", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
        if let count = self.tabBar.items?.count {
            
            /*self.tabBar.items![1].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(named: "color_people_title") ?? UIColor.darkGray], for: .normal)
            self.tabBar.items![1].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(named: "color_people_title") ?? UIColor.darkGray], for: .selected)*/
            
            /*self.tabBar.items![3].setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)], for: .normal)
            self.tabBar.items![3].setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 21)], for: .selected)*/
            
            self.tabBar.items![3].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(named: "color_plus_title") ?? UIColor.darkGray], for: .normal)
            
            self.tabBar.items![3].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(named: "color_plus_title") ?? UIColor.darkGray], for: .selected)
           
            
            // set red as selected background color
//            let numberOfItems = CGFloat(tabBar.items!.count)
//            let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
//
//            tabBar.backgroundImage = UIImage.imageWithColor(color: UIColor.white, size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)
//
//            // remove default border
//            tabBar.frame.size.width = self.view.frame.width + 4
//            tabBar.frame.origin.x = -2
        }*/
    }
     
   /*func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //print("\nIn  >  MyTabBarViewController  >  tabBarController() ..................................9-9-9-9-9\n\n")
       
        if viewController is PlusVC {
            print("Tab One Pressed")
            let numberOfItems = CGFloat(tabBar.items!.count)
            let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
            self.tabBar.backgroundImage = UIImage.imageWithColor(color: UIColor.white, size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)
        }
    }*/
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        /*if MenuopenStatue{
            darkVC.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            darkVC.view.removeFromSuperview()
            UIView.animate(withDuration: 0.3, animations: {
                menuVC.view.frame = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                //self.menuVC.view.removeFromSuperview()
                menuVC.view.willRemoveSubview(menuVC.view)
            })
        }*/
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //print(viewController)
    }
}

// MARK: - TransitionableTab Protocols
/*extension TabBarVC: TransitionableTab {
    
    func transitionDuration() -> CFTimeInterval {
        return 0.3
    }
    
    func transitionTimingFunction() -> CAMediaTimingFunction {
        return .easeInOut
    }
    
    func fromTransitionAnimation(layer: CALayer?, direction: Direction) -> CAAnimation {
        return DefineAnimation.move(.from, direction: direction)
    }
    
    func toTransitionAnimation(layer: CALayer?, direction: Direction) -> CAAnimation {
        return DefineAnimation.move(.to, direction: direction)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return animateTransition(tabBarController, shouldSelect: viewController)
    }
}*/
// UITabBarDelegate

