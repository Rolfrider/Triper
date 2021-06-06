//
//  Fetcher.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 05/06/2021.
//

import Foundation
import Combine
import UIKit

private let baseUrlString = "http://triper-server.herokuapp.com"

let baseUrl = URL(string: baseUrlString)!
let uuid = UIDevice.current.identifierForVendor!.uuidString

func fetchTrips() -> AnyPublisher<[ApiType.TripPreview], Error> {
	let url = baseUrl.appendingPathComponent("trips")
	var request = URLRequest(url: url)
	request.httpMethod = "GET"
	return fetch(with: request, for: [ApiType.TripPreview].self)
}

func fetchMyTrips() -> AnyPublisher<[ApiType.TripPreview], Error> {
	let url = baseUrl.appendingPathComponent("trips").appending([.init(name: "deviceUuid", value: uuid)])!
	var request = URLRequest(url: url)
	request.httpMethod = "GET"
	return fetch(with: request, for: [ApiType.TripPreview].self)
}

func fetchTrip(id: String) -> AnyPublisher<ApiType.Trip, Error> {
	let url = baseUrl.appendingPathComponent("trips").appendingPathComponent(id)
	var request = URLRequest(url: url)
	request.httpMethod = "GET"
	return fetch(with: request, for: ApiType.Trip.self)
}

func postTrip(trip: Trip) -> AnyPublisher<Void, Error> {
	let url = baseUrl.appendingPathComponent("trips")
	var request = URLRequest(url: url)
	request.httpMethod = "POST"
	request.addValue("application/json", forHTTPHeaderField: "Content-Type")
	let apiTrip = ApiType.NewTrip(deviceUuid: uuid, trip: trip)
	return Just(JSONEncoder())
		.tryMap { try $0.encode(apiTrip) }
		.flatMap { data -> AnyPublisher<Void, Error> in
			request.httpBody = data
			return URLSession
				.shared
				.dataTaskPublisher(for: request)
				.tryMap { element -> Data in
					guard let httpResponse = element.response as? HTTPURLResponse,
						  httpResponse.statusCode == 200 else {
						throw URLError(.badServerResponse)
					}
					return element.data
				}
				.map { _ in () }
				.eraseToAnyPublisher()
		}
		.eraseToAnyPublisher()
		
}

private func fetch<T: Codable>(with request: URLRequest, for type: T.Type) -> AnyPublisher<T, Error> {
	URLSession
		.shared
		.dataTaskPublisher(for: request)
		.tryMap { element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse,
				  httpResponse.statusCode == 200 else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}
		.decode(type: type, decoder: JSONDecoder())
		.eraseToAnyPublisher()
}


extension URL {
	/// Returns a new URL by adding the query items, or nil if the URL doesn't support it.
	/// URL must conform to RFC 3986.
	func appending(_ queryItems: [URLQueryItem]) -> URL? {
		guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
			// URL is not conforming to RFC 3986 (maybe it is only conforming to RFC 1808, RFC 1738, and RFC 2732)
			return nil
		}
		// append the query items to the existing ones
		urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
		
		// return the url from new url components
		return urlComponents.url
	}
}
