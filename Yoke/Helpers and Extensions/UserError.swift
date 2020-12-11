//
//  UserError.swift
//  Yoke
//
//  Created by LAURA JELENICH on 12/11/20.
//  Copyright © 2020 LAURA JELENICH. All rights reserved.
//

import Foundation

enum UserError: LocalizedError {
    case fbUserError(Error)
    case unwrapError
    
    var errorDescription: String {
        switch self {
        case .fbUserError(let error):
            return "There was an error: \(error.localizedDescription)"
        case .unwrapError:
            return "Unable to unwrap this user."
        }
    }
}
