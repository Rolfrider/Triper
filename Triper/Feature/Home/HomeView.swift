//
//  HomeView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 17/03/2021.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct HomeView: View {
	let store: Store<HomeState, HomeAction>
	
	var body: some View {
		WithViewStore(store) { viewStore in
			TabView(selection: Binding(
						get: { viewStore.tab },
						set: { viewStore.send(.set($0)) })
			) {
				TripsView()
					.tabItem {
						Image(systemName: "list.bullet")
						Text(Tab.trips.name)
					}
					.tag(Tab.trips)
				NewTripView(store: store.scope(state: \.newTrip, action: HomeAction.newTrip))
					.tabItem {
						Image(systemName: "map")
						Text(Tab.newTrip.name)
					}
					.tag(Tab.newTrip)
				MyTripsView()
					.tabItem {
						Image(systemName: "heart")
						Text(Tab.myTrips.name)
					}
					.tag(Tab.myTrips)
			}
			.navigationTitle(viewStore.tab.name)
		}
		
	}
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
