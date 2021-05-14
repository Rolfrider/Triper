//
//  NewTripState.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 03/04/2021.
//

import Foundation
import ComposableArchitecture

struct NewTripState: Equatable {
	var startPlaceId: UUID?
	var places: IdentifiedArrayOf<Place> = []
	var selectedId: UUID?
	var placeToDiscardId: UUID?
}
