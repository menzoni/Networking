//
//  NSError+Extensions.swift
//  Networking
//
//  Created by Carlos Henrique Salvador on 17/11/19.
//  Copyright © 2019 Carlos Henrique Salvador. All rights reserved.
//

import Foundation

extension NSError {
    
    convenience init(domain: String, code: Int, description: String) {
        self.init(domain: domain, code: code, userInfo: [(kCFErrorLocalizedDescriptionKey as CFString) as String: description])
    }
    
}

