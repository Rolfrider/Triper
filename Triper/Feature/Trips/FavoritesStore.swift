//
//  FavoritesStore.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 06/06/2021.
//

import Foundation
import UIKit

private let key = "Liked-Trips"

func saveToUserDefaults(ids: [String]) {
	UserDefaults.standard.set(ids, forKey: key)
}

func getFromUserDefaults() -> [String] {
	UserDefaults.standard.stringArray(forKey: key) ?? []
}
