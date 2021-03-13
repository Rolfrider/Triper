//
//  RoutingView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 13/03/2021.
//

import Foundation
import SwiftUI

import ComposableArchitecture
typealias NavigationViewStore = ViewStore<NavigationState, NavigationAction>

struct RoutingView: UIViewControllerRepresentable {
	
	let store: NavigationStore
	let viewFactory: NavigationItemViewFactory
	@ObservedObject private(set) var viewStore: NavigationViewStore
	
	init(store: NavigationStore, viewFactory: @escaping NavigationItemViewFactory) {
		self.store = store
		self.viewFactory = viewFactory
		self.viewStore = NavigationViewStore(store) {
			$0.map(\.navigationID) == $1.map(\.navigationID)
		}
	}
	
	func makeUIViewController(context: Context) -> UINavigationController {
		let navigationController = UINavigationController()
		navigationController.delegate = context.coordinator
		return navigationController
	}
	
	func updateUIViewController(_ navigationController: UINavigationController, context: Context) {
		let navIDs = viewStore.state.map(\.navigationID)
		let presentedViewControllers = navigationController.itemViewControllers
		let presentedNavIDs = presentedViewControllers.map(\.item.navigationID)
		let newViewControllers = viewStore.state.map { item -> NavigationItemViewController in
			let viewController = presentedViewControllers.first(where: { $0.item.navigationID == item.navigationID })
			viewController?.item = item
			return viewController ?? NavigationItemViewController(store: store, item: item, viewFactory: viewFactory)
		}
		guard presentedNavIDs != navIDs else { return }
		let animate = !navigationController.viewControllers.isEmpty
		navigationController.setViewControllers(newViewControllers, animated: animate)
	}
	
	func makeCoordinator() -> NavigationCoordinator {
		NavigationCoordinator(view: self)
	}
	
	final class NavigationCoordinator: NSObject, UINavigationControllerDelegate {
		let view: RoutingView
		
		init(view: RoutingView) {
			self.view = view
			super.init()
		}
		
		func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
			let presentedNavItems = navigationController.itemViewControllers.map(\.item)
			let navIDs = view.viewStore.state.map(\.navigationID)
			guard presentedNavItems.map(\.navigationID) != navIDs else { return }
			view.viewStore.send(.set(presentedNavItems))
		}
	}
}

extension UINavigationController {
	var itemViewControllers: [NavigationItemViewController] {
		get { viewControllers.compactMap { $0 as? NavigationItemViewController } }
		set { viewControllers = newValue }
	}
}
