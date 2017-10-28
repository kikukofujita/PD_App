//
//  SettingViewController.swift
//  PD
//
//  Created by 藤田貴久子 on 2017/10/17.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth
import SVProgressHUD

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    
    var list: [List] = []

    // Tableで使用する配列を定義
    let densityList: Array = ["廃液", "1.5ダイアニール", "エクストラニール"]
    let volumeList: Array = ["0", "1500"]
    
    // Sectionで使用する配列を定義
    let sectionList: Array = ["濃度", "容量"]
    
    // ログアウトボタンをタップしたときに呼ばれるメソッド

    @IBAction func handleLogoutButton(_ sender: Any) {
        print("DEBUG: ログアウトボタンをタップ")
        // ログアウトする
        try! Auth.auth().signOut()
        print("DEBUG: ログアウトしました。")
        
        // ログイン画面を表示する
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
        
        // ログイン画面から戻ってきたときのためにホーム画面（index= 0)を選択している状態にしておく
        let tabBarController = parent as! ESTabBarController
        tabBarController.setSelectedIndex(0, animated: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Cell名の登録
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibD = UINib(nibName: "densityTableViewCell", bundle: nil)
        tableView.register(nibD, forCellReuseIdentifier: "CellD")
        let nibV = UINib(nibName: "volumeTableViewCell", bundle: nil)
        tableView.register(nibV, forCellReuseIdentifier: "CellV")
        
        tableView.rowHeight = UITableViewAutomaticDimension

        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Sectionの数を返す
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    // Sectionのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionList[section]
    }
    
    // Cellが選択された際に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            print("Value: \(densityList[indexPath.row])")
        } else if indexPath.section == 1 {
            print("Value: \(volumeList[indexPath.row])")
        }
    }
    
    // テーブルに表示する配列の総数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // density
        if section == 0 {
            return densityList.count
        }
        // volume
        else {
            return volumeList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    // Cellに値を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // density
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellD", for: indexPath as IndexPath) as! densityTableViewCell
            cell.densityLabel.text = densityList[indexPath.row]
            return cell
        }
        // volumeList 
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellV", for: indexPath as IndexPath) as! volumeTableViewCell
            cell.volumeLabel.text = volumeList[indexPath.row]
            return cell
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
