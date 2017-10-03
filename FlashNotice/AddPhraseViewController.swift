//
//  AddPhraseViewController.swift
//  FlashNotice
//
//  Created by JoshuaKuehn on 9/24/17.
//  Copyright © 2017 JoshuaKuehn. All rights reserved.
//

import UIKit
import CoreData

class AddPhraseViewController: UIViewController {
  
  var moc: NSManagedObjectContext!
  var doneBarButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBarButtonTapped(_:)))
  
  @IBOutlet weak var titleTextField: UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Add Phrase"
    self.navigationItem.rightBarButtonItem = doneBarButton
    titleTextField.becomeFirstResponder()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @objc
  func doneBarButtonTapped(_ sender: Any) {
    
    if titleTextField.text?.isEmpty != true {
      
      let notice = Notice(context: moc)
      notice.title = titleTextField.text ?? ""
      moc.insert(notice)
      
      moc.perform {
        do {
          try self.moc.save()
        } catch let error as NSError {
          fatalError("Error: \(error.localizedDescription)")
        }
      }
    }
    
    self.navigationController?.popViewController(animated: true)
  }
  
}
