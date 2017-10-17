//
//  ClefSelectionViewController.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 17/10/2017.
//  Copyright © 2017 Mattijah. All rights reserved.
//

import UIKit

class ClefSelectionViewController: UIViewController {
    
    var distro:Distribution = .gauss
    
    override func viewDidLoad() {
        view.backgroundColor = ColorPalette.Clouds
    }
    
    @IBAction func onSwitchValueCHanged(_ sender: UISwitch) {
        if sender.isOn {
            distro = .linear
        } else {
            distro = .gauss
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var clef:Clef
        
        switch segue.identifier! {
        case "TrebleClefSegue":
            clef = Clef.trebleClef
            break
        case "BassClefSegue":
            clef = Clef.bassClef
            break
        default: return
        }
        
        if let dest = segue.destination as? BasicClefViewController {
            dest.clef = clef
            dest.distribution = distro
        }
        
    }
    
    @IBAction func unwindToStart(segue: UIStoryboardSegue) {}

}
