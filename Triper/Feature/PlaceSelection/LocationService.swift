//
//  LocationService.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 13/05/2021.
//

import Foundation
import SwiftUI
import MapKit
import Combine


class LocationSearchService: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
	/*
	By using ObservableObject we're letting know any consummer of the LocationSearchService
	of any updates in searchQuery or completions (i.e. whenever we get results).
	*/
	// Here we store the search query that the user types in the search bar
	@Published var searchQuery = ""
	// Here we store the completions which are the results of the search
	@Published var completions: [MKLocalSearchCompletion] = []
	
	var completer: MKLocalSearchCompleter
	var cancellable: AnyCancellable?
	
	override init() {
		completer = MKLocalSearchCompleter()
		super.init()
		// Here we assign the search query to the MKLocalSearchCompleter
		cancellable = $searchQuery.assign(to: \.queryFragment, on: self.completer)
		completer.delegate = self
//		completer.resultTypes = .pointOfInterest
	}
	
	func completer(_ completer: MKLocalSearchCompleter, didFailWithError: Error) {
		self.completions = []
	}
	
	func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
		self.completions = completer.results

	}
}

extension MKLocalSearchCompletion: Identifiable {}

// Example of LocationSearchService consummer
