//
//  DropDownLayoutCalculator2.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 31/08/2024.
//

import Foundation

struct DropDownLayoutCalculator2 {
    
    static func calculateDropDownLayout(desirableContainerHeight: CGFloat,
                                        anchorViewFrame: CGRect,
                                        minYOfDropDown: CGFloat,
                                        maxYOfDropDown: CGFloat) -> DropDownLayout {
        
        let layoutAboveAnchorView = calculateTopDropDownLayout(desirableContainerHeight,
                                                               anchorViewFrame,
                                                               minYOfDropDown)
        
        let layoutBelowAnchorView = calculateBottomDropDownLayout(desirableContainerHeight,
                                                                  anchorViewFrame,
                                                                  maxYOfDropDown)
        let shouldPlaceBelowAnchorView = layoutBelowAnchorView.offscreenHeight <= layoutAboveAnchorView.offscreenHeight
        return if shouldPlaceBelowAnchorView {
            layoutBelowAnchorView.withFoldedUpInitialFrame
        } else {
            layoutAboveAnchorView.withFoldedDownInitialFrame
        }
    }
    
    private static func calculateTopDropDownLayout(_ desirableContainerHeight: CGFloat,
                                                   _ anchorViewFrame: CGRect,
                                                   _ minYOfDropDown: CGFloat) -> DropDownLayout {
        let dropDownDesirableMinY = anchorViewFrame.minY - desirableContainerHeight
        let dropDownOffscreenHeight = abs(min(0, dropDownDesirableMinY-minYOfDropDown))
        let dropDownContainerHeight = desirableContainerHeight - dropDownOffscreenHeight
        let dropDownFrame = CGRect(x: 0,
                                   y: -dropDownContainerHeight,
                                   width: anchorViewFrame.width,
                                   height: dropDownContainerHeight)
        return DropDownLayout(initialFrame: .zero, finalFrame: dropDownFrame, offscreenHeight: dropDownOffscreenHeight)
    }
    
    private static func calculateBottomDropDownLayout(_ desirableContainerHeight: CGFloat,
                                                      _ anchorViewFrame: CGRect,
                                                      _ maxYOfDropDown: CGFloat) -> DropDownLayout {
        let dropDownDesirableMinY = anchorViewFrame.maxY
        let dropDownDesirableMaxY = dropDownDesirableMinY + desirableContainerHeight
        let dropDownOffscreenHeight = max(0, dropDownDesirableMaxY-maxYOfDropDown)
        let dropDownContainerHeight = desirableContainerHeight - dropDownOffscreenHeight
        let dropDownFrame = CGRect(x: 0,
                                   y: anchorViewFrame.height,
                                   width: anchorViewFrame.width,
                                   height: dropDownContainerHeight)
        return DropDownLayout(initialFrame: .zero, finalFrame: dropDownFrame, offscreenHeight: dropDownOffscreenHeight)
    }
}