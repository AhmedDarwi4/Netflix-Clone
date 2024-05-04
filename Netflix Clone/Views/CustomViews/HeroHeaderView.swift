//
//  HeroHeaderView.swift
//  Netflix Clone
//
//  Created by Ahmed Darwish on 16/04/2024.
//

import UIKit

class HeroHeaderView: UIView {
    
    let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "Testing Poster")
        return imageView
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.label.cgColor
        button.setTitle("Play", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.label.cgColor
        button.setTitle("Download", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let buttonsStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
       addSubview(buttonsStackView)
       buttonsStackView.addArrangedSubview(playButton)
       buttonsStackView.addArrangedSubview(downloadButton)
       addConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    private func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)

    }
    
    public func configure(with model: ShowViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterUrl)")else{return}
        heroImageView.sd_setImage(with: url)
    }
    
    private func addConstraints(){
        
        NSLayoutConstraint.activate([

            buttonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 34),
            buttonsStackView.widthAnchor.constraint(equalToConstant: 280)

          
//            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
//            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
//            playButton.widthAnchor.constraint(equalToConstant: 120),
//
//            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
//            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
//            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
