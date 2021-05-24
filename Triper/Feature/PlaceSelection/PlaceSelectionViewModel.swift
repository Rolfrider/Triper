//
//  PlaceSelectionViewModel.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 22/05/2021.
//

import Foundation
import SwiftUI
import MapKit
import Combine
import CoreLocation

class PlaceSelectionViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
	
	enum PlaceSelectionState {
		case place
		case hideSearch
	}
	
	@Published var name: String
	@Published var isLoading: Bool = false
	var placemark: CLPlacemark? {
		didSet {
			objectWillChange.send()
		}
	}
	@Published var state: PlaceSelectionState {
		didSet {
			if oldValue != state {
				completions = []
			} else {
				state = .hideSearch
			}
		}
	}
	@Published var searchQuery = ""
	@Published var completions: [SearchResult] = []
	
	private let id: UUID = UUID()
	private let completer: MKLocalSearchCompleter
	private let geocoder: CLGeocoder
	private var cancellables: Set<AnyCancellable> = .init()
	private let addPlaceCallback: (Place) -> Void
	
	init(
		addPlaceCallback: @escaping (Place) -> Void,
		name: String = "",
		placemark: CLPlacemark? = nil
	) {
		self.addPlaceCallback = addPlaceCallback
		self.name = name
		self.placemark = placemark
		state = .place
		completer = .init()
		geocoder = .init()
		super.init()
		completer.delegate = self
		completer.region = .init()
		$searchQuery
			.filter { _ in self.state == .place }
			.assign(to: \.queryFragment, on: self.completer)
			.store(in: &cancellables)
	}
	
	func placeTapped() {
		if placemark != nil {
			state = .place
		}
	}
	
	func findCountries(string: String) {
		completions = countries
			.filter { $0.name.lowercased().hasPrefix(string.lowercased()) }
			.map(CountrySearchResult.init(country:))
	}
	
	func savePlace() {
		guard let placemark = placemark else { return }
		let place = Place(name: name, id: id, placemark: placemark)
		addPlaceCallback(place)
	}
	
	func searchResultTapped(result: SearchResult) {
		name = result.title
		self.state = .hideSearch
		self.completions = []
		self.searchQuery = ""
		Just(result as? MKLocalSearchCompletion)
			.compactMap { $0 }
			.map(MKLocalSearch.Request.init(completion:))
			.flatMap { MKLocalSearch(request: $0).start() }
			.replaceError(with: nil)
			.receive(on: DispatchQueue.main)
			.print()
			.handleEvents(receiveCompletion: { _ in DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.isLoading = false
			} }, receiveRequest: { _ in self.isLoading = true })
			.assign(to: \.placemark, on: self)
			.store(in: &cancellables)
	}
	
	func completer(_ completer: MKLocalSearchCompleter, didFailWithError: Error) {
		self.completions = []
	}
	
	func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
		self.completions = completer
			.results
	}
}

protocol SearchResult {
	var title: String { get }
	var subtitle: String { get }
}

extension MKLocalSearchCompletion: SearchResult {}
struct CountrySearchResult: SearchResult {
	let title: String
	let subtitle: String
	let country: Country
	
	init(country: Country) {
		self.country = country
		self.title = country.name
		self.subtitle = [country.flagEmoji, country.isoCountryCode]
			.compactMap { $0 }
			.joined(separator: " ")
	}
}

extension CLGeocoder {
	func geocodeAddressString(addressString: String) -> AnyPublisher<CLPlacemark?, Error> {
		Deferred {
			Future { promise in
				self.geocodeAddressString(addressString) { placeMarks, error in
					if let error = error {
						promise(.failure(error))
					} else {
						promise(.success(placeMarks?.first))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
}

extension MKLocalSearch {
	func start() -> AnyPublisher<CLPlacemark?, Error> {
		Deferred {
			Future { promise in
				self.start { response, error in
					if let error = error {
						promise(.failure(error))
					} else {
						promise(.success(response?.mapItems.first?.placemark))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
}
