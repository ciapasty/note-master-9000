//
//  LessonsViewController.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 29/03/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

private let reuseIdentifier = "lessonCell"

class LessonsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	// MARK: Outlets
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	// MARK: Properties
	
	var cellHeight = CGFloat()
	var cellSize = CGSize()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //collectionView!.registerClass(LessonCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		collectionView!.backgroundColor = palette.light.base()
		
		collectionView!.dataSource = self
		collectionView!.delegate = self
		
		cellHeight = round(UIScreen.mainScreen().bounds.height/6.3)
		cellSize = CGSize(width: cellHeight, height: cellHeight)
		
		//lessons[0][0].complete = true
		
    }
	
	override func viewWillAppear(animated: Bool) {
		// MARK navigationBar setup
		let nav = self.navigationController?.navigationBar
		nav?.barStyle = UIBarStyle.Default
		nav?.barTintColor = palette.light.base()
		nav?.tintColor = palette.dark.base()
		nav?.titleTextAttributes = [NSForegroundColorAttributeName: palette.dark.base()]
		//====
		collectionView.backgroundColor = palette.light.base()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showTutorialView" {
			let lesson = sender as! TutorialLesson
			if let destination = segue.destinationViewController as? HelpViewController {
				destination.contentImages = lesson.imageNames
			}
		}
		if segue.identifier == "showNoteView" {
			let lesson = sender as! NoteLesson
			if let destination = segue.destinationViewController as? BasicClefViewController {
				destination.lesson = lesson
			}
		}
    }
	
	@IBAction func backToLessonsView(segue: UIStoryboardSegue) {
		collectionView.reloadData()
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if let lesson = lessons[indexPath.section][indexPath.row] as? TutorialLesson {
			self.performSegueWithIdentifier("showTutorialView", sender: lesson)
		} else if let lesson = lessons[indexPath.section][indexPath.row] as? NoteLesson {
			self.performSegueWithIdentifier("showNoteView", sender: lesson)
		}
	}

    // MARK: UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return lessons.count
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return lessons[section].count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! LessonCollectionCell
		
		cell.lesson = lessons[indexPath.section][indexPath.row] as Lesson
		
        return cell
    }
	
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "lessonHeader", forIndexPath: indexPath) as! LessonCollectionHeader
		
		header.sectionTitle.textColor = palette.dark.base()
		header.sectionTitle.text = lessonsSections[indexPath.section]
		return header
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
}
