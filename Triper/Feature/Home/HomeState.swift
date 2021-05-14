//
//  HomeState.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 26/03/2021.
//

import Foundation

struct HomeState: Equatable {
	let tabs = Tab.allCases
	var tab: Tab = .newTrip
	var newTrip: NewTripState = .init()
}

enum Tab: CaseIterable {
	case trips
	case newTrip
	case myTrips
}
