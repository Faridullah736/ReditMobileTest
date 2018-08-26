//
//  SearchViewController.swift
//  Mobiletest
//
//  Created by Faridullah on 8/25/18.
//  Copyright © 2018 Faridullah. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class SearchViewController: UIViewController {
    var arraySearchUser:Array<Githubuser> = []
    
    @IBOutlet var tbleviewSearch: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        callWebServiceGithubSearchUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupUI() {
       self.title = "Search"
    }
}
extension SearchViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySearchUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:searchCell = tableView.dequeueReusableCell(withIdentifier: "search") as! searchCell
        let data = arraySearchUser[indexPath.row] as Githubuser
        cell.githubData = data
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
        let Objc:DetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "details") as! DetailViewController
        Objc.userDetail = arraySearchUser[indexPath.row] as Githubuser
        self.navigationController?.pushViewController(Objc, animated: true)
    }
}
extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
     
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text!.count > 0{
            self.callWebServiceGithubSearchByUser(user: searchBar.text!)
        }
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // start search
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        
    }
}
extension SearchViewController {
    func callWebServiceGithubSearchUsers(){
       
        let url:String=Endpoint.GithubSearch.urlString()
        _ = WebServiceManager.call(requestMethod: .get, serviceURL: url, params: nil, includeAccessToken: true, completion: { (response, error) in
            
            if (response != nil) {
                if (response?.response?.statusCode == ServerResponseStatusCode.kOK) && (response!.result.value != nil) {
                    self.arraySearchUser.removeAll()
                    let responseData = JSON(response!.result.value!)
                    let resultData = responseData[DateResponseKey.kResult].arrayValue
                    for jsonUnit in resultData {
                        self.arraySearchUser.append(Githubuser(fromJson:jsonUnit))
                    }
                    self.tbleviewSearch.reloadData()
//                    print(resultData)
                   
                    
                    
                } else if response?.response?.statusCode == ServerResponseStatusCode.kExpiredToken {
                    // Extension.showSessionExpiredAndOpenLogin(parentVC: self)
                } else if error != nil {
                   
                    print(error?.localizedDescription ?? "")
                } else {
                    if (response?.result.isFailure == true){
                        print("Request Timeout")
                        return
                    }
                    var responseData = JSON(response?.result.value ?? "")
                    let message:String? = (responseData != nil) ? responseData[DateResponseKey.kMessage].stringValue : nil
                    if message != nil {
                       
                        print("\(message!)")
                    } else {
                        
                        print("\(String(describing: response?.result.description))")
                    }
                }
            } else {
                
                print("\((error?.localizedDescription) ?? "")")
            }
        })
        
    }
    func callWebServiceGithubSearchByUser(user:String){
        
        let url:String=Endpoint.GithubSearchbyuser(searchStr: user).urlString()
        
        _ = WebServiceManager.call(requestMethod: .get, serviceURL: url, params: nil, includeAccessToken: true, completion: { (response, error) in
            
            if (response != nil) {
                if (response?.response?.statusCode == ServerResponseStatusCode.kOK) && (response!.result.value != nil) {
                    self.arraySearchUser.removeAll()
                    let responseData = JSON(response!.result.value!)
                    let resultData = responseData[DateResponseKey.kResult].arrayValue
                    for jsonUnit in resultData {
                        self.arraySearchUser.append(Githubuser(fromJson:jsonUnit))
                    }
                    self.tbleviewSearch.reloadData()
                    //                    print(resultData)
                    
                    
                    
                } else if response?.response?.statusCode == ServerResponseStatusCode.kExpiredToken {
                    // Extension.showSessionExpiredAndOpenLogin(parentVC: self)
                } else if error != nil {
                    
                    print(error?.localizedDescription ?? "")
                } else {
                    if (response?.result.isFailure == true){
                        print("Request Timeout")
                        return
                    }
                    var responseData = JSON(response?.result.value ?? "")
                    let message:String? = (responseData != nil) ? responseData[DateResponseKey.kMessage].stringValue : nil
                    if message != nil {
                        
                        print("\(message!)")
                    } else {
                        
                        print("\(String(describing: response?.result.description))")
                    }
                }
            } else {
                
                print("\((error?.localizedDescription) ?? "")")
            }
        })
        
    }
   
}
