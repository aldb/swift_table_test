//
//  ViewController.swift
//  tabletest
//
//  Created by aldb on 7/24/17.
//  Copyright © 2017 aldb. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    
    var data = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        myTableView.reloadData()
    }
    
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appendingPathComponent("Data").path
    }
    
    private func loadData() {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Student] {
            data = ourData
        }
    }
    
    private func saveData(student: Student) {
        self.data.append(student)
        NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_ID", for: indexPath)

        cell.textLabel?.text = data[indexPath.row].Name
        cell.detailTextLabel?.text = data[indexPath.row].LastName
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            data.remove(at: indexPath.row)
            NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func addStudents(_ sender: Any) {
        let alert = UIAlertController(title: "Add new student", message: "Enter student's name", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        let save = UIAlertAction(title: "Save", style: .default) {
            (alertAction: UIAlertAction) in
            
            let name = alert.textFields?[0].text!
            let lastName = alert.textFields?[1].text!
            
            let newStudent = Student(name: name!, lastName: lastName!)
            
            self.saveData(student: newStudent)
            self.myTableView.reloadData()
        }
        
        alert.addTextField(configurationHandler: nil)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(save)
        alert.addAction(cancel)
        
        self.present(alert, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditSegue", sender: tableView.indexPathForSelectedRow!.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditDataVC {
            if let index = sender as? Int {
                destination.index = index
                destination.data = data
                destination.path = filePath
            }
        }
    }


}

