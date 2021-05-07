//
//  ViewController.swift
//  MobiWeather
//
//  Created by Adwitech on 07/05/21.
//  Copyright © 2021 techvedika. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var locationsTableView: UITableView!
    let cellReuseIdentifier = "cell"
    var locationsList = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.locationsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        locationsTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchBookMarkedLocations()
    }
    
    func fetchBookMarkedLocations() {
        let progressHUD = ProgressHUD.init(title: "Loading")
        self.view.addSubview(progressHUD)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
        request.returnsObjectsAsFaults = false
        
        self.locationsList.removeAll()
        do {
            let result = try context.fetch(request)
            progressHUD.removeFromSuperview()
            for data in result as! [NSManagedObject] {
                let obj = ["city": data.value(forKey: "city") as! String,
                           "address": data.value(forKey: "address") as! String,
                           "latitude": data.value(forKey: "latitude") as! Double,
                           "longitude": data.value(forKey: "longitude") as! Double] as [String : Any]
                self.locationsList.append(obj)
            }
            self.locationsTableView.reloadData()
            
        } catch {
            progressHUD.removeFromSuperview()
            print("Failed")
        }

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "WeatherSegue") {
            let controller = segue.destination as! WeatherReportViewController
            let row = (sender as! NSIndexPath).row
            controller.locationObject = self.locationsList[row]
        }
    }
    
    func deleteLocation(report:[String: Any])
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
        request.predicate = NSPredicate.init(format: "latitude == \(report["latitude"] as! Double)")
        do
        {
            let fetchedResults =  try context.fetch(request) as? [NSManagedObject]
            for entity in fetchedResults! {
                context.delete(entity)
                try context.save()
            }
        }
        catch _ {
            print("Could not delete")

        }
    }

}

// MARK: - Tableview delegates

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.locationsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        cell.textLabel?.text = self.locationsList[indexPath.row]["city"] as? String
        cell.detailTextLabel?.text = self.locationsList[indexPath.row]["address"] as? String
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "WeatherSegue", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            deleteLocation(report: self.locationsList[indexPath.row])
            self.locationsList.remove(at: indexPath.row)
            self.locationsTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

