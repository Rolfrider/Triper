//
//  PlacesCollectionView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 28/03/2021.
//

import UIKit
import SwiftUI

struct PlacesCollectionView: UIViewRepresentable {
	@Binding var data: [String]
	
	init(data: Binding<[String]>) {
		self._data = data
	}
	
	func makeUIView(context: Context) -> UICollectionView {
		let layout = PlacesCollectionLayout()
		layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = .clear
		collectionView.dataSource = context.coordinator
		collectionView.contentInset = .init(top: 16, left: 16, bottom: 16, right: 16)
		collectionView.delegate = context.coordinator
		collectionView.showsVerticalScrollIndicator = false
		collectionView.register(PlaceViewCell.self, forCellWithReuseIdentifier: PlaceViewCell.identifier)
		return collectionView
	}
	
	func updateUIView(_ uiView: UICollectionView, context: Context) {
		uiView.reloadData()
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(data: $data)
	}
	
	class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
		
		@Binding var data: [String]
		
		init(data: Binding<[String]>) {
			self._data = data
			super.init()
		}
		
		func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
			data.count
		}
		
		func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceViewCell.identifier, for: indexPath) as? PlaceViewCell else { fatalError() }
			cell.name = data[indexPath.item]
			return cell
		}
		
	}
}
