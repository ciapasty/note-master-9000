//
//  HelpViewController.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 28/03/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	
	private var pageViewController: UIPageViewController?
	
	// MARK: Model
	
	var lesson: TutorialLesson? {
		didSet {
			if lesson != nil {
				createPageViewController()
				setupPageControl()
			}
		}
	}
	
	// MARK: Constants
	
	private struct Constants {
		static let PageControllerIdentifier = "PageController"
		static let PageItemControllerIdentifier = "ItemController"
	}
	
	// MARK: - ViewController lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if lesson != nil {
			createPageViewController()
			setupPageControl()
		}
	}
	
	// MARK: PageViewController
	
	private func createPageViewController() {
		
		let pageController = self.storyboard!.instantiateViewControllerWithIdentifier(Constants.PageControllerIdentifier) as! UIPageViewController
		pageController.dataSource = self
		
		if lesson!.pages.count > 0 {
			let firstController = getItemController(0)!
			let startingViewControllers: NSArray = [firstController]
			pageController.setViewControllers(startingViewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
		}
		
		pageViewController = pageController
		addChildViewController(pageViewController!)
		self.view.addSubview(pageViewController!.view)
		pageViewController!.didMoveToParentViewController(self)
	}
 
	private func setupPageControl() {
		let appearance = UIPageControl.appearance()
		appearance.pageIndicatorTintColor = ColorPalette.Asbestos
		appearance.currentPageIndicatorTintColor = ColorPalette.MidnightBlue
		appearance.backgroundColor = ColorPalette.Clouds
	}
	
	// MARK: PageItemController
	
	private func getItemController(itemIndex: Int) -> TutorialPageItemController? {
		
		if itemIndex < lesson!.pages.count {
			let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier(Constants.PageItemControllerIdentifier) as! TutorialPageItemController
			pageItemController.itemIndex = itemIndex
			pageItemController.content = lesson!.pages[itemIndex]
			return pageItemController
		}
		
		return nil
	}
	
	// MARK: PaegViewControllerDelegate
	
	func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
		return lesson!.pages.count
	}
	
	func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
		return 0
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		
		let itemController = viewController as! TutorialPageItemController
		
		if itemController.itemIndex > 0 {
			return getItemController(itemController.itemIndex-1)
		}
		
		return nil
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		
		let itemController = viewController as! TutorialPageItemController
		
		if itemController.itemIndex+1 < lesson!.pages.count {
			return getItemController(itemController.itemIndex+1)
		}
		
		return nil
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
