//
//  NewTripViewModel.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 14/05/2021.
//

import Foundation
import SwiftUI

class NewTripViewModel: ObservableObject {
	@Published var places: [Place] = []
	@Published var startPlaceId: UUID?
	@Published var selectedPlace: Place?
	
	func planTrip() {
		
	}
	
	func addPlace(place: Place) {
		places.append(place)
		if places.count == 1 {
			startPlaceId = place.id
			selectedPlace = place
		}
	}
	
	func deletePlace(id: UUID) {
		places.removeAll(where: { $0.id == id })
		selectedPlace = nil
	}
}
