//
//  RepositoriesProtocols.swift
//  Gnoll
//
//  Created by Jovito Royeca on 30/01/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit

// MARK: View
protocol RepositoriesViewProtocol: class {
    var presenter: RepositoriesPresenterProtocol? { get set }
    
    // PRESENTER -> VIEW
    func showRepositories(with repositories: [RepositoryEntity])
    func showError(_ error: Error)
    func showLoading()
    func hideLoading()
}

// MARK: Interactor
protocol RepositoriesInteractorInputProtocol: class {
    var presenter: RepositoriesInteractorOutputProtocol? { get set }
    var localDataManager: RepositoriesLocalDataManagerInputProtocol? { get set }
    var remoteDataManager: RepositoriesRemoteDataManagerInputProtocol? { get set }
    
    // PRESENTER -> INTERACTOR
    func retrieveRepositories(withQuery query: String)
}

protocol RepositoriesInteractorOutputProtocol: class {
    // INTERACTOR -> PRESENTER
    func didRetrieveRepositories(_ repositories: [RepositoryEntity])
    func onError(_ error: Error)
}

// MARK: Presenter
protocol RepositoriesPresenterProtocol: class {
    var view: RepositoriesViewProtocol? { get set }
    var interactor: RepositoriesInteractorInputProtocol? { get set }
    var router: RepositoriesRouterProtocol? { get set }
    
    // VIEW -> PRESENTER
    func viewDidLoad()
    func showRepositoryDetails(forRepository repository: RepositoryEntity)
}

// MARK: Router
protocol RepositoriesRouterProtocol: class {
    static func initRepositoriesModule(withView view: RepositoriesViewController)
    // PRESENTER -> WIREFRAME
    func presentRepositoryDetailsScreen(from view: RepositoriesViewProtocol, forRepository repository: RepositoryEntity)
}

// MARK: Helpers
protocol RepositoriesRemoteDataManagerInputProtocol: class {
    var remoteRequestHandler: RepositoriesRemoteDataManagerOutputProtocol? { get set }
    
    // INTERACTOR -> REMOTEDATAMANAGER
    func retrieveRepositories(withQuery query: String)
}

protocol RepositoriesRemoteDataManagerOutputProtocol: class {
    // REMOTEDATAMANAGER -> INTERACTOR
    func onRepositoriesRetrieved(_ json: [String: Any])
    func onError(_ error: Error)
}

protocol RepositoriesLocalDataManagerInputProtocol: class {
    // INTERACTOR -> LOCALDATAMANAGER
    func retrieveRepositories(withQuery query: String) throws -> [Repository]
    func saveRepositoryQuery(json: [String: Any])
}
