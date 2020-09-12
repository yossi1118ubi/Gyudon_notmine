//
//  ViewController.swift
//  Gyudon_notmine
//
//  Created by Daichi Yoshikawa on 2020/09/12.
//  Copyright © 2020 Daichi Yoshikawa. All rights reserved.
//

import UIKit
//HTTP通信してくれるやつ
import Alamofire
//スクレイピングしてくれるやつ
import Kanna


class ViewController: UIViewController, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beefbowl.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gyudonCell", for: indexPath)

        let gyudon = self.beefbowl[indexPath.row]
        cell.textLabel?.text = gyudon.size
        cell.detailTextLabel?.text = gyudon.price

        return cell
    }
    
    var beefbowl = [Gyudon]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getGyudonPrice()
        //Table ViewのdataSourceを設定
        tableView.dataSource = self
    }
    
    func getGyudonPrice(){
        //スクレイピング対象のサイトを指定
        Alamofire.request("https://www.yoshinoya.com/menu/gyudon/gyu-don/").responseString{
            response in
            if let html = response.result.value{
                if let doc = try? HTML(html: html, encoding: .utf8){
                
                    //牛丼のサイズをXpathで指定
                    var sizes = [String]()
                    for link in doc.xpath("//th[@class='menu-size']"){
                        sizes.append(link.text ?? "")
                    }
                    //牛丼の値段をXpathで習得
                    var prices = [String]()
                    for link in doc.xpath("//td[@class='menu-price']"){
                        prices.append(link.text ?? "")
                    }
                    
                    //牛丼のサイズ分だけループ
                    for (index, value) in sizes.enumerated(){
                        let gyudon = Gyudon()
                        gyudon.size = value
                        gyudon.price = prices[index]
                        self.beefbowl.append(gyudon)
                    }
                    
                    self.tableView.reloadData()
                    
                }
            }
        }
    }


}


//牛丼オブジェクト
class Gyudon: NSObject {
    var size: String = ""
    var price: String = ""
}

