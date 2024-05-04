//
//  MovieImageView.swift
//  Netflix Clone
//
//  Created by Ahmed Darwish on 19/04/2024.
//

import UIKit

class ShowImageView: UIImageView {
    
    let placeholderImage  = Constants.Images.placeholder

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    
    }
    
    func configure(){
        contentMode = .scaleAspectFill
        clipsToBounds = true
        image = placeholderImage
      
        
    }
    
}
