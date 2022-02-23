//
//  ConsoleLogHandler.swift
//  data
//
//  Created by Karim Karimov on 01.03.21.
//

import Foundation

class ConsoleLogHandler: LogHandler {
    
    func log(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
}
