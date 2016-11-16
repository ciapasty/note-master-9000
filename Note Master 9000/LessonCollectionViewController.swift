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
		
		cellHeight = round(UIScreen.main.bounds.height/Constants.LessonCellToScreenHeightRatio)
		cellSize = CGSize(width: cellHeight, height: cellHeight)
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// MARK: TODO navigationBar setup -> move to separate method
		let nav = self.navigationController?.navigationBar
		nav?.barStyle = UIBarStyle.default
		nav?.barTintColor = ColorPalette.Clouds
		nav?.tintColor = ColorPalette.MidnightBlue
		nav?.titleTextAttributes = [NSForegroundColorAttributeName: ColorPalette.MidnightBlue]
		nav?.alpha = 1.0
		//====
		collectionView.backgroundColor = ColorPalette.Clouds
		collectionView.reloadData()
	}

    // MARK: - UICollectionView

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return lessons.count
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return lessons[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.LessonCellIdentifier, for: indexPath) as! LessonCollectionCell
        
        cell.lesson = lessons[indexPath.section][indexPath.row] as Lesson
		
        return cell
    }
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.SectionHeaderIdentifier, for: indexPath) as! LessonCollectionHeader
		
		header.sectionTitle.textColor = ColorPalette.MidnightBlue
		header.sectionTitle.text = lessonsSections[indexPath.section]
		return header
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		self.performSegue(withIdentifier: Constants.ShowLessonSegueIdentifier, sender: indexPath)
	}

	// MARK: UICollectionViewDelegateFlowLayout
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		
		let spaceLeft: CGFloat
		
		let scWidth = UIScreen.main.bounds.width
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
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return cellSize
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return Constants.LessonCellMinimumInteritemSpacing
	}
	
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == Constants.ShowLessonSegueIdentifier {
			if let lessonVC = segue.destination as? LessonViewController {
				lessonVC.lessonIndexPath = sender as? IndexPath
			}
		}
	}
	
	@IBAction func backToLessonsView(_ segue: UIStoryboardSegue) {}

}
