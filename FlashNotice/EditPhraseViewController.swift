//
//  EditPhraseViewController.swift
//  FlashNotice
//
//  Created by JoshuaKuehn on 9/24/17.
//  Copyright © 2017 JoshuaKuehn. All rights reserved.
//

import UIKit
import CoreData

class EditPhraseViewController: UIViewController {
  
  var notice: Notice!
  var moc: NSManagedObjectContext!
  
  @IBOutlet weak var phraseTextField: UITextField!
  var doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBarButtonTapped(sender:)))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Edit Phrase"
    self.navigationItem.rightBarButtonItem = doneBarButtonItem
    doneBarButtonItem.isEnabled = false
    
    phraseTextField.text = notice.title
    phraseTextField.delegate = self
    phraseTextField.becomeFirstResponder()
  }
  
  @objc
  func doneBarButtonTapped(sender: Any) {
    
    notice.title = phraseTextField.text ?? "Blank"
    
    moc.perform {
      do {
        try self.moc.save()
      } catch let error as NSError {
        fatalError("Error: \(error.localizedDescription)")
      }
    }
    
    self.navigationController?.popViewController(animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

// MARK: UITextFieldDelegate
extension EditPhraseViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let startingLength = textField.text?.characters.count ?? 0
    let lengthToAdd = string.characters.count
    let lengthToReplace = range.length
    
    let finalLength = startingLength + lengthToAdd - lengthToReplace
    
    doneBarButtonItem.isEnabled = finalLength > 0 ? true : false
    
    return true
  }
  
}
