//
//  PlacesViewController.swift
//  AppWhereTest
//
//  Created by Yoshi Revelo on 4/14/19.
//  Copyright © 2019 Yoshi Revelo. All rights reserved.
//

import UIKit
import Alamofire

class PlacesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var datasource: [Merchant] = []
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(loadPlaces), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        loadPlaces()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Private methods
    
    @objc func loadPlaces(){
        Alamofire.request(Constants.API.placesStr)
        .validate()
            .responseData { (response) in
                switch response.result{
                case .success(let value):
                    print("Data: \(value)")
                    
                    do {
                        
                        let merchantsResponse = try JSONDecoder().decode(MerchantsResponseModel.self, from: value)
                        self.datasource = merchantsResponse.merchants
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                        
                    }catch let error{
                        print("Codable Places Error \(error.localizedDescription)")
                    }
                    
                case .failure(let error):
                    print("Request Error: \(error.localizedDescription)")
                }
                
        }
    }

}

extension PlacesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placesTableViewCell") as! placesTableViewCell
        
        cell.place = datasource[indexPath.row]
        
        return cell
    }
}
