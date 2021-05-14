//
//  PlaceSelectionView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 03/04/2021.
//

import SwiftUI
import ComposableNavigator
import ComposableArchitecture

struct PlaceSelectionView: View {
	@Environment(\.currentScreenID) var currentScreenID
	let store: Store<Place, PlaceSelectionAction>
	@ObservedObject var locationCompleter = LocationSearchService()
	
    var body: some View {
		WithViewStore(store) { viewStore in
//			NavigationView {
			ScrollView {
				Picker(
					"Country",
					selection: viewStore.binding(keyPath: \.country, send: PlaceSelectionAction.binding)) {
					ForEach(countries, id: \.self) {
						Text("\($0.flagEmoji ?? "") \($0.name)")
					}
				}
				SearchBar(text: $locationCompleter.searchQuery)
				List(locationCompleter.completions) { completion in
					VStack(alignment: .leading) {
						Text(completion.title)
						Text(completion.subtitle)
							.font(.subheadline)
							.foregroundColor(.gray)
					}
				}
			}
			.navigationBarTitle("New Place", displayMode: .inline)
		}
	}
}

//struct PlaceSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
////        PlaceSelectionView()
//    }
//}
