//
//  ViewController.swift
//  ToDoList
//
//  Created by Nathan on 3/16/18.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var itemtitle: UITextField!
    @IBOutlet weak var itemdescription: UITextField!
    @IBOutlet weak var itemdate: UIDatePicker!
    weak var delegate: ToDoTableViewControllerDelegate?
    
    var item_desc: String?
    var item_title: String?
    var item_date: Date?
    var indexPath: NSIndexPath?
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addItemButton(_ sender: UIButton) {
        let i_title = itemtitle.text
        let i_desc = itemdescription.text
        let i_date = itemdate.date
        delegate?.newitemadd(by: self, with: i_title!, itemdescription: i_desc!, itemdate: i_date, at: indexPath)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemtitle.text = item_title
        itemdescription.text = item_desc
//        itemdate.date = item_date!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

protocol ToDoTableViewControllerDelegate: class {
    func newitemadd(by Controller: ViewController, with itemtitle: String, itemdescription: String, itemdate: Date, at indexPath: NSIndexPath?)
}
