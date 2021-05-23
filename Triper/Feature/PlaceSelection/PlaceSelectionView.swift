//
//  PlaceSelectionView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 03/04/2021.
//

import SwiftUI

struct PlaceSelectionView: View {
	
	@Environment(\.presentationMode) var presentationMode
	@State var showAddress = false
	@ObservedObject var viewModel: PlaceSelectionViewModel
	
	var body: some View {
		VStack {
			NavigationView {
				Form {
					Section {
						viewModel.country.map {
							CountryView(country: $0) {
								withAnimation {
									viewModel.state = .country
								}
								print("country tap")
							}
						}
						if viewModel.country != nil {
							Button("Place: \(viewModel.name)") {
								withAnimation {
									viewModel.state = .place
								}
								print("place tap")
							}
						}
					}
					if viewModel.state != .hideSearch {
						Section(header: Text(viewModel.state.name)) {
							SearchBar(text: $viewModel.searchQuery)
							List(viewModel.completions, id: \.title) { completion in
								Button(action: {
									withAnimation { viewModel.searchResultTapped(result: completion) }
								}) {
									VStack(alignment: .leading) {
										Text(completion.title)
										Text(completion.subtitle)
											.font(.subheadline)
											.foregroundColor(.gray)
									}
								}
							}
						}
					}
					if viewModel.state == .hideSearch {
						Section(header: Text("Address details")) {
							let placemark = viewModel.placemark
							placemark?.administrativeArea.map {
								Text("Province: \($0)")
							}
							placemark?.locality.map {
								Text("City: \($0)")
							}
							placemark?.thoroughfare.map {
								Text("Street: \($0)")
							}
							
						}
					}
				}
				.transition(.opacity)
				.navigationBarTitle("New Place")
			}
			Spacer()
			Button(action: {
				viewModel.savePlace()
				presentationMode.wrappedValue.dismiss()
			}) {
				HStack {
					Spacer()
					Text("Add Place ➕")
						.font(.headline)
						.foregroundColor(Color(.label))
					Spacer()
				}
				.padding()
				.background(Color(.systemFill))
				.cornerRadius(12)
				.padding(.horizontal)
			}
			.padding(.bottom)
		}
		.loadingOverlay(viewModel.isLoading)
	}
}

extension PlaceSelectionViewModel.PlaceSelectionState {
	var name: String {
		switch self {
		case .country: return "Select Country"
		case .place: return "Find Place"
		case .hideSearch: return ""
		}
	}
}
struct CountryView: View {
	let country: Country
	let tapCallback: () -> Void
	
	var body: some View {
		Button(action: tapCallback) {
			HStack {
				Text(country.name)
				Spacer()
				country.flagEmoji.map(Text.init)
			}
		}
	}
}
//struct PlaceSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
////        PlaceSelectionView()
//    }
//}
