//
//  UserDataHelperCoreData.swift
//  tmdbAPI
//
//  Created by João Jacó Santos Abreu on 21/02/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import UIKit
import CoreData

protocol UserDataHelperCoreDataProtocol {
    func saveData(libraryMovie: LibraryScreenModel)
    func deleteData(movieID: Int)
    func isSaved(movieId: Int) -> Bool
}

protocol UserDataHelperCoreDataRetrieveDataProtocol {
    func retrieveData() -> [LibraryScreenModel]
}

class UserDataHelperCoreData: UserDataHelperCoreDataProtocol & UserDataHelperCoreDataRetrieveDataProtocol{
    
    func saveData(libraryMovie: LibraryScreenModel) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let movieEntity = NSEntityDescription.entity(forEntityName: "FavoriteMovies", in: managedContext)!
        
        let movie = NSManagedObject(entity: movieEntity, insertInto: managedContext)
        
        movie.setValue(libraryMovie.movieID, forKey: "id")
        movie.setValue(libraryMovie.posterPath, forKey: "posterPath")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func retrieveData() -> [LibraryScreenModel]{
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return []}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteMovies")
        
        var movieArray: [LibraryScreenModel] = []
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let movie = LibraryScreenModel(movieID: data.value(forKey: "id") as! Int, posterPath: data.value(forKey: "posterPath") as! String)
                movieArray.insert(movie, at: 0)            }
            return movieArray
        } catch {
            print("Failed")
            return []
        }
    }
    
    func deleteData(movieID: Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteMovies")
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(movieID))
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            
            if test.count == 0 { return }
            
            guard let objectToDelete = test[0] as? NSManagedObject else { return }
            managedContext.delete(objectToDelete)
            
            do {
                try managedContext.save()
            }
            catch {
                print(error)
            }
        }
        catch {
            print(error)
        }
        
    }
    
    func isSaved(movieId: Int) -> Bool {
        let result = retrieveData()
        return result.contains {
            $0.movieID == movieId
        }
    }
    
}
    

