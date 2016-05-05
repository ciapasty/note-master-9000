//
//  ColorPalette.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 03/05/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import Foundation
import UIKit

public struct ColorPalette {
	let light = UIColor(red: 255/255, green: 248/255, blue: 237/255, alpha: 1)
	let lightTrans = UIColor(red: 255/255, green: 248/255, blue: 237/255, alpha: 0.7)
	let dark = UIColor(red: 61/255, green: 54/255, blue: 51/255, alpha: 1)
	let darkTrans = UIColor(red: 61/255, green: 54/255, blue: 51/255, alpha: 0.5)
	
	let red = UIColor(red: 224/255, green: 72/255, blue: 72/255, alpha: 1)
	let redTrans = UIColor(red: 224/255, green: 72/255, blue: 72/255, alpha: 0.7)
	
	let green = UIColor(red: 158/255, green: 224/255, blue: 72/255, alpha: 1)
	let greenTrans = UIColor(red: 158/255, green: 224/255, blue: 72/255, alpha: 0.7)
	
	let blue = UIColor(red: 72/255, green: 219/255, blue: 224/255, alpha: 1)
	let blueTrans = UIColor(red: 72/255, green: 219/255, blue: 224/255, alpha: 0.7)
	let darkBlue = UIColor(red: 0/255, green: 147/255, blue: 142/255, alpha: 1)
}

public let palette = ColorPalette()