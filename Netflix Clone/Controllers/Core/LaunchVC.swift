//
//  LaunchVC.swift
//  Netflix Clone
//
//  Created by Ahmed Darwish on 26/04/2024.
//

import UIKit

class LaunchVC: UIViewController {
    
    let launchImageView: UIImageView = {
       let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        imageView.image = UIImage(named: "mainlogo")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(launchImageView)
        view.backgroundColor = .systemBackground
       
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        launchImageView.center = view.center
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.animate()
        })
       
    }
    
    private func animate(){
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 1.5
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            self.launchImageView.frame = CGRect(x:-(diffX/2),
                                                y: diffY/2,
                                                width: size,
                                                height: size)
            
        })
        
        UIView.animate(withDuration: 1.5, animations: {
            self.launchImageView.alpha = 0
        }) { done in
            if done{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                    let VC = MainTabBarVC()
                    VC.modalPresentationStyle = .fullScreen
                    VC.modalTransitionStyle = .crossDissolve
                    self.present(VC, animated: true)
                })
            }
        }
        
        
        
  
        
        
        
    }
    
}
