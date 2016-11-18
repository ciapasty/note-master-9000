//
//  TutorialEndViewController.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 25/09/2016.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class TutorialEndViewController: UIViewController {
	
	var itemIndex: Int = 0
	var parentVC: LessonsViewController?
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		parentVC!.lessonFinished()
	}
	
}
