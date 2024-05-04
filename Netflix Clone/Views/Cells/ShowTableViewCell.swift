//
//  ShowTableViewCell.swift
//  Netflix Clone
//
//  Created by Ahmed Darwish on 22/04/2024.
//

import UIKit

class ShowTableViewCell: UITableViewCell {
    
   static let cellIdentifier = String(describing: ShowTableViewCell.self)
    
    let posterImageView: ShowImageView = {
        let imageView = ShowImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let showNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(posterImageView,showNameLabel)
        configureUI()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(with model:ShowViewModel){
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterUrl)") else {
                  return
                }
        posterImageView.sd_setImage(with: url, completed: nil)
        showNameLabel.text = model.showName
    }
    
  //  Other methods achieve the same result
    
//    func set(with model:Show,imagepath:String){
//        showNameLabel.text = model.originalTitle
//        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(imagepath)") else {
//            return
//        }
//        posterImageView.sd_setImage(with: url, completed: nil)
//    }
    
//    func getImage(with model:String){
//        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
//            return
//        }
//
//        posterImageView.sd_setImage(with: url, completed: nil)
//    }
    
    private func configureUI(){
        accessoryType = .disclosureIndicator
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            posterImageView.widthAnchor.constraint(equalToConstant: 120),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            
            showNameLabel.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            showNameLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            showNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            showNameLabel.heightAnchor.constraint(equalToConstant: 50)
        
        ])
    }
    
}
