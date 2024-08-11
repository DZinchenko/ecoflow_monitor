//
//  StringExtensions.swift
//  ecoflow_monitor
//
//  Created by Zinchenko Danulo on 10.08.2024.
//

import Foundation

extension String {
    init(fromKey: String) {
        self.init(stringLiteral: NSLocalizedString(fromKey,value: "KEY NOT FOUND", comment: ""))
    }
}
