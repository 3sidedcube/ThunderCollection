//
//  LeftAlignedLayout.swift
//  ThunderCollection
//
//  Created by Simon Mitchell on 07/09/2017.
//  Copyright © 2017 3sidedcube. All rights reserved.
//

import UIKit

extension UICollectionViewLayoutAttributes {
	
	func leftAlignFrame(with sectionInset: UIEdgeInsets) {
		
		var frame = self.frame
		frame.origin.x = sectionInset.left
		self.frame = frame
	}
}

public class LeftAlignedLayout: UICollectionViewFlowLayout {
	
	override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		
		var originalAttributes = super.layoutAttributesForElements(in: rect)
		
		originalAttributes?.enumerated().forEach({ (index, attributes) in
			
			guard attributes.representedElementKind == nil, let attributes = layoutAttributesForItem(at: attributes.indexPath) else { return }
			originalAttributes?[index] = attributes
		})
		
		return originalAttributes
	}

	override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		
		let superAttributes = super.layoutAttributesForItem(at: indexPath)
		
		guard let attributes = superAttributes?.copy() as? UICollectionViewLayoutAttributes, let collectionView = collectionView else { return superAttributes }
		
		let sectionInset = self.sectionInset(forSectionAt: indexPath.section)
		
		let layoutWidth = collectionView.frame.width - sectionInset.left - sectionInset.right
		
		if indexPath.item == 0 {
			
			attributes.leftAlignFrame(with: sectionInset)
			return attributes
		}
		
		let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
		
		guard let previousFrame = layoutAttributesForItem(at: previousIndexPath)?.frame else { return attributes }
		let currentFrame = attributes.frame

		let strecthedCurrentFrame = CGRect(x: sectionInset.left, y: currentFrame.minY, width: layoutWidth, height: currentFrame.height)
		// if the current frame, once left aligned to the left and stretched to the full collection view
		// width intersects the previous frame then they are on the same line
		let isFirstItemInRow = !strecthedCurrentFrame.intersects(previousFrame)
		
		guard !isFirstItemInRow else {
			attributes.leftAlignFrame(with: sectionInset)
			return attributes
		}
		
		var frame = attributes.frame
		frame.origin.x = previousFrame.maxX + minimumInterimSpacing(forSectionAt: indexPath.section)
		attributes.frame = frame

		return attributes
	}
	
	private func minimumInterimSpacing(forSectionAt index: Int) -> CGFloat {
		
		guard let collectionView = collectionView else { return minimumInteritemSpacing }
		
		return (collectionView.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: index) ?? minimumInteritemSpacing
	}
	
	private func sectionInset(forSectionAt index: Int) -> UIEdgeInsets {
		
		guard let collectionView = collectionView else { return sectionInset }
		
		return (collectionView.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(collectionView, layout: self, insetForSectionAt: index) ?? sectionInset
	}
}
