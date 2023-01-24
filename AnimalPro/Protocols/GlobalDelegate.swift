//
//  GlobalDelegate.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 23/01/23.
//

import Foundation

protocol GlobalDelegate {
    func onError(_ error: String)
    func onSuccess(_ message: String)
}
