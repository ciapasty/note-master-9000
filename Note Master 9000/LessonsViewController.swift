//
//  LessonsViewController.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 29/03/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class LessonsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	// MARK: Outlets
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	// MARK: Properties
	
	private var activeLessonIndexPath: NSIndexPath?
	private var showNextLessonFlag: Bool = false
	
	private var cellHeight = CGFloat()
	private var cellSize = CGSize()
	
	private struct Constants {
		static let LessonCellIdentifier = "lessonCell"
		static let SectionHeaderIdentifier = "lessonHeader"
		static let ShowNoteLessonSegueIdentifier = "showNoteView"
		static let ShowTutorialLessonSegueIdentifier = "showTutorialView"
	}
	
	// MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

		collectionView!.backgroundColor = ColorPalette.Clouds
		
		collectionView!.dataSource = self
		collectionView!.delegate = self
		
		cellHeight = round(UIScreen.mainScreen().bounds.height/6.3)
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
		
		if showNextLessonFlag {
			if let indexPath = nextLessonIndexPath(activeLessonIndexPath!) {
				activeLessonIndexPath = indexPath
				if let lesson = lessons[indexPath.section][indexPath.row] as? TutorialLesson {
					self.performSegueWithIdentifier(Constants.ShowTutorialLessonSegueIdentifier, sender: lesson)
				} else if let lesson = lessons[indexPath.section][indexPath.row] as? NoteLesson {
					self.performSegueWithIdentifier(Constants.ShowNoteLessonSegueIdentifier, sender: lesson)
				}
			}
		}
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
		activeLessonIndexPath = indexPath
		if let lesson = lessons[indexPath.section][indexPath.row] as? TutorialLesson {
			self.performSegueWithIdentifier(Constants.ShowTutorialLessonSegueIdentifier, sender: lesson)
		} else if let lesson = lessons[indexPath.section][indexPath.row] as? NoteLesson {
			self.performSegueWithIdentifier(Constants.ShowNoteLessonSegueIdentifier, sender: lesson)
		}
	}

	// MARK: UICollectionViewDelegateFlowLayout
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
		
		let spaceLeft: CGFloat
		
		let scWidth = UIScreen.mainScreen().bounds.width
		let itemCount = CGFloat(lessons[section].count)
		
		if itemCount <= 3 {
			spaceLeft = scWidth - itemCount*cellHeight - (itemCount - 1)*2.0
		} else {
			spaceLeft = scWidth - 3*cellHeight - (3 - 1)*2.0
		}
		
		return UIEdgeInsets(top: 20, left: spaceLeft/2, bottom: 20, right: spaceLeft/2)
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return cellSize
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
		return 2.0
	}
	
	// MARK: - Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let identifier = segue.identifier {
			switch identifier {
			case Constants.ShowTutorialLessonSegueIdentifier:
				let lesson = sender as! TutorialLesson
				if let destination = segue.destinationViewController as? HelpViewController {
					destination.contentImages = lesson.imageNames
				}
			case Constants.ShowNoteLessonSegueIdentifier:
				let lesson = sender as! NoteLesson
				if let destination = segue.destinationViewController as? BasicClefViewController {
					destination.lesson = lesson
				}
			default: break
			}
		}
	}
	
	@IBAction func backToLessonsView(segue: UIStoryboardSegue) {
		if let src = segue.sourceViewController as? BasicClefViewController {
			showNextLessonFlag = src.goToNextLessonFlag
		}
	}
	
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
