//
//  HelpViewController.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 28/03/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

	// MARK: Properties
	
	private var pageViewController: UIPageViewController?
	var contentImages = [String]()
	
	// MARK: ViewController
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		createPageViewController()
		setupPageControl()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	// MARK: PageViewController
	
	private func createPageViewController() {
		
		let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
		pageController.dataSource = self
		
		if contentImages.count > 0 {
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
		appearance.pageIndicatorTintColor = UIColor.grayColor()
		appearance.currentPageIndicatorTintColor = UIColor.blackColor()
		appearance.backgroundColor = UIColor.whiteColor()
	}
	
	// MARK: PaegViewControllerDelegate
	
	func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
		return contentImages.count
	}
	
	func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
		return 0
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		
		let itemController = viewController as! PageItemController
		
		if itemController.itemIndex > 0 {
			return getItemController(itemController.itemIndex-1)
		}
		
		return nil
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		
		let itemController = viewController as! PageItemController
		
		if itemController.itemIndex+1 < contentImages.count {
			return getItemController(itemController.itemIndex+1)
		}
		
		return nil
	}
	
	private func getItemController(itemIndex: Int) -> PageItemController? {
		
		if itemIndex < contentImages.count {
			let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("ItemController") as! PageItemController
			pageItemController.itemIndex = itemIndex
			pageItemController.imageName = contentImages[itemIndex]
			return pageItemController
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
