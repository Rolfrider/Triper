//
//  PlaceSelectionReducer.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 03/04/2021.
//

import Foundation
import ComposableArchitecture
import ComposableNavigator

struct PlaceSelectionEnvironment {
	let navigator: Navigator
}

let placeSelectionReducer = Reducer<Place, PlaceSelectionAction, PlaceSelectionEnvironment> { state, action, env  in
	switch action {
	case .addPlace(let screenID):
		return .fireAndForget {
			env.navigator.dismiss(id: screenID)
		}
	case .binding:
		print(state)
		return .none
	}
}
.binding(action: /PlaceSelectionAction.binding)
