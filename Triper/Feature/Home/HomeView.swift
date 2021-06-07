//
//  HomeView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 17/03/2021.
//

import Foundation
import SwiftUI

struct HomeView: View {
	
	@State var tab = Tab.newTrip
	
	var body: some View {
		TabView(selection: $tab) {
			TripsView(viewModel: TripsViewModel())
				.tabItem {
					Image(systemName: "list.bullet")
					Text(Tab.trips.name)
				}
				.tag(Tab.trips)
			NewTripView()
				.tabItem {
					Image(systemName: "map")
					Text(Tab.newTrip.name)
				}
				.tag(Tab.newTrip)
			MyTripsView(viewModel: .init())
				.tabItem {
					Image(systemName: "heart")
					Text(Tab.myTrips.name)
				}
				.tag(Tab.myTrips)
		}
		
	}
}

enum Tab {
	case trips
	case newTrip
	case myTrips
}

extension Tab {
	var name: String {
		switch self {
		case .myTrips: return "My Trips"
		case .newTrip: return "New Trip"
		case .trips: return "Trips"
		}
	}
}
