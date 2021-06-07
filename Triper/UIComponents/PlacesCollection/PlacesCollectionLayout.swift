//
//  PlacesCollectionLayout.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 28/03/2021.
//

import UIKit

class PlacesCollectionLayout: UICollectionViewFlowLayout {
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		guard let attributesForElementsInRect = super.layoutAttributesForElements(in: rect) else { return super.layoutAttributesForElements(in: rect) }
		var newAttributesForElementsInRect = [UICollectionViewLayoutAttributes]()
		var leftMargin: CGFloat = 0.0;
		for attributes in attributesForElementsInRect {
			if (attributes.frame.origin.x == self.sectionInset.left) {
				leftMargin = self.sectionInset.left
			} else {
				var newLeftAlignedFrame = attributes.frame
				newLeftAlignedFrame.origin.x = leftMargin
				attributes.frame = newLeftAlignedFrame
			}
			leftMargin += attributes.frame.size.width + minimumInteritemSpacing
			newAttributesForElementsInRect.append(attributes)
		}
		return newAttributesForElementsInRect
	}
}
