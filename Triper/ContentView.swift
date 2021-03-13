//
//  ContentView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 06/03/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Spacer()
				CompassView()
					.padding()
				Spacer()
			}
			CompassView()
			CompassView()
			CompassView()
				.padding()
			CompassView()
				.padding()

		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
