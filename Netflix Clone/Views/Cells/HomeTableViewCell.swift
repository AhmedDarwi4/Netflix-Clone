//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Ahmed Darwish on 15/04/2024.
//

import UIKit

protocol ShowCollectionViewCellDelegate: AnyObject{
    func ShowCollectionViewCellTapped(_ cell:HomeTableViewCell,viewModel:ShowPreviewViewModel)
    
}

class HomeTableViewCell: UITableViewCell {

    static let cellIdentifier = String(describing: HomeTableViewCell.self)
    
    private var shows:[Show] = []
    weak var delegate: ShowCollectionViewCellDelegate?
    weak var parentVC: HomeVC?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: ShowCollectionViewCell.cellIdentifier)
        return collectionView
    }()
    
   private func configureCollectionView(){
       contentView.backgroundColor = .systemCyan
       contentView.addSubview(collectionView)
       collectionView.delegate = self
       collectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with shows:[Show]){
        self.shows = shows
        DispatchQueue.main.async { [weak self]in
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadShowAt(indexPath:IndexPath){
        PersistenceManager.shared.downloadShow(model: shows[indexPath.row]) { result in
            switch result {
                
            case .success(_):
              
                DispatchQueue.main.async {
                    // Check if parentViewController is not nil
                    guard let parentVC = self.parentVC else {
                        print("Parent view controller is nil")
                        return
                    }
                    parentVC.presentAlertOnMainThread(title: "Hooray🎉", message: "The show added successfully to downloads.")
                }

            case .failure(let failure):
                print(String(describing:failure))
            }
        }

    }
    
    
    
}

extension HomeTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:ShowCollectionViewCell.cellIdentifier, for: indexPath)as? ShowCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        let show = shows[indexPath.row]
        cell.configur(with: show.posterPath ?? "No Image")
    
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated:true)
        let show  = shows[indexPath.row]
        guard let showName = show.originalTitle ?? show.originalName else{return}
     

        NetworkManager.shared.getMovie(query: showName + "trailer") { [weak self] result in
            guard let self = self else{return}
            switch result {
            case .success(let videoElement):
                
                let show = shows[indexPath.row]
                
                guard let showOverview = show.overview else{return}
                
                let viewModel = ShowPreviewViewModel(showName: showName, showPreview: showOverview, youtubeElement: videoElement)
                
                delegate?.ShowCollectionViewCellTapped(self, viewModel: viewModel)
                
            case .failure(let failure):
                
                self.parentVC?.presentAlertOnMainThread(title: "Something Went Wrong!", message: failure.rawValue)
                print(String(describing:failure))
            }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil,
                                                previewProvider: nil) { _  in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) {[weak self] _ in
                self?.downloadShowAt(indexPath: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        
        return config
    }
    
    
}
