//
//  DisplayPhraseViewController.swift
//  FlashNotice
//
//  Created by JoshuaKuehn on 9/28/17.
//  Copyright © 2017 JoshuaKuehn. All rights reserved.
//

import UIKit

class DisplayPhraseViewController: UIViewController {
  
  let phrase: UILabel = {
    var phrase = UILabel()
    phrase.textColor = UIColor.white
    phrase.textAlignment = .center
    phrase.font = phrase.font.withSize(48)
    phrase.numberOfLines = 0
    return phrase
  }()
  
  var fontSize: CGFloat = 48 {
    didSet {
      if fontSize >= 100 {
        fontSize = oldValue
      } else if fontSize <= 18 {
        fontSize = oldValue
      }
      phrase.font = phrase.font.withSize(fontSize)
    }
  }
  
  var notice = "Default Text"
  
  lazy var scrollView: UIScrollView = {
    var scrollView = UIScrollView(frame: .zero)
    
    return scrollView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    add(phraseToView: phrase)
    phrase.text = notice
    
    
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchScreenGestureRecognizer(sender:)))
    self.view.addGestureRecognizer(pinchGesture)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func add(phraseToView label: UILabel) {
    self.view.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
  }
  
  @objc
  func pinchScreenGestureRecognizer(sender: UIPinchGestureRecognizer) {
    
    if sender.state == .began || sender.state == .changed {
      fontSize = fontSize * sender.scale
    }
    sender.scale = 1.0
    
  }
  
  @IBAction func backButtonTapped(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
}






























