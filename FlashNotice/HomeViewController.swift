//
//  HomeViewController.swift
//  FlashNotice
//
//  Created by JoshuaKuehn on 9/24/17.
//  Copyright © 2017 JoshuaKuehn. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

  enum Segue:String {
    case DisplayPhrase = "DisplayPhraseSegue"
    case EditPhrase = "EditPhraseSegue"
    case AddPhrase = "AddPhraseSegue"
  }

  let cellIdentifier = "Cell"
  var fetchedResultsController: NSFetchedResultsController<Notice>!
  var moc: NSManagedObjectContext!
  
  @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      let fetchRequest: NSFetchRequest<Notice> = Notice.fetchRequest()
      fetchRequest.sortDescriptors = []
      
      moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      
      fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                            managedObjectContext: moc,
                                                            sectionNameKeyPath: nil,
                                                            cacheName: nil)
      fetchedResultsController.delegate = self
      
      do {
        try fetchedResultsController.performFetch()
      } catch let error as NSError {
        print("Fetching error: \(error), \(error.userInfo)")
      }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  @IBAction func addBarButtonTapped(_ sender: Any) {
    self.performSegue(withIdentifier: Segue.AddPhrase.rawValue, sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == Segue.AddPhrase.rawValue {
      if let addPhraseVC = segue.destination as? AddPhraseViewController {
        addPhraseVC.moc = moc
      }
    } else if segue.identifier == Segue.DisplayPhrase.rawValue {
      if let displayPhraseVC = segue.destination as? DisplayPhraseViewController {
        guard let indexPath = sender as? IndexPath else { return }
        guard let notice = tableView.cellForRow(at: indexPath)?.textLabel?.text else { return }
        displayPhraseVC.notice = notice
      }
    } else if segue.identifier == Segue.EditPhrase.rawValue {
      if let editPhraseVC = segue.destination as? EditPhraseViewController {
        guard let indexPath = sender as? IndexPath else { return }
        let notice = fetchedResultsController.object(at: indexPath)
        
        editPhraseVC.notice = notice
        editPhraseVC.moc = moc
      }
    }
    
  }
  
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: Segue.DisplayPhrase.rawValue, sender: indexPath)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    self.performSegue(withIdentifier: Segue.EditPhrase.rawValue, sender: indexPath)
  }
}

// MARK: UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultsController.sections?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchedResultsController.sections?[section].numberOfObjects ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    let notice = fetchedResultsController.object(at: indexPath)
    
    cell.textLabel?.text = notice.title
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let notice = fetchedResultsController.object(at: indexPath)
      self.moc.delete(notice)
      
      moc.perform {
        do {
          try self.moc.save()
        } catch let error as NSError {
          fatalError("Error: \(error.localizedDescription)")
        }
      }
    }
    
  }
  
}

// MARK: NSFetchedResultsControllerDelegate
extension HomeViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      tableView.insertRows(at: [newIndexPath!], with: .automatic)
    case .delete:
      tableView.deleteRows(at: [indexPath!], with: .automatic)
    case .update:
      tableView.reloadRows(at: [indexPath!], with: .automatic)
    default:
      print("Haven't implemented that yet...")
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
}
