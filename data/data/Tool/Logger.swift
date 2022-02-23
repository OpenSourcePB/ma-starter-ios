//
//  Logger.swift
//  data
//
//  Created by Karim Karimov on 01.03.21.
//

import Foundation

protocol LogHandler {
    func log(_ message: String)
}

class Logger {

    private var logHandlers = [LogHandler]()

    init(handlers: [LogHandler]) {
        self.logHandlers.append(contentsOf: handlers)
    }
    
    func log(_ message: String) {
        for logHandler in logHandlers {
            logHandler.log(message)
        }
    }
    
    func logDebug(_ message: String) {
        #if DEBUG
        self.log("DEBUG: \(message)")
        #endif
    }
}
