//
//  DataDI.swift
//  data
//
//  Created by Karim Karimov on 28.02.21.
//

import Foundation
import Swinject
import domain
import Alamofire
import RealmSwift

public class DataAssembly: Assembly {
    
    private let baseUrl: String
    
    public init() {
        self.baseUrl = PlistFiles.baseApiUrl
    }
    
    public func assemble(container: Container) {
        
        // MARK: - Interceptors
        
        container.register(BaseInterceptor.self) { r in
            BaseInterceptor()
        }
        
        // MARK: - Helpers
        
        container.register(AsyncNetworkClientProtocol.self) { r in
            AsyncNetworkClient(
                baseUrl: self.baseUrl,
                requestAdapter: [
                    r.resolve(BaseInterceptor.self)!,
                ],
                requestRetriers: [],
                logger: r.resolve(Logger.self)!,
                networkLogger: r.resolve(NetworkLogger.self)!
            )
        }
        
        container.register(Logger.self) { r in
            Logger(handlers: [r.resolve(ConsoleLogHandler.self)!])
        }
        
        container.register(ConsoleLogHandler.self) { r in
            ConsoleLogHandler()
        }
        
        container.register(NetworkLogger.self) { r in
            NetworkLogger(logger: r.resolve(Logger.self)!)
        }
        
        // MARK: - Data sources

        container.register(RealmClientProtocol.self) { r in
            runBlocking { await RealmClient() }
        }.inObjectScope(.container)

        container.register(LocalDataStorage.self) { r in
            LocalDataStorage(logger: r.resolve(Logger.self)!)
        }.inObjectScope(.container)
        
        container.register(CustomerLocalDataSourceProtocol.self) { r in
            CustomerLocalDataSource(localData: r.resolve(LocalDataStorage.self)!)
        }.inObjectScope(.container)
        
        container.register(CardLocalDataSourceProtocol.self) { r in
            CardLocalDataSource(
                realmClient: r.resolve(RealmClientProtocol.self)!
            )
        }.inObjectScope(.container)
        
        container.register(TransactionLocalDataSourceProtocol.self) { r in
            TransactionLocalDataSource(
                realmClient: r.resolve(RealmClientProtocol.self)!
            )
        }.inObjectScope(.container)
        
        container.register(CustomerRemoteDataSourceProtocol.self) { r in
            CustomerRemoteDataSource(networkClient: r.resolve(AsyncNetworkClientProtocol.self)!)
        }
        
        container.register(CardRemoteDataSourceProtocol.self) { r in
            CardRemoteDataSource(networkClient: r.resolve(AsyncNetworkClientProtocol.self)!)
        }
        
        container.register(TransactionRemoteDataSourceProtocol.self) { r in
            TransactionRemoteDataSource(networkClient: r.resolve(AsyncNetworkClientProtocol.self)!)
        }
        
        // MARK: - Repository
        
        container.register(CustomerRepoProtocol.self) { r in
            CustomerRepo(
                localDataSource: r.resolve(CustomerLocalDataSourceProtocol.self)!,
                remoteDataSource: r.resolve(CustomerRemoteDataSourceProtocol.self)!
            )
        }
        
        container.register(CardRepoProtocol.self) { r in
            CardRepo(
                localDataSource: r.resolve(CardLocalDataSourceProtocol.self)!,
                remoteDataSource: r.resolve(CardRemoteDataSourceProtocol.self)!,
                customerLocalDataSource: r.resolve(CustomerLocalDataSourceProtocol.self)!
            )
        }
        
        container.register(TransactionRepoProtocol.self) { r in
            TransactionRepo(
                localDataSource: r.resolve(TransactionLocalDataSourceProtocol.self)!,
                remoteDataSource: r.resolve(TransactionRemoteDataSourceProtocol.self)!,
                customerLocalDataSource: r.resolve(CustomerLocalDataSourceProtocol.self)!
            )
        }
    }
}

