//
//  NetworkManager.swift
//  Netflix Clone
//
//  Created by Ahmed Darwish on 18/04/2024.
//

import UIKit



class NetworkManager{
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - Getting Trending Movies
    func getTrendingMovies(completion: @escaping(Result<TrendingShowsResponse,NFError>)->Void){
        
        let endPoint = Constants.baseURL + "3/trending/movie/day?api_key=\(Constants.apiKey)"
        guard let url = URL(string: endPoint) else{
            completion(.failure(.invalidUrl))
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error{
                completion(.failure(.internetIssue))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                completion(.failure(.invalidResponse))

                return
            }
            
            guard let data = data else{
                completion(.failure(.invalidData))
                return
            }
                           
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results  = try decoder.decode(TrendingShowsResponse.self, from: data)
                completion(.success(results))
                //print(results)
            }catch{
                completion(.failure(.invalidData))
                print("Error decoding JSON:\(error.localizedDescription)")
            }
        }
        
        task.resume()
        
    }
    
    // MARK: - Getting Trending TVs
    func getTrendingTVs(completion: @escaping(Result<TrendingShowsResponse,NFError>)->Void){
        let endPoint = Constants.baseURL + "3/trending/tv/day?api_key=\(Constants.apiKey)"
        guard let url = URL(string: endPoint)else{
            completion(.failure(.invalidUrl))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error{
                completion(.failure(.internetIssue))
                return
            }
            
            guard let response = response as? HTTPURLResponse,response.statusCode == 200 else{
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else{
                completion(.failure(.invalidData))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let trendingTVs = try decoder.decode(TrendingShowsResponse.self, from: data)
                completion(.success(trendingTVs))
               // print(trendingTVs.results[0].originalName)
            } catch{
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
    // MARK: - Getting Popular
    func getPopular(completion: @escaping(Result<TrendingShowsResponse,NFError>)->Void){
        let endPoint = Constants.baseURL + "3/movie/popular?api_key=\(Constants.apiKey)"
        guard let url = URL(string: endPoint)else{
            completion(.failure(.invalidUrl))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error{
                completion(.failure(.internetIssue))
                return
            }
            
            guard let response = response as? HTTPURLResponse,response.statusCode == 200 else{
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else{
                completion(.failure(.invalidData))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let popular = try decoder.decode(TrendingShowsResponse.self, from: data)
                completion(.success(popular))
               // print(popular.results[0].originalName)
            } catch{
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    // MARK: - Getting Upcoming
    func getUpcoming(completion: @escaping(Result<TrendingShowsResponse,NFError>)->Void){
        let endPoint = Constants.baseURL + "3/movie/upcoming?api_key=\(Constants.apiKey)"
        guard let url = URL(string: endPoint)else{
            completion(.failure(.invalidUrl))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error{
                completion(.failure(.internetIssue))
                return
            }
            
            guard let response = response as? HTTPURLResponse,response.statusCode == 200 else{
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else{
                completion(.failure(.invalidData))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let upcoming = try decoder.decode(TrendingShowsResponse.self, from: data)
                completion(.success(upcoming))
               // print(upcoming.results[0].originalName)
            } catch{
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    // MARK: - Getting Top Rared
    func getTopRated(completion: @escaping(Result<TrendingShowsResponse,NFError>)->Void){
        let endPoint = Constants.baseURL + "3/movie/top_rated?api_key=\(Constants.apiKey)"
        guard let url = URL(string: endPoint)else{
            completion(.failure(.invalidUrl))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error{
                completion(.failure(.internetIssue))
                return
            }
            
            guard let response = response as? HTTPURLResponse,response.statusCode == 200 else{
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else{
                completion(.failure(.invalidData))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let topRated = try decoder.decode(TrendingShowsResponse.self, from: data)
                completion(.success(topRated))
               // print(topRated.results[0].originalName)
            } catch{
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    // MARK: - Getting Discover Movies
    func getDiscoverMovies(completion: @escaping(Result<TrendingShowsResponse,NFError>)->Void){
        let endPoint = Constants.baseURL + "3/discover/movie?api_key=\(Constants.apiKey)"
        guard let url = URL(string: endPoint)else{
            completion(.failure(.invalidUrl))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error{
                completion(.failure(.internetIssue))
                return
            }
            
            guard let response = response as? HTTPURLResponse,response.statusCode == 200 else{
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else{
                completion(.failure(.invalidData))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(TrendingShowsResponse.self, from: data)
                completion(.success(results))
               // print(results.results[0].originalName)
            } catch{
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    // MARK: - Getting Search Results
    func search(with query:String, completion: @escaping(Result<TrendingShowsResponse,NFError>)->Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)else{return}
        let endPoint = Constants.baseURL + "3/search/movie?query=\(query)&api_key=\(Constants.apiKey)"
        
        guard let url = URL(string: endPoint)else{
            completion(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.internetIssue))
                return
            }
            guard let response = response as? HTTPURLResponse,response.statusCode == 200 else{
                completion(.failure(.invalidResponse))
                return
            }
            guard let data = data else{
                completion(.failure(.invalidData))
                return
            }
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(TrendingShowsResponse.self, from: data)
                completion(.success(results))
            }
            catch{
                completion(.failure(.invalidData))
            }
            
        }
        
        task.resume()
    }
    
    func getMovie(query: String, completion: @escaping(Result<VideoElement,NFError>)->Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)else{return}
        let endPoint = Constants.youtubeBaseURl + "q=\(query)&key=\(Constants.youtubeAPIKey)"
        
        guard let url = URL(string: endPoint)else{
            completion(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                
                completion(.failure(.internetIssue))
                return
            }
            guard let response = response as? HTTPURLResponse,response.statusCode == 200 else{
                completion(.failure(.invalidResponse))
                return
            }
            guard let data = data else{
                completion(.failure(.invalidData))
                return
            }
            do{
                let decoder = JSONDecoder()
                let results = try decoder.decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
                //print(results.items[0])
            }
            catch{
                completion(.failure(.invalidData))
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
        
    }
    
    
}


