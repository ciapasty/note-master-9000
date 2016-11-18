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
	var parentVC: LessonsViewController?
	var lesson: TutorialLesson? {
		didSet {
			if lesson != nil {
				createPageViewController()
				setupPageControl()
			}
		}
	}
	
	private var pageViewController: UIPageViewController?
	
	// MARK: Constants
	
	private struct Constants {
		static let PageControllerIdentifier = "PageController"
		static let PageItemControllerIdentifier = "LessonPageView"
		static let LastPageControllerIdentifier = "LastPageView"
	}
	
	// MARK: - ViewController lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = ColorPalette.Clouds
		setupPageControl()
	}
	
	// MARK: PageViewController
	
	private func createPageViewController() {
		
		let pageController = self.storyboard!.instantiateViewController(withIdentifier: Constants.PageControllerIdentifier) as! UIPageViewController
		pageController.dataSource = self
		
		if lesson!.pages.count > 0 {
			let firstController = getTutorialPageController(0)!
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
	
	private func getTutorialPageController(_ itemIndex: Int) -> TutorialPageController? {
		
		if itemIndex < lesson!.pages.count {
			let pageItemController = self.storyboard!.instantiateViewController(withIdentifier: Constants.PageItemControllerIdentifier) as! TutorialPageController
			pageItemController.itemIndex = itemIndex
			pageItemController.content = lesson!.pages[itemIndex]
			return pageItemController
		} else {
			return nil
		}
	}
	
	private func getLastPageController(_ itemIndex: Int) -> TutorialEndViewController? {
		if itemIndex == lesson!.pages.count {
			let pageItemController = self.storyboard!.instantiateViewController(withIdentifier: Constants.LastPageControllerIdentifier) as! TutorialEndViewController
			pageItemController.parentVC = parentVC
			return pageItemController
		} else {
			return nil
		}
	}
	
	// MARK: PageViewControllerDelegate
	
	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return lesson!.pages.count+1
	}
	
	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		if let firstViewController = pageViewController.viewControllers?.first as? TutorialPageController {
			return firstViewController.itemIndex
		} else if let firstViewController = pageViewController.viewControllers?.first as? TutorialEndViewController {
			return firstViewController.itemIndex
		} else {
			return 0
		}
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		
		if let itemController = viewController as? TutorialPageController {
			if itemController.itemIndex > 0 {
				return getTutorialPageController(itemController.itemIndex-1)
			}
		} else if let itemController = viewController as? TutorialEndViewController {
			return getTutorialPageController(itemController.itemIndex-1)
		}
		return nil
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		
		if let itemController = viewController as? TutorialPageController {
			if itemController.itemIndex < lesson!.pages.count-1 {
				return getTutorialPageController(itemController.itemIndex+1)
			} else {
				return getLastPageController(itemController.itemIndex+1)
			}
		} else if let _ = viewController as? TutorialEndViewController {
			return nil
		}
		return nil
	}
}
