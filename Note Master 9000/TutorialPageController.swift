//
//  HelpPage1ViewController.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 28/03/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class TutorialPageController: UIViewController {
	
	// MARK: Outlets
	
	@IBOutlet weak var contentView: TutorialStaffDrawingView!
	@IBOutlet weak var contentLabel: UILabel!
	
	// MARK: Model
	
	var itemIndex: Int = 0
	var content: TutorialPageContent?
	
	// MARK: - ViewController lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		//setupView()
		
		view.backgroundColor = ColorPalette.Clouds
		contentLabel.textColor = ColorPalette.MidnightBlue
    }
	
	override func viewDidLayoutSubviews() {
		setupView() // Temporary place for setup. Proper frame not set on viewDidLoad
	}
	
	// MARK: Setup methods

	private func setupView() {
		contentLabel.text = content!.text
		if let image = content!.content as? UIImage {
			contentView.image = image
		} else if let noteT = content!.content as? NoteTutorial {
			contentView.drawStaff(withClef: noteT.clef, animated: false)
			contentView.drawNotes(noteT.notesToDraw)
		}
	}
}

// MARK: - StaffDrawingView subclass adding imageView

class TutorialStaffDrawingView: StaffDrawingView {
	let imageView = UIImageView()
	
	var image: UIImage? {
		didSet {
			setupImageView()
		}
	}
	
	private func setupImageView() {
		imageView.frame = bounds
		imageView.contentMode = .scaleAspectFit
		imageView.image = image
		self.addSubview(imageView)
	}
}
