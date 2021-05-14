//
//  HomeScreen.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 26/03/2021.
//

import Foundation
import ComposableNavigator
import ComposableArchitecture
import ComposableNavigatorTCA

struct HomeScreen: Screen {
	let presentationStyle: ScreenPresentationStyle = .push
	
	struct Builder: NavigationTree {
		let appStore: Store<AppState, AppAction>
		
		var homeStore: Store<HomeState, HomeAction> {
			appStore.scope(
				state: \.home,
				action: AppAction.home
			)
		}
		
		var newTripTabStore: Store<NewTripState, NewTripAction> {
			homeStore.scope(
				state: \.newTrip,
				action: HomeAction.newTrip
			)
		}
		
		func placeSelectionStore(for placeId: UUID) -> Store<Place?, PlaceSelectionAction> {
			newTripTabStore.scope(
				state: {
					if let place = $0.places[id: placeId] {
						return place
					} else {
						return nil
					}
				},
				action: { NewTripAction.placeSelection(id: placeId, action: $0) }
			)
		}
		
		var builder: some PathBuilder {
			Screen(
				HomeScreen.self,
				onAppear: { _ in print("Home appeared") },
				content: { HomeView(store: homeStore) },
				nesting: {
					If { (screen: PlaceSelectionScreen) in
						IfLetStore(
							store: placeSelectionStore(for: screen.placeId),
							then: { store in
								PlaceSelectionScreen.Builder(store: store)
									.onDismiss { (screen: PlaceSelectionScreen) in
										print("Dismissed \(screen)")
										let viewStore = ViewStore(newTripTabStore)
										if viewStore.places[id: screen.placeId] != nil {
											if let placeId = viewStore.placeToDiscardId {
												ViewStore(newTripTabStore).send(NewTripAction.removePlace(placeId))
											}
										}
									}
							}
							
						)
					}
				}
			)
		}
	}
}
