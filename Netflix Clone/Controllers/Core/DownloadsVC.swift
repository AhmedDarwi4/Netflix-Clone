//
//  DownloadsVC.swift
//  Netflix Clone
//
//  Created by Ahmed Darwish on 13/04/2024.
//

import UIKit

class DownloadsVC: UIViewController {
    
    var shows:[ShowItem] = []
    
    let downloadsTableView:UITableView = {
        let tableView = UITableView()
        tableView.register(ShowTableViewCell.self, forCellReuseIdentifier: ShowTableViewCell.cellIdentifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLocalStorageForDownload()
    }
    
    func configureVC(){
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadsTableView.frame = view.bounds
    }
    
   func configureTableView(){
       view.addSubview(downloadsTableView)
       downloadsTableView.delegate = self
       downloadsTableView.dataSource = self
    }
    
    private func fetchLocalStorageForDownload(){
        PersistenceManager.shared.fetchingShowsFromDataBase { [weak self] result in
            guard let self = self else{return}
            switch result {
            case .success(let shows):
                self.shows = shows
                DispatchQueue.main.async {
                    self.downloadsTableView.reloadData()
                }
            case .failure(let failure):
            self.presentAlertOnMainThread(title: "Something Went Wrong!", message: failure.rawValue)
            }
        }
    }
    

}

extension DownloadsVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shows.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShowTableViewCell.cellIdentifier, for: indexPath) as? ShowTableViewCell else{
            return UITableViewCell()
        }
        
        let show = shows[indexPath.row]
        cell.set(with: ShowViewModel(showName: show.originalTitle ?? show.originalName ?? "", posterUrl: show.posterPath ?? ""))
        
        cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: 0)
             UIView.animate(withDuration: 2, delay: 0.06*Double(indexPath.row), usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
                 cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
             })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            
        case .delete:
            PersistenceManager.shared.deleteShow(model: shows[indexPath.row]) {[weak self] result in
                guard let self = self else{return}
                switch result{
                case.success():
                    print("deleted from database")
                case.failure(let failure):
                self.presentAlertOnMainThread(title: "Something Went Wrong!", message: failure.rawValue)
                }
                shows.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
               

            }
        default:
            break
        }
        
        
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
