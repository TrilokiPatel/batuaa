//
//  GlobalVariable.swift
//  batuaa
//
//  Created by Trilok Patel on 10/07/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import Foundation
class GlobalVariable {
    private init() { }
    static let sharedInstance = GlobalVariable()
    var userDataInfo = [UserData]()
    var allCurrencyArray = [AllCurrencyData]()
    var exchangeModelData: GetLiveMarketData?
    var marketData: MarketOrderData?
    var buyMyOrder = [MarketOrderBUY]()
    var sellMyOrder = [MarketOrderSELL]()
    var maketCoinName = [String]()
    
    
    
    var exchageCoinName = ""
    var exchangeMarketId = ""
    var exchangeTabselectedIndex = 0
    var backFrom = ""
    var tabSelectedIndex = 0
    var buySellselectedIndex = 0
    var showBack = false
    var fromOrders = false
    var selctedRowBuyOrSell = false
    var appLock = false
    
    
}
