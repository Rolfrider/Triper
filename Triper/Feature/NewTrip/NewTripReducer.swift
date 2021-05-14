//
//  NewTripReducer.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 03/04/2021.
//

import Foundation
import ComposableArchitecture
import ComposableNavigator

struct NewTripEnvironment {
	let navigator: Navigator
}

let newTripReducer = Reducer<NewTripState, NewTripAction, NewTripEnvironment>
	.combine(
		placeSelectionReducer.forEach(
			state: \.places,
			action: /NewTripAction.placeSelection(id:action:),
			environment: { PlaceSelectionEnvironment(navigator: $0.navigator) }
		),
		Reducer {
			state, action, env in
			switch action {
			case .planTrip:
				print("DO planing")
				return .none
			case .selectPlace(let id):
				state.selectedId = id
				return .none
			case .setStartPlace(let id):
				state.startPlaceId = id
				return .none
			case .placeSelection(let id, .addPlace):
				state.placeToDiscardId = nil
				if state.startPlaceId == nil {
					state.startPlaceId = id
				}
				return .none
			case .addPlaceTapped:
				let place = Place(id: UUID())
				state.places.append(place)
				state.placeToDiscardId = place.id
				return .fireAndForget {
					env.navigator.go(to: PlaceSelectionScreen(placeId: place.id), on: HomeScreen())
				}
			case .removePlace(let id):
				state.places.remove(id: id)
				if state.startPlaceId == id {
					state.startPlaceId = state.places.first?.id
				}
				return .none
			case .placeSelection:
				return .none
			}
		}
	)
