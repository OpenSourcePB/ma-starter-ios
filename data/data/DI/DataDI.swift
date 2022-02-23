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
        
        container.register(NetworkClientProvider.self) { r in
            let interceptors: [RequestAdapter] = [
                r.resolve(BaseInterceptor.self)!,
            ]
            
            let retriers: [RequestRetrier] = []
            
            return NetworkClientProvider(baseUrl: self.baseUrl,
                                         requestInterceptors: interceptors,
                                         requestRetriers: retriers,
                                         logger: r.resolve(Logger.self)!,
                                         networkLogger: r.resolve(NetworkLogger.self)!)
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
        
        container.register(Realm.self) { _ in
            Realm.Configuration.defaultConfiguration = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: { migration, oldSchemaVersion in
                    // migration
                },
                deleteRealmIfMigrationNeeded: true
            )
            return try! Realm()
        }.inObjectScope(.container)
        
        container.register(CustomerLocalDataSourceProtocol.self) { r in
            CustomerLocalDataSource(logger: r.resolve(Logger.self)!)
        }.inObjectScope(.container)
        
        container.register(CardLocalDataSourceProtocol.self) { r in
            CardLocalDataSource(
                realm: r.resolve(Realm.self)!,
                logger: r.resolve(Logger.self)!)
        }.inObjectScope(.container)
        
        container.register(TransactionLocalDataSourceProtocol.self) { r in
            TransactionLocalDataSource(
                realm: r.resolve(Realm.self)!, logger: r.resolve(Logger.self)!)
        }
        
        container.register(CustomerRemoteDataSourceProtocol.self) { r in
            CustomerRemoteDataSource(networkClient: r.resolve(NetworkClientProvider.self)!)
        }
        
        container.register(CardRemoteDataSourceProtocol.self) { r in
            CardRemoteDataSource(networkClient: r.resolve(NetworkClientProvider.self)!)
        }
        
        container.register(TransactionRemoteDataSourceProtocol.self) { r in
            TransactionRemoteDataSource(networkClient: r.resolve(NetworkClientProvider.self)!)
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

