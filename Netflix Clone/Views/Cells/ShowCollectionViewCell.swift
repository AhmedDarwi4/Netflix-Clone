//
//  MovieCell.swift
//  Netflix Clone
//
//  Created by Ahmed Darwish on 19/04/2024.
//

import UIKit
import SDWebImage

class ShowCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = String(describing: ShowCollectionViewCell.self)
    
    let posterImageView: ShowImageView = {
        let imageView = ShowImageView(frame: .zero)
        return imageView
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    func configur(with model: String){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
            return
            
        }
        
        posterImageView.sd_setImage(with: url, completed: nil)
        //print(model)
    }
    
 
    
}
