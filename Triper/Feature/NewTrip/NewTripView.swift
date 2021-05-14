//
//  NewTripView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 26/03/2021.
//

import SwiftUI
import ComposableNavigator
import ComposableArchitecture

struct NewTripView: View {
	let store: Store<NewTripState, NewTripAction>
	
    var body: some View {
		WithViewStore(store) { viewStore in
			ZStack {
				Color(.systemBackground)
				VStack(alignment: .leading, spacing: 0) {
					HStack {
						Text("Places: \(viewStore.state.placesToShow.count)")
							.font(.largeTitle)
							.bold()
							.foregroundColor(Color(.label).opacity(0.6))
						Spacer()
						Button("+") { viewStore.send(.addPlaceTapped) }
							.font(.largeTitle)
					}
					List(viewStore.state.placesToShow, id: \.id) { place in
						HStack {
							Text (place.name)
							Spacer()
							if viewStore.state.startPlaceId == place.id {
								Text("🏁")
							}
						}
					}
					PlacePreviewView()
					Spacer(minLength: 16)
					Button(action: { viewStore.send(.planTrip) }) {
						HStack {
							Spacer()
							Text("Plan my trip")
								.font(.headline)
								.foregroundColor(Color(.label))
							Image(systemName: "paperplane")
							Spacer()
						}
						.padding()
						.background(Color(.systemFill))
						.cornerRadius(18)
					}
				}.padding([.horizontal, .bottom])
			}
		}
    }
}

fileprivate extension NewTripState {
	var placesToShow: [Place] { places.filter { $0.id != placeToDiscardId } }
	
}

//struct NewTripView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewTripView()
//    }
//}

struct PlaceView: View {
	let name: String
	let emoji: String
	
	var body: some View {
		HStack {
			Spacer()
			Group {
				Text(emoji)
				Text(name)
			}
			.font(.caption)
			Spacer()
			
		}
		.padding(.all, 6)
		.background(Color.gray)
		.cornerRadius(18)
	}
}
