//
//  HomeReducer.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 26/03/2021.
//

import Foundation
import ComposableArchitecture
import ComposableNavigator

struct HomeEnvironment {
	let navigator: Navigator
	
	var newTrip: NewTripEnvironment { .init(navigator: navigator) }
}

let homeReducer = Reducer<HomeState, HomeAction, HomeEnvironment> { state, action, env in
	switch action {
	case .set(let tab):
		state.tab = tab
		return .none
	case .newTrip: return .none
	}
}
.combined(
	with: newTripReducer.pullback(
		state: \.newTrip,
		action: /HomeAction.newTrip,
		environment: \.newTrip
	)
)
