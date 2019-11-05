//
//  MenuViewController.swift
//  iOSSwift
//
//  Created by nice on 30/10/2019.
//  Copyright © 2019 nice. All rights reserved.
//

import UIKit
import YouboraConfigUtils

class MenuViewController: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = self.navigationController {
            navigationController.delegate = self
        }
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? PlayerViewController {
            viewController.viewModel = PlayerViewModel(segueIdentifier: segue.identifier)
            return
        }
       
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        if let playerViewController = viewController as? PlayerViewController {
//            playerViewController.loadAdPlayer()
//            return
//        }
    }
    
    @IBAction func onSettingsPress(_ sender: Any) {
        self.navigationController?.pushViewController(YouboraConfigViewController().initFromXIB(), animated: true)
    }
}
