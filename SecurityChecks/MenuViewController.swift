//
//  ViewController.swift
//  SecurityChecks
//
//  Created by Vitor do Nascimento Rodrigues on 8/31/18.
//  Copyright © 2018 Vitor do Nascimento Rodrigues. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didTapOption(indexPath.row)
    }
    
    func didTapOption(_ row: Int) {
        switch row {
        case 0: openViewController(TouchIDValitadorViewController())
        case 2: openViewController(KeyChainViewController())
        case 3: openViewController(SynchableChainViewController())
        default:break
        }
    }
    
    func openViewController(_ vc: UIViewController) {
        show(vc, sender: nil)
    }
}

