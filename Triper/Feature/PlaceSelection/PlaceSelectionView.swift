//
//  PlaceSelectionView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 03/04/2021.
//

import SwiftUI
import CoreLocation

struct PlaceSelectionView: View {
	
	@Environment(\.presentationMode) var presentationMode
	@State var showPlaceholder = true
	@ObservedObject var viewModel: PlaceSelectionViewModel

	var body: some View {
		VStack {
			NavigationView {
				Form {
					Section {
						Button("Place: \(viewModel.name)") {
							withAnimation{ viewModel.placeTapped() }
						}
					}
					if viewModel.state != .hideSearch {
						Section(header: Text("Find place")) {
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
						Section(header: Text("Add additional note")) {
							ZStack {
								if showPlaceholder {
									Text("Note for place")
								}
								TextEditor(text: $viewModel.note)
									.frame(height: 140)
									.onTapGesture {
										showPlaceholder = false
									}
							}
								
						}
					}
					ViewBuilder.buildIf(
						viewModel.state == .hideSearch ?
						AddressSection.init(placemark: viewModel.placemark)
						: nil
					)
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
						.foregroundColor(Color(viewModel.placemark == nil ? .label.withAlphaComponent(0.1) : .label))
					Spacer()
				}
				.padding()
				.background(Color(viewModel.placemark == nil ? .systemFill.withAlphaComponent(0.1) : .systemFill))
				.cornerRadius(12)
				.padding(.horizontal)
			}
			.disabled(viewModel.placemark == nil)
			.padding(.bottom)
		}
		.loadingOverlay(viewModel.isLoading)
	}
}

struct AddressSection: View {
	let placemark: CLPlacemark?
	
	var body: some View {
		Section(header: Text("Address details")) {
			Text("Country: \(placemark?.country ?? .emptyData)")
			Text("Province: \(placemark?.administrativeArea ?? .emptyData)")
			Text("City: \(placemark?.locality ?? .emptyData)")
			Text("Street: \(placemark?.thoroughfare ?? .emptyData)")
			Text("Latitude: \(placemark?.location?.coordinate.latitude ?? 0)")
			Text("Longitude: \(placemark?.location?.coordinate.longitude ?? 0)")
		}
	}

}

private extension String {
	static var emptyData: String { " - " }
}
