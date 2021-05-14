//
//  PlaceSelectionScreen.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 03/04/2021.
//

import Foundation
import ComposableNavigator
import ComposableArchitecture

struct PlaceSelectionScreen: Screen {
	let presentationStyle: ScreenPresentationStyle = .sheet(allowsPush: true)
	let placeId: UUID
	
	struct Builder: NavigationTree {
		let store: Store<Place, PlaceSelectionAction>
		
		var builder: some PathBuilder {
			If { (screen: PlaceSelectionScreen) in
				Screen(
					PlaceSelectionScreen.self,
					content: {
						PlaceSelectionView(store: store)
					}
				)
			}
		}
	}
}
