//
//  SearchResultsVC.swift
//  Netflix Clone
//
//  Created by Ahmed Darwish on 24/04/2024.
//

import UIKit

protocol SearchResultsVCDelegate: AnyObject{
    func SearchResultsVCDidTapItem(_ viewModel: ShowPreviewViewModel)
}

class SearchResultsVC: UIViewController {
    
   public var shows:[Show] = []
    public weak var delegate: SearchResultsVCDelegate?

   public let searchResultsCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3-10, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: ShowCollectionViewCell.cellIdentifier)
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      configureCollectionView()
       
    }
    
  func configureCollectionView(){
      view.addSubview(searchResultsCollectionView)
      searchResultsCollectionView.delegate = self
      searchResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        searchResultsCollectionView.frame = view.bounds
    }



}

extension SearchResultsVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowCollectionViewCell.cellIdentifier, for: indexPath) as? ShowCollectionViewCell else{
            return UICollectionViewCell()
        }
        let show = shows[indexPath.row]
        cell.configur(with: show.posterPath ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let show = shows[indexPath.row]
        let showName = show.originalTitle ?? ""
        NetworkManager.shared.getMovie(query: showName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                self?.delegate?.SearchResultsVCDidTapItem(ShowPreviewViewModel(showName: showName, showPreview: show.overview ?? "", youtubeElement: videoElement))
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
    }
}
