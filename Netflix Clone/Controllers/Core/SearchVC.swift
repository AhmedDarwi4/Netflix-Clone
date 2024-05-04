//
//  SearchVC.swift
//  Netflix Clone
//
//  Created by Ahmed Darwish on 13/04/2024.
//

import UIKit

class SearchVC: UIViewController {
    
    private var shows:[Show] = []
    
    let discoverTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ShowTableViewCell.self, forCellReuseIdentifier: ShowTableViewCell.cellIdentifier)
        return tableView
    }()
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsVC())
        searchController.searchBar.placeholder = "Search for a Movie or a TV"
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
        configureSearchController()
        
    }
    
    func configureVC(){
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        getDiscoverMovies()
    }
    
    func configureTableView(){
        view.addSubview(discoverTableView)
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
    }
    
    func configureSearchController(){
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTableView.frame = view.bounds
    }
    
    func getDiscoverMovies(){
        NetworkManager.shared.getDiscoverMovies { [weak self] result in
            guard let self = self else{return}
            switch result{
            case.success(let results):
                self.shows = results.results
                DispatchQueue.main.async {
                    self.discoverTableView.reloadData()
                }
            case.failure(let failure):
            self.presentAlertOnMainThread(title: "Something Went Wrong!", message: failure.rawValue)
            }
        }
    }
    
}

extension SearchVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShowTableViewCell.cellIdentifier) as? ShowTableViewCell else{
            return UITableViewCell()
        }
        let show  = shows[indexPath.row]
        cell.set(with: ShowViewModel(showName: show.originalTitle ?? show.originalName ?? "", posterUrl: show.posterPath ?? "No Image"))
        cell.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.8, animations: {
                    cell.transform = CGAffineTransform(scaleX: 1, y:1)
                })
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
          let show = shows[indexPath.row]
        guard let showName = show.originalTitle ?? show.originalName else{return}
        
        NetworkManager.shared.getMovie(query: showName) {[weak self] result in
            guard let self = self else{return}
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = ShowPreviewVC()
                    vc.configure(with: ShowPreviewViewModel(showName: showName, showPreview: show.overview ?? "", youtubeElement: videoElement))
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let failure):
            self.presentAlertOnMainThread(title: "Something Went Wrong!", message: failure.rawValue)
            }
        }
                
    }
    
}


extension SearchVC:UISearchResultsUpdating,SearchResultsVCDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let filter = searchController.searchBar.text,!filter.trimmingCharacters(in: .whitespaces).isEmpty,
              filter.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsVC else{return}
        resultsController.delegate = self
        NetworkManager.shared.search(with: filter) { result in
            switch result{
            case.success(let result):
                resultsController.shows = result.results
                DispatchQueue.main.async {
                    resultsController.searchResultsCollectionView.reloadData()
                }
            case.failure(let failure):
            self.presentAlertOnMainThread(title: "Something Went Wrong!", message: failure.rawValue)
                
            }
        }
    }
    
    func SearchResultsVCDidTapItem(_ viewModel: ShowPreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = ShowPreviewVC()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
