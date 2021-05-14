//
//  PlacesViewCell.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 28/03/2021.
//

import UIKit

extension PlacesCollectionView {
	class PlaceViewCell: UICollectionViewCell {
		static let identifier: String = "PlaceCell"
		let label: UILabel = UILabel()
		
		var name: String? {
			didSet {
				label.text = name
			}
		}
		
		override init(frame: CGRect) {
			super.init(frame: frame)
			contentView.addSubview(label)
			contentView.translatesAutoresizingMaskIntoConstraints = false
			label.translatesAutoresizingMaskIntoConstraints = false
			NSLayoutConstraint.activate([
				contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
				contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
				contentView.topAnchor.constraint(equalTo: topAnchor),
				contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
			])
			NSLayoutConstraint.activate([
				label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
				label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
				label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
				label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
				label.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.7),
				label.widthAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.main.bounds.width * 0.05)
			])
			backgroundColor = .tertiarySystemBackground
		}
		
		override func layoutSubviews() {
			super.layoutSubviews()
			layer.cornerRadius = frame.height / 2
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
}
