//
//  RepositoriesInteractor.swift
//  Gnoll
//
//  Created by Jovito Royeca on 30/01/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import Sync

class RepositoriesInteractor: RepositoriesInteractorInputProtocol {
    weak var presenter: RepositoriesInteractorOutputProtocol?
    var localDataManager: RepositoriesLocalDataManagerInputProtocol?
    var remoteDataManager: RepositoriesRemoteDataManagerInputProtocol?
    var query: String?
    
    func retrieveRepositories(withQuery query: String) {
        self.query = query
        var entities = [RepositoryEntity]()
        
        do {
            if query.count == 0 {
                presenter?.didRetrieveRepositories(entities)
            } else {
                if let repositories = try localDataManager?.retrieveRepositories(withQuery: query) {
                    for repo in repositories {
                        entities.append(coreData2Entity(repository: repo))
                    }
                    
                    if  entities.isEmpty {
                        remoteDataManager?.retrieveRepositories(withQuery: query)
                    } else {
                        presenter?.didRetrieveRepositories(entities)
                    }
                } else {
                    remoteDataManager?.retrieveRepositories(withQuery: query)
                }
            }
            
        } catch {
            presenter?.didRetrieveRepositories(entities)
        }
    }
    
    func coreData2Entity(repository: Repository) -> RepositoryEntity {

        // RepositoryEntity
        var json = [String: Any]()
        
        json["id"] = repository.id
        json["fork"] = repository.fork
        json["watchers"] = repository.watchers
        json["watchers"] = repository.watchers
        if let x = repository.repositoryDescription {
            json["description"] = x
        }
        if let x = repository.name {
            json["name"] = x
        }
        
        // OwnerEntity
        if let owner = repository.owner {
            var json2 = [String: Any]()
            
            json2["id"] = owner.id
            if let x = owner.login {
                json2["login"] = x
            }
            if let x = owner.avatarUrl {
                json2["avatarUrl"] = x
            }
            
            json["owner"] = json2//OwnerEntity(JSON: json2)
        }
        
        let entity = RepositoryEntity(JSON: json)!
        return entity
//        return RepositoryEntity(JSON: json)!
    }
}

extension RepositoriesInteractor: RepositoriesRemoteDataManagerOutputProtocol {
    func onRepositoriesRetrieved(_ json: [String: Any]) {
        localDataManager?.saveRepositoryQuery(json: json)
        
        if let query = query {
            var entities = [RepositoryEntity]()
            
            do {
                if let repositories = try localDataManager?.retrieveRepositories(withQuery: query) {
                    for repo in repositories {
                        entities.append(coreData2Entity(repository: repo))
                    }
                    
                    presenter?.didRetrieveRepositories(entities)
                }
                
            } catch {
                presenter?.didRetrieveRepositories(entities)
            }
        }
    }
    
    func onError(_ error: Error) {
        presenter?.onError(error)
    }
    
}
