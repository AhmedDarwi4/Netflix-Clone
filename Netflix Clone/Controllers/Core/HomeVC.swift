//
//  HomeVC.swift
//  Netflix Clone
//
//  Created by Ahmed Darwish on 13/04/2024.
//

import UIKit

enum Sections: Int {
    case TrendingMovies  = 0
    case TrendingTVs     = 1
    case Popular         = 2
    case Upcoming        = 3
    case TopRated        = 4
}

class HomeVC: UIViewController {
    
    var shows: [Show] = []
    var movie: Show!
    private var randomTrendingMovie:Show?
    private var headerView:HeroHeaderView?
  
    let homeFeedTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.cellIdentifier)
        return tableView
    }()
    
    let sectionTitles = ["Trending Movies","Trending TV","Popular","Upcoming Movies","Top Rated"]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        view.addSubviews(homeFeedTableView)
        configureTableView()
        getRandomMovie()
    }
    

    
    func configureVC(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        var image = Constants.Images.netflixLogo
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        let rightbutton1 = UIBarButtonItem(image: Constants.SFSynmols.profile, style: .done, target:self, action: nil)
        let rightbutton2 = UIBarButtonItem(image:Constants.SFSynmols.upcomingRectangle , style: .done, target:self, action: nil)
        navigationItem.rightBarButtonItems = [rightbutton1,rightbutton2]
    }
    
    func getRandomMovie(){
        NetworkManager.shared.getTrendingMovies {[weak self] result in
            guard let self = self else{return}
            switch result {
            case .success(let result):
                let selectedMovie = result.results.randomElement()
                self.randomTrendingMovie = selectedMovie
                headerView?.configure(with: ShowViewModel(showName: selectedMovie?.originalTitle ?? "", posterUrl: selectedMovie?.posterPath ?? ""))
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    
    func configureTableView(){
        homeFeedTableView.delegate = self
        homeFeedTableView.dataSource = self
        headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTableView.tableHeaderView = headerView
    }
    
    override func viewDidLayoutSubviews() {
        homeFeedTableView.frame = view.bounds
    }
    
    
   

}

extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.cellIdentifier, for:indexPath) as? HomeTableViewCell else{
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.parentVC = self
     
        switch indexPath.section{
        case Sections.TrendingMovies.rawValue:
            NetworkManager.shared.getTrendingMovies { result in
                
                switch result {
                case.success(let result):
                    cell.configure(with: result.results)
                case.failure(let failure):
                    self.presentAlertOnMainThread(title: "Something Went Wrong!", message: failure.rawValue)
                }
            }
        case Sections.TrendingTVs.rawValue:
            NetworkManager.shared.getTrendingTVs { result in
               
                switch result {
                case.success(let result):
                    cell.configure(with: result.results)
                case.failure(let failure):
                    self.presentAlertOnMainThread(title: "Something Went Wrong!", message: failure.rawValue)
                }
            }
        case Sections.Popular.rawValue:
            NetworkManager.shared.getPopular { result in
                
                switch result {
                case.success(let result):
                    cell.configure(with: result.results)
                case.failure(let failure):
                    self.presentAlertOnMainThread(title: "Something Went Wrong!", message: failure.rawValue)
                }
            }
        case Sections.Upcoming.rawValue:
            NetworkManager.shared.getUpcoming { result in
                
                switch result {
                case.success(let result):
                    cell.configure(with: result.results)
                case.failure(let failure):
                    self.presentAlertOnMainThread(title: "Something Went Wrong!", message: failure.rawValue)
                }
            }

        case Sections.TopRated.rawValue:
            NetworkManager.shared.getTopRated { result in
               
                switch result {
                case.success(let result):
                    cell.configure(with: result.results)
                case.failure(let failure):
                    self.presentAlertOnMainThread(title: "Something Went Wrong!", message: failure.rawValue)
                }
            }
        default:
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else{return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      
        return sectionTitles[section]
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
}

extension HomeVC:ShowCollectionViewCellDelegate{
     
    
    
    func ShowCollectionViewCellTapped(_ cell: HomeTableViewCell, viewModel: ShowPreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else{return}
            let vc = ShowPreviewVC()
            vc.configure(with: viewModel)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
