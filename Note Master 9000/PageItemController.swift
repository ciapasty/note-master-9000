//
//  HelpPage1ViewController.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 28/03/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class PageItemController: UIViewController {
	
	var itemIndex: Int = 0
	var imageName: String = "" {
		didSet {
			if let label = contentLabel {
				label.text = imageName
			}
			if let imageView = contentImageView {
				imageView.image = UIImage(named: imageName)
			}
		}
	}

	@IBOutlet weak var contentImageView: UIImageView!
	@IBOutlet weak var contentLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		contentLabel!.text = imageName
		contentImageView!.image = UIImage(named: imageName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
