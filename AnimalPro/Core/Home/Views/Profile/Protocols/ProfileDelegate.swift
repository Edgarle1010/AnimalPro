//
//  ProfileDelegate.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 18/01/23.
//

import Foundation

protocol ProfileDelegate {
    func onError(_ error: String)
    func onSuccess(_ message: String)
}
