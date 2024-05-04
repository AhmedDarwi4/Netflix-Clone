//
//  UpcomingVC.swift
//  Netflix Clone
//
//  Created by Ahmed Darwish on 13/04/2024.
//

import UIKit

class UpcomingVC: UIViewController {
    
    private let upcomingTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ShowTableViewCell.self, forCellReuseIdentifier: ShowTableViewCell.cellIdentifier)
        return tableView
    }()
    
    private var shows:[Show] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureVC()
        configureTableView()
        getUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        upcomingTableView.frame = view.bounds
    }
    

    func configureVC(){
        title = "Upcoming"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView(){
        view.addSubview(upcomingTableView)
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
    }
    
    func getUpcoming(){
        NetworkManager.shared.getUpcoming {[weak self] result in
            guard let self = self else{return}
            switch result {
            case.success(let results):
                self.shows = results.results
                DispatchQueue.main.async {
                    self.upcomingTableView.reloadData()
                }
            case.failure(let failure):
                self.presentAlertOnMainThread(title: "Something Went Wrong!", message: failure.rawValue)
            }
        }
    }
    
    
    
}

extension UpcomingVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: ShowTableViewCell.cellIdentifier, for: indexPath) as? ShowTableViewCell else{
            return UITableViewCell()
        }
        let show = shows[indexPath.row]
        cell.set(with: ShowViewModel(showName: show.originalTitle ?? show.originalName ?? "", posterUrl: show.posterPath ?? "No Image"))
        
        cell.transform =  CGAffineTransform(translationX: 0, y:0)

        UIView.animate(withDuration: 0.5, delay: 0.05*Double(indexPath.row), options: .curveLinear) {
            cell.transform =  CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
        }

        cell.selectionStyle = .none
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
