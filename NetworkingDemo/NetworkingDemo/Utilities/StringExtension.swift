//
//  StringExtension.swift
//  NetworkingDemo
//
//  Created by Ishtiak Ahmed on 04.04.20.
//  Copyright © 2020 Ishtiak Ahmed. All rights reserved.
//

import Foundation

extension String {
    func appendPath(_ path: String) -> String {
        var trimmedPath = path.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedPath.first == "/"  { trimmedPath.removeFirst() }
        if trimmedPath.last == "/"  { trimmedPath.removeLast() }
        return self + "/" + trimmedPath
    }
}
