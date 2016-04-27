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
	
	@IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //collectionView!.registerClass(LessonCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		collectionView!.backgroundColor = UIColor.whiteColor()
		
		collectionView!.dataSource = self
		collectionView!.delegate = self
		
		//lessons[0][1].complete = true
    }
	
	override func viewWillAppear(animated: Bool) {
		// MARK navigationBar setup
		let nav = self.navigationController?.navigationBar
		nav?.barStyle = UIBarStyle.Default
		nav?.barTintColor = UIColor.whiteColor()
		nav?.tintColor = UIColor.blackColor()
		nav?.titleTextAttributes = [
			NSForegroundColorAttributeName: UIColor.blackColor()
		]
		//====
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showClefView"
		{
			let cell = sender as! LessonCollectionCell
			if let destination = segue.destinationViewController as? BasicClefViewController {
				destination.lesson = cell.lesson
			}
		}
    }
	
	@IBAction func backToLessonsView(segue: UIStoryboardSegue) {
		
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

		cell.lesson = lessons[indexPath.section][indexPath.row]
        return cell
    }
	
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "lessonHeader", forIndexPath: indexPath) as! LessonCollectionHeader
		
		header.sectionTitle.text = lessonsSections[indexPath.section]
		return header
	}

	// MARK: UICollectionViewDelegateFlowLayout
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
		
		let spaceLeft: CGFloat
		
		let scWidth = UIScreen.mainScreen().bounds.width
		let itemCount = CGFloat(lessons[section].count)
		
		if itemCount <= 3 {
			spaceLeft = scWidth - itemCount*90 - (itemCount - 1)*2.0
		} else {
			spaceLeft = scWidth - 3*90 - (3 - 1)*2.0
		}
		
		return UIEdgeInsets(top: 20, left: spaceLeft/2, bottom: 20, right: spaceLeft/2)
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSize(width: 90, height: 90)
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
		return 2.0
	}
}
