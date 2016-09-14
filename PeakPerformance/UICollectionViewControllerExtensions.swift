//
//  UICollectionViewControllerExtensions.swift
//  PeakPerformance
//
//  Created by Bren on 14/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

extension UICollectionViewController
{
    // MARK: - Menu Notification Badge
    //  - Loads the burger icon with the badge if a monthly review is available
    //  - Sets up a UIImage and a Highlighted UIImage and a button and assigns it to leftBarButtonItem
    //  - ENMBadgedBarButtonItem is responsible for the badge
    
    override func setUpLeftBarButtonItem( number: String )
    {
        
        let image = UIImage(named: MENU_ICON_NAME)
        let highlightedImage = UIImage(named: MENU_ICON_HIGHLIGHTED_NAME)
        let button = UIButton(type: .Custom)
        
        if let knownImage = image {
            button.frame = CGRectMake(0.0, 0.0, knownImage.size.width, knownImage.size.height)
        } else {
            button.frame = CGRectZero;
        }
        
        button.setBackgroundImage(image, forState: UIControlState.Normal)
        button.setBackgroundImage(highlightedImage, forState: .Highlighted)
        button.addTarget(self,
                         action: #selector(leftButtonPressed(_:)),
                         forControlEvents: UIControlEvents.TouchUpInside)
        button.adjustsImageWhenHighlighted = true
        button.tintColor = UIColor.lightGrayColor()
        let newBarButton = ENMBadgedBarButtonItem(customView: button, value: number) // parameter value for the number inside the dot
        newBarButton.badgeValue = number  // sets the dot and the number inside
        navigationItem.leftBarButtonItem = newBarButton
    }
}

extension UICollectionViewController
{
    // function to BarButton item tap
    override func leftButtonPressed(_sender: UIButton)
    {
        presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
        navigationItem.leftBarButtonItem?.tintColor = UIColor.lightGrayColor()
    }
}