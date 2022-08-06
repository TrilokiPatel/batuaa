//
//  ExchangeVC.swift
//  batuaa
//
//  Created by Trilok Patel on 23/04/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import UIKit
import ViewAnimator

class ExchangeVC: UIViewController {
    
    @IBOutlet weak var segmentControl: HSegmentControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ExchangeViewModel?
    var dataSource: ExchangeTableDataSource?
    var initiallyAnimates = false
    var segmetTitle = ["ALL"]
    var delegateModel: OrderBookViewModel?
    var exchangeTimer: Timer?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewModel = ExchangeViewModel(viewDelegate: self)
        self.dataSource = ExchangeTableDataSource(viewModel: self.viewModel!, delegate: self)
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self.dataSource
        self.tableView?.register(UINib(nibName: "ExchangeTableCell", bundle: nil), forCellReuseIdentifier: "ExchangeTableCell")
        self.tableView.addSubview(refreshControl)
        segmentControl.selectedTitleFont = UIFont(name: "Muli-SemiBold", size: 12) ?? UIFont.systemFont(ofSize: 12)
        segmentControl.unselectedTitleFont = UIFont(name: "Muli-SemiBold", size: 12) ?? UIFont.systemFont(ofSize: 12)
        segmentControl.unselectedTitleColor = .white
        segmentControl.dataSource = self
        let value = Int(self.segmentControl.frame.width / 60)
        segmentControl.numberOfDisplayedSegments = value
        segmentControl.segmentIndicatorView.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.mlive24Socket), name: NSNotification.Name(rawValue: "mlive24"), object: nil)
        GlobalVariable.sharedInstance.tabSelectedIndex = 0
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "mlive24"), object: nil)
    }
    
    @objc func mlive24Socket(_ notification: NSNotification) {
        if let dict = notification.userInfo?["mlive24"] as? NSDictionary? {
            if dict != nil {
                let jsonData = try! JSONSerialization.data(withJSONObject: dict as AnyObject, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let decodedObject: GetLiveMarketData  = try! JSONDecoder().decode(GetLiveMarketData.self, from: jsonData)
                let checkValue = self.viewModel?.exchangeData.contains{$0.marketId == dict?["marketId"] as? String}
                if checkValue! {
                    let index =  self.viewModel?.allExchangeData.firstIndex{$0.marketId == dict?["marketId"] as? String}
                    self.viewModel?.allExchangeData[index!] = decodedObject
                    let selectedindex = segmentControl.selectedIndex
                    let title: String = segmetTitle[selectedindex]
                    self.viewModel?.segmentControltab(index: selectedindex, title: title)
                }
                
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
       
        let index = segmentControl.selectedIndex
        let title = segmetTitle[index]
        self.viewModel?.restApiAllCurrency(parameter: [:],index: index, title: title,loder: true)
        if UserDefaultsManager.userdefault.retriveBoolValue(key.UserDefaults.k_User_logged_In) {
            self.viewModel?.restApiGetUser(parameter: [:])
        }
        ConfigFile.sharedInstance.timeSocketmlive24 = Date() as NSDate
        exchangeTimer = Timer.scheduledTimer(timeInterval: TimeInterval(ConfigFile.sharedInstance.timerTime), target: self, selector: #selector(runAPIbyTimer), userInfo: nil, repeats: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.exchangeTimer?.invalidate()
        self.exchangeTimer = nil
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        let index = segmentControl.selectedIndex
        let title = segmetTitle[index]
        self.viewModel?.restApiAllCurrency(parameter: [:],index: index,title: title, loder: false)
        if UserDefaultsManager.userdefault.retriveBoolValue(key.UserDefaults.k_User_logged_In) {
            self.viewModel?.restApiGetUser(parameter: [:])
        }
        
        refreshControl.endRefreshing()
    }
    @objc func runAPIbyTimer() {
        print("Eachange Timer")
        if Helper.app.getDateDiff(start: ConfigFile.sharedInstance.timeSocketmlive24! as Date, end: Date()) >= ConfigFile.sharedInstance.differneceTime {
            print(Helper.app.getDateDiff(start: ConfigFile.sharedInstance.timeSocketmlive24! as Date, end: Date()))
            ConfigFile.sharedInstance.timeSocketmlive24 = Date() as NSDate
            let index = segmentControl.selectedIndex
            let title = segmetTitle[index]
            self.viewModel?.restApiAllCurrency(parameter: [:],index: index,title: title, loder: false)
            if UserDefaultsManager.userdefault.retriveBoolValue(key.UserDefaults.k_User_logged_In) {
                self.viewModel?.restApiGetUser(parameter: [:])
            }
        }
    }
   
    func convertinTime(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let time = dateFormatter.date(from:date)!
        return time
    }
    
    @IBAction func segmentValueChange(_ sender: HSegmentControl) {
        let title = segmetTitle[sender.selectedIndex]
        self.viewModel?.segmentControltab(index: sender.selectedIndex, title: title)

    }
    @IBAction func btnMenu(_ sender: Any) {
        if UserDefaultsManager.userdefault.retriveBoolValue(key.UserDefaults.k_User_logged_In) {
            Helper.app.navigateController(ViewController: "ProfileVC", navVC: self.navigationController!, storyboard: UIStoryboard(storyboard: .tabbar), animated: true)
            
            
        } else {
            Helper.app.makeOtherRootViewContollerWithAnimation(ViewController: "NavVC", storyBoard: UIStoryboard(storyboard: .main))
            
        }
        
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        searchVC.modalPresentationStyle = .overCurrentContext
        searchVC.modalTransitionStyle = .crossDissolve
        searchVC.tab = self.tabBarController as? TabbarController
        searchVC.totalArray = self.viewModel?.exchangeData ?? []
        self.definesPresentationContext = true
        self.tabBarController!.present(searchVC, animated: true, completion: nil)

    }
    

}
extension ExchangeVC: reloadExchangeTableViewDelegate {
    func reloadTableView(index: Int) {
        
    }
    
    func reloadTableView() {
        if let value1 = self.viewModel?.allExchangeData, value1.count > 0 {
            GlobalVariable.sharedInstance.maketCoinName = self.viewModel?.allExchangeData.map({($0.marketName! )}) ?? []
            APISocketMarket.shared.establishConnection()
            if UserDefaultsManager.userdefault.retriveBoolValue(key.UserDefaults.k_User_logged_In) {
                APISocketWallet.shared.establishConnection()
            }
            
            let arr1 = (self.viewModel?.allExchangeData.map({$0.marketName?.split(separator: "-")[0]}))?.removingDuplicates()
            if let arr = arr1, arr.count > 0 {
                arr.forEach { (test) in
                    if segmetTitle.contains(String(test ?? "")) {
                    } else {
                        segmetTitle.append(String(test ?? "").uppercased())
                    }
                }
            }
            segmentControl.dataSource = self
            segmentControl.segmentIndicatorView.backgroundColor = .white
            
            self.tableView.reloadData()
            
        }
        
        
    }
    
    
}
extension ExchangeVC: ExchangeSorceDelegate {
    func openViewController(withName: String, coinName: String) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Tabbar", bundle: nil)
        if withName == "OrderBook" {
           let popupVC = storyboard.instantiateViewController(withIdentifier: "OrderBookVC") as! OrderBookVC
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
//            popupVC.coinName = coinName
            self.definesPresentationContext = true
            self.tabBarController!.present(popupVC, animated: true, completion: nil)
        } else if withName == "TradeHistory" {
            let popupVC = storyboard.instantiateViewController(withIdentifier: "TradeHistoryVC") as! TradeHistoryVC
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            popupVC.marketId = coinName
            self.definesPresentationContext = true
            self.tabBarController!.present(popupVC, animated: true, completion: nil)
        } else if withName == "BuySell" {
            
        
            let popupVC = storyboard.instantiateViewController(withIdentifier: "BuySellVC") as! BuySellVC
           
            self.navigationController?.pushViewController(popupVC, animated: true)
            
            
        }
        
        
    }
}

extension ExchangeVC: HSegmentControlDataSource {
    func numberOfSegments(_ segmentControl: HSegmentControl) -> Int {
        return segmetTitle.count
    }
    
    func segmentControl(_ segmentControl: HSegmentControl, titleOfIndex index: Int) -> String {
        return segmetTitle[index]
    }
    
    
    func segmentControl(_ segmentControl: HSegmentControl, segmentBackgroundViewOfIndex index: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
}
