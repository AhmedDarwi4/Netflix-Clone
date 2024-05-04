//
//  PersistenceManager.swift
//  Netflix Clone
//
//  Created by Ahmed Darwish on 03/05/2024.
//

import UIKit
import CoreData

class PersistenceManager{
    static let shared = PersistenceManager()
    
    func downloadShow(model: Show, completion:@escaping(Result<Void,NFError>)->Void){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context           = appDelegate.persistentContainer.viewContext
        
        let item           = ShowItem(context: context)
        item.originalTitle = model.originalTitle
        item.originalName  = model.originalName
        item.id            = Int64(model.id)
        item.overview      = model.overview
        item.mediaType     = model.mediaType
        item.posterPath    = model.posterPath
        item.releaseDate   = model.releaseDate
        item.voteCount     = Int64(model.voteCount)
        item.voteAverage   = model.voteAverage
        item.adult         = model.adult
        
        do{
            try context.save()
            completion(.success(()))
        } catch{
            completion(.failure(.databaseSavingError))
            print(error.localizedDescription)
        }
        
    }
    
    func fetchingShowsFromDataBase(completion: @escaping(Result<[ShowItem],NFError>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context           = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<ShowItem>
        request = ShowItem.fetchRequest()
        
        do{
            let shows = try context.fetch(request)
            completion(.success(shows))
        } catch{
            completion(.failure(.databaseFetchingError))
            print(error.localizedDescription)
        }
        
    }
    
    func deleteShow(model:ShowItem, completion:@escaping(Result<Void,NFError>)->Void){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context           = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(.databaseDeletingError))
        }
        
    }
    
    
}
