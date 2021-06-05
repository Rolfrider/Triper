//
//  TripPreviewView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 25/05/2021.
//

import SwiftUI

struct TripPreviewView: View {
    var body: some View {
			ZStack {
				Color(.systemBackground)
				VStack(alignment: .leading, spacing: 0) {
					Text("Trip name")
						.font(.largeTitle)
						.padding(.top)
					Text("Places: 2")
						.font(.largeTitle)
						.bold()
						.foregroundColor(Color(.label))
					VStack(spacing: 0) {
						ScrollView {
							Text("s")
						}
						.padding(.top)
						Spacer()
					}
					Spacer(minLength: 16)
					NavigationLink(
						destination: Text(""),
						isActive: .constant(false)) {
						Button(action: {}) {
							HStack {
								Spacer()
								Text("Show trip plan")
									.font(.headline)
									.foregroundColor(Color(.label))
								Image(systemName: "paperplane")
								Spacer()
							}
							.padding()
							.background(Color(.systemFill))
							.cornerRadius(18)
						}
					}
				}.padding([.horizontal, .bottom])
			}.navigationBarTitle("Trip name")
//			.navigationBarTitleDisplayMode(.inline)
    }
}

struct TripPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        TripPreviewView()
    }
}
