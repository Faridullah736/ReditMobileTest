//
//  DetailViewController.swift
//  Mobiletest
//
//  Created by Faridullah on 8/25/18.
//  Copyright © 2018 Faridullah. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailViewController: UIViewController {
    var arrayfollowers:Array<Githubuser> = []
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var lblname: UILabel!
    @IBOutlet var lblemail: UILabel!
    @IBOutlet var tbleview: UITableView!
    let cellId = "cellId"
    var userDetail:Githubuser? {
        didSet {
//            ConfigView()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tbleview.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        ConfigView()
        callWebServiceUserFollower(user: (userDetail?.login)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func optionAction(_ sender: Any) {
        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            callWebServiceUserFollower(user: (userDetail?.login)!)
        case 1:
            callWebServiceUserFollowing(user: (userDetail?.login)!)
        default:
            break
        }
    }
    func ConfigView() {
        self.title = "Details"
        lblname.text = userDetail?.login
        lblemail.text = "Score:\(userDetail?.score ?? 0.0)"
        if let image = userDetail?.avatarUrl {
            avatar.loadImageWith(imgUrl: image, placeHolder: nil)
        }
        
    }



}
extension DetailViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayfollowers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = arrayfollowers[indexPath.row].login
        
        cell.imageView?.layer.masksToBounds = false
        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.height)!/2
        cell.imageView?.clipsToBounds = true
        
        if let image = arrayfollowers[indexPath.row].avatarUrl {
            cell.imageView?.loadImageWith(imgUrl: image, placeHolder: nil)
        }
        return cell
    }
    
}
extension DetailViewController {
    func callWebServiceUserFollower(user:String){
        
        let url:String=Endpoint.userfollower(userStr: user).urlString()
        print(url)
        
        _ = WebServiceManager.call(requestMethod: .get, serviceURL: url, params: nil, includeAccessToken: true, completion: { (response, error) in
            
            if (response != nil) {
                if (response?.response?.statusCode == ServerResponseStatusCode.kOK) && (response!.result.value != nil) {
                   
                    self.arrayfollowers.removeAll()
                    let responseData = JSON(response!.result.value!).arrayValue
                  
//                    let resultData = responseData[DateResponseKey.kResult].arrayValue
                    for jsonUnit in responseData {
                        self.arrayfollowers.append(Githubuser(fromJson:jsonUnit))
                    }
                    self.tbleview.reloadData()
                    
                    
                    
                    
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
    func callWebServiceUserFollowing(user:String){
        
        let url:String=Endpoint.userfollowing(userStr: user).urlString()
        
        _ = WebServiceManager.call(requestMethod: .get, serviceURL: url, params: nil, includeAccessToken: true, completion: { (response, error) in
            
            if (response != nil) {
                if (response?.response?.statusCode == ServerResponseStatusCode.kOK) && (response!.result.value != nil) {
                    self.arrayfollowers.removeAll()
                    let responseData = JSON(response!.result.value!).arrayValue
                  
//                    let resultData = responseData[DateResponseKey.kResult].arrayValue
                    for jsonUnit in responseData {
                        self.arrayfollowers.append(Githubuser(fromJson:jsonUnit))
                    }
                    
                    self.tbleview.reloadData()
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
