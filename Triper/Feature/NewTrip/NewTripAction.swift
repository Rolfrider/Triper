//
//  NewTripAction.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 03/04/2021.
//

import Foundation
enum NewTripAction: Equatable {
	case setStartPlace(UUID?)
	case removePlace(UUID)
	case addPlaceTapped
	case planTrip
	case selectPlace(id: UUID)
	case placeSelection(id: UUID, action: PlaceSelectionAction)
}
