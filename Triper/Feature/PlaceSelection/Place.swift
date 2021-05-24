//
//  Place.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 03/04/2021.
//

import Foundation
import CoreLocation

struct Place: Equatable, Identifiable, Hashable {
	let name: String
	let id: UUID
	var country: Country
	let placemark: CLPlacemark
}

let countries: [Country] = NSLocale.isoCountryCodes.compactMap {
	let flag = String.emojiFlag(for: $0)
	let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue : $0])
	let s = NSLocale(localeIdentifier: Locale.current.languageCode!)
	if let languageCode = Locale.current.languageCode,
	   let name = NSLocale(localeIdentifier: languageCode).displayName(forKey: NSLocale.Key.identifier, value: id) {
		return Country(isoCountryCode: $0, name: name, flagEmoji: flag)
	} else { return nil }
}

struct Country: Hashable, Identifiable, Equatable {
	let isoCountryCode: String
	let name: String
	let flagEmoji: String?
	var id: String { isoCountryCode }
}

extension String {
	
	static func emojiFlag(for countryCode: String) -> String? {
		func isLowercaseASCIIScalar(_ scalar: Unicode.Scalar) -> Bool {
			return scalar.value >= 0x61 && scalar.value <= 0x7A
		}
		
		func regionalIndicatorSymbol(for scalar: Unicode.Scalar) -> Unicode.Scalar {
			precondition(isLowercaseASCIIScalar(scalar))
			
			// 0x1F1E6 marks the start of the Regional Indicator Symbol range and corresponds to 'A'
			// 0x61 marks the start of the lowercase ASCII alphabet: 'a'
			return Unicode.Scalar(scalar.value + (0x1F1E6 - 0x61))!
		}
		
		let lowercasedCode = countryCode.lowercased()
		guard lowercasedCode.count == 2 else { return nil }
		guard lowercasedCode.unicodeScalars.reduce(true, { accum, scalar in accum && isLowercaseASCIIScalar(scalar) }) else { return nil }
		
		let indicatorSymbols = lowercasedCode.unicodeScalars.map({ regionalIndicatorSymbol(for: $0) })
		return String(indicatorSymbols.map({ Character($0) }))
	}
}
