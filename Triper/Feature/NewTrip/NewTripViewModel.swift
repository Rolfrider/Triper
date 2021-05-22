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
	
	func planTrip() {
		
	}
	
	func addPlace(place: Place) {
		places.append(place)
		if places.count == 1 {
			startPlaceId = place.id
		}
	}
}
