//
//  CompassLoading.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 22/05/2021.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
	public init(_ isVisible: Bool) {
		self.isVisible = isVisible
	}
	
	private let isVisible: Bool
	
	func body(content: Content) -> some View {
		content.overlay(ViewBuilder.buildBlock(
			isVisible ? ViewBuilder.buildEither(first: overlay) :
				ViewBuilder.buildEither(second: overlay.hidden())
		))
	}
	
	private var overlay: some View {
		ZStack(alignment: .center) {
			Color.gray.edgesIgnoringSafeArea(.all)
				.opacity(0.5)
				.disabled(true)
			VStack {
				Spacer()
				CompassView().frame(width: 170, height: 170, alignment: .center)
				Spacer()
			}
		}
		.onTapGesture {}
	}
}

public extension View {
	func loadingOverlay(_ isVisible: Bool) -> some View {
		modifier(LoadingModifier(isVisible))
	}
}
