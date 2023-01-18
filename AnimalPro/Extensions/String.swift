//
//  String.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 17/01/23.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
