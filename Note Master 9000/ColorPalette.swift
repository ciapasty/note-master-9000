//
//  ColorPalette.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 03/05/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import Foundation
import UIKit

func colorCap(value: Int) -> Int {
	return max(0, min(255, value))
}

public struct MyColor {
	var red:Int
	var green:Int
	var blue:Int

	init (red: Int, green: Int, blue: Int){
		self.red = red
		self.green = green
		self.blue = blue
	}
	
	func dark() -> UIColor {
		let dRed:CGFloat = CGFloat(colorCap(red-50))/255
		let dGreen:CGFloat = CGFloat(colorCap(green-50))/255
		let dBlue:CGFloat = CGFloat(colorCap(blue-50))/255
		return UIColor(red: dRed, green: dGreen, blue: dBlue, alpha: 1.0)
	}
	
	func light() -> UIColor {
		let dRed:CGFloat = CGFloat(colorCap(red+50))/255
		let dGreen:CGFloat = CGFloat(colorCap(green+50))/255
		let dBlue:CGFloat = CGFloat(colorCap(blue+50))/255
		return UIColor(red: dRed, green: dGreen, blue: dBlue, alpha: 1.0)
	}
	
	func trans() -> UIColor {
		return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 0.5)
	}
	
	func base() -> UIColor {
		return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1.0)
	}
}

public struct ColorPalette {
	/*
	let light:MyColor = MyColor(red: 255, green: 248, blue: 237)
	let dark:MyColor = MyColor(red: 61, green: 54, blue: 51)
	let red:MyColor = MyColor(red: 224, green: 72, blue: 72)
	let green:MyColor = MyColor(red: 158, green: 224, blue: 72)
	let blue:MyColor = MyColor(red: 72, green: 116, blue: 224)
	let brightBlue:MyColor = MyColor(red: 72, green: 219, blue: 224)
	let purple:MyColor = MyColor(red: 113, green: 41, blue: 224)
	let yellow:MyColor = MyColor(red: 255, green: 224, blue: 61)
	let orange:MyColor = MyColor(red: 255, green: 130, blue: 61)
	*/
	
	let light:MyColor = MyColor(red: 255, green: 248, blue: 237)
	let dark:MyColor = MyColor(red: 61, green: 54, blue: 51)
	
	let green:MyColor = MyColor(red: 117, green: 157, blue: 102)
	
	let red :MyColor = MyColor(red: 190, green: 99, blue: 83) //red2
	let blue :MyColor = MyColor(red: 102, green: 117, blue: 147)
	
	let purple :MyColor = MyColor(red: 118, green: 109, blue: 149)
	let purple2 :MyColor = MyColor(red: 121, green: 89, blue: 116)
	let purple3 :MyColor = MyColor(red: 82, green: 60, blue: 89)
	let red3 :MyColor = MyColor(red: 131, green: 61, blue: 63)
	let red1 :MyColor = MyColor(red: 238, green: 142, blue: 122)
	let yellow :MyColor = MyColor(red: 249, green: 199, blue: 132)
	let orange :MyColor = MyColor(red: 239, green: 160, blue: 89)
	let brown :MyColor = MyColor(red: 155, green: 84, blue: 51)
	
	
}

/*
public struct ColorPalette2 {
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
*/

public let palette = ColorPalette()