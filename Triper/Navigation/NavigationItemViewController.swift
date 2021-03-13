//
//  NavigationItemViewController.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 13/03/2021.
//

import Foundation
import SwiftUI

import ComposableArchitecture
typealias NavigationStore = Store<NavigationState, NavigationAction>
typealias NavigationState = [NavigationItem]
typealias NavigationItemViewFactory = (NavigationStore, NavigationItem) -> AnyView

final class NavigationItemViewController: UIHostingController<AnyView> {
	let store: NavigationStore
	var item: NavigationItem {
		didSet {
			rootView = viewFactory(store, item)
			title = nil
		}
	}
	
	let viewFactory: NavigationItemViewFactory
	
	init(store: NavigationStore, item: NavigationItem, viewFactory: @escaping NavigationItemViewFactory) {
		self.store = store
		self.viewFactory = viewFactory
		self.item = item
		super.init(rootView: viewFactory(store, item))
	}
	
	@objc required dynamic init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
