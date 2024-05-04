//
//  ShowPreviewVC.swift
//  Netflix Clone
//
//  Created by Ahmed Darwish on 29/04/2024.
//

import UIKit
import WebKit

class ShowPreviewVC: UIViewController {
    
    let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    let showNamelabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight:.bold)
        label.text = "Harry Potter"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let overviewlabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight:.regular)
        label.text = "Harry Potter is one of the super natural movies and a great series to watch with youtr family."
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.backgroundColor = .systemRed
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(webView,showNamelabel,overviewlabel,downloadButton)
        addConstraints()
    }
  
    
    func addConstraints(){
        let padding:CGFloat = 20
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor,constant: 100),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300),
            
            showNamelabel.topAnchor.constraint(equalTo: webView.bottomAnchor,constant: padding),
            showNamelabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: padding),
            showNamelabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -padding),
            showNamelabel.heightAnchor.constraint(equalToConstant: 28),
            
            overviewlabel.topAnchor.constraint(equalTo: showNamelabel.bottomAnchor, constant: padding),
            overviewlabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            overviewlabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            overviewlabel.heightAnchor.constraint(lessThanOrEqualToConstant: 300),
            
            downloadButton.topAnchor.constraint(equalTo: overviewlabel.bottomAnchor, constant: padding),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: 150),
            downloadButton.heightAnchor.constraint(equalToConstant: 38)
            
        ])
    }
    
    public func configure(with model: ShowPreviewViewModel ){
        showNamelabel.text = model.showName
        overviewlabel.text = model.showPreview
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeElement.id.videoId)")else{return}
        webView.load(URLRequest(url: url))
    }



}
