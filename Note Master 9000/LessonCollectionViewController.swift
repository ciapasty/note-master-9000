//
//  LessonsViewController.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 29/03/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class LessonCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	private var cellHeight = CGFloat()
	private var cellSize = CGSize()
	
	// MARK: - Constants
	
	private struct Constants {
		static let LessonCellIdentifier = "lessonCell"
		static let SectionHeaderIdentifier = "lessonHeader"
		static let ShowLessonSegueIdentifier = "showLessonView"
		
		static let LessonCellToScreenHeightRatio: CGFloat = 6.3
		static let LessonCellTopBottomMargin: CGFloat = 20
		static let LessonCellMinimumInteritemSpacing: CGFloat = 2.0
	}
	
	// MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

		collectionView!.backgroundColor = ColorPalette.Clouds
		
		collectionView!.dataSource = self
		collectionView!.delegate = self
		
		cellHeight = round(UIScreen.mainScreen().bounds.height/Constants.LessonCellToScreenHeightRatio)
		cellSize = CGSize(width: cellHeight, height: cellHeight)
		
		lessons[3][0].complete = true
		lessons[3][1].complete = true
    }
	
	override func viewWillAppear(animated: Bool) {
		// MARK: navigationBar setup
		let nav = self.navigationController?.navigationBar
		nav?.barStyle = UIBarStyle.Default
		nav?.barTintColor = ColorPalette.Clouds
		nav?.tintColor = ColorPalette.MidnightBlue
		nav?.titleTextAttributes = [NSForegroundColorAttributeName: ColorPalette.MidnightBlue]
		nav?.alpha = 1.0
		//====
		collectionView.backgroundColor = ColorPalette.Clouds
		collectionView.reloadData()
	}

    // MARK: - UICollectionView

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return lessons.count
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return lessons[section].count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.LessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionCell
		
		cell.lesson = lessons[indexPath.section][indexPath.row] as Lesson
		
        return cell
    }
	
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: Constants.SectionHeaderIdentifier, forIndexPath: indexPath) as! LessonCollectionHeader
		
		header.sectionTitle.textColor = ColorPalette.MidnightBlue
		header.sectionTitle.text = lessonsSections[indexPath.section]
		return header
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		self.performSegueWithIdentifier(Constants.ShowLessonSegueIdentifier, sender: lessons[indexPath.section][indexPath.row])
	}

	// MARK: UICollectionViewDelegateFlowLayout
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
		
		let spaceLeft: CGFloat
		
		let scWidth = UIScreen.mainScreen().bounds.width
		let itemCount = CGFloat(lessons[section].count)
		
		if itemCount <= 3 {
			spaceLeft = scWidth - itemCount*cellHeight - (itemCount - 1)*Constants.LessonCellMinimumInteritemSpacing
		} else {
			spaceLeft = scWidth - 3*cellHeight - 2*Constants.LessonCellMinimumInteritemSpacing
		}
		
		return UIEdgeInsets(top: Constants.LessonCellTopBottomMargin,
		                    left: spaceLeft/2,
		                    bottom: Constants.LessonCellTopBottomMargin,
		                    right: spaceLeft/2)
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return cellSize
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
		return Constants.LessonCellMinimumInteritemSpacing
	}
	
	// MARK: - Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == Constants.ShowLessonSegueIdentifier {
			if let lessonVC = segue.destinationViewController as? LessonViewController {
				if let lesson = sender as? TutorialLesson {
					lessonVC.tutorialLesson = lesson
				} else if let lesson = sender as? NoteLesson {
					lessonVC.noteLesson = lesson
				}
			}
		}
	}
	
	@IBAction func backToLessonsView(segue: UIStoryboardSegue) {}
	
	// MARK: - Helper functions
	
	private func nextLessonIndexPath(indexPath: NSIndexPath) -> NSIndexPath? {
		if lessons[indexPath.section].endIndex > indexPath.row+1 {
			return NSIndexPath(forRow: indexPath.row+1, inSection: indexPath.section)
		} else if lessons.endIndex > indexPath.section+1 {
			return NSIndexPath(forRow: 0, inSection: indexPath.section+1)
		} else {
			return nil
		}
	}
}
