//
//  HelpViewController.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 28/03/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	
	// MARK: Model
	
	var lesson: TutorialLesson? {
		didSet {
			if lesson != nil {
				createPageViewController()
				setupPageControl()
			}
		}
	}
	
	var parentVC: LessonViewController?
	
	private var pageViewController: UIPageViewController?
	
	// MARK: Constants
	
	private struct Constants {
		static let PageControllerIdentifier = "PageController"
		static let PageItemControllerIdentifier = "ItemController"
	}
	
	// MARK: - ViewController lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupPageControl()
	}
	
	// MARK: PageViewController
	
	private func createPageViewController() {
		
		let pageController = self.storyboard!.instantiateViewController(withIdentifier: Constants.PageControllerIdentifier) as! UIPageViewController
		pageController.dataSource = self
		
		if lesson!.pages.count > 0 {
			let firstController = getItemController(0)!
			let startingViewControllers: NSArray = [firstController]
			pageController.setViewControllers(startingViewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
		}
		
		pageViewController = pageController
		addChildViewController(pageViewController!)
		self.view.addSubview(pageViewController!.view)
		pageViewController!.didMove(toParentViewController: self)
	}
 
	private func setupPageControl() {
		let appearance = UIPageControl.appearance()
		appearance.pageIndicatorTintColor = ColorPalette.Asbestos
		appearance.currentPageIndicatorTintColor = ColorPalette.MidnightBlue
		appearance.backgroundColor = ColorPalette.Clouds
	}
	
	// MARK: PageItemController
	
	private func getItemController(_ itemIndex: Int) -> TutorialPageItemController? {
		
		if itemIndex < lesson!.pages.count {
			let pageItemController = self.storyboard!.instantiateViewController(withIdentifier: Constants.PageItemControllerIdentifier) as! TutorialPageItemController
			pageItemController.itemIndex = itemIndex
			pageItemController.content = lesson!.pages[itemIndex]
			return pageItemController
		}
		
		return nil
	}
	
	// MARK: PageViewControllerDelegate
	
	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return lesson!.pages.count
	}
	
	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		if let firstViewController = pageViewController.viewControllers?.first as? TutorialPageItemController {
			return firstViewController.itemIndex
		} else {
			return 0
		}
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		
		let itemController = viewController as! TutorialPageItemController
		
		if itemController.itemIndex > 0 {
			return getItemController(itemController.itemIndex-1)
		}
		
		return nil
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		
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
