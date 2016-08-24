//
//  SideMenuViewController.swift
//  PeakPerformance
//
//  Created by Bren on 23/08/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuViewController: UITableViewController
{

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
  

}

extension SideMenuManager
{
    public class func setUpSideMenu( sb: UIStoryboard )
    {
        SideMenuManager.menuLeftNavigationController = UISideMenuNavigationController( )
        SideMenuManager.menuLeftNavigationController?.leftSide = true
        let smvc = sb.instantiateViewControllerWithIdentifier("SideMenu")
        SideMenuManager.menuLeftNavigationController?.setViewControllers([smvc], animated: true)
        SideMenuManager.menuFadeStatusBar = false
    }
}