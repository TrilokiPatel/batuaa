import UIKit

class Helper {
    static var app: Helper = {
        return Helper()
    }()
    
//    var viewContoller: UIViewController?
    
    func navigateController(ViewController: String, navVC: UINavigationController, storyboard: UIStoryboard, animated: Bool = true ) {
        let vc = storyboard.instantiateViewController(withIdentifier: ViewController)
//        viewContoller = vc
        navVC.pushViewController(vc, animated: animated)
        
    }
    
    func backViewContoller(navVC: UINavigationController, animated: Bool = true) {
        navVC.popViewController(animated: animated)
        
    }
    
    func makeOtherRootViewContoller(ViewController: String, storyBoard: UIStoryboard) {
        let vc = storyBoard.instantiateViewController(withIdentifier: ViewController)
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func makeOtherRootViewContollerWithAnimation(ViewController: String, storyBoard: UIStoryboard, animated: Bool = true) {
        let vc = storyBoard.instantiateViewController(withIdentifier: ViewController)
        guard animated, let window = UIApplication.shared.windows.first else {
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            return
        }
    
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.1,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
    
    
    
    func twoColorAndFont(fontName1: String, size1: CGFloat, fontName2: String, size2: CGFloat, firstString: String, secondString: String,firstColor: String, SecondColor: String) -> NSAttributedString {
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: fontName1, size: size1), NSAttributedString.Key.foregroundColor : UIColor(hexString: firstColor)]

        let attrs2 = [NSAttributedString.Key.font : UIFont(name: fontName2, size: size2), NSAttributedString.Key.foregroundColor : UIColor.init(hexString: SecondColor)]

        let attributedString1 = NSMutableAttributedString(string:firstString, attributes:attrs1 as [NSAttributedString.Key : Any])

        let attributedString2 = NSMutableAttributedString(string:secondString, attributes:attrs2 as [NSAttributedString.Key : Any])

        attributedString1.append(attributedString2)
        return attributedString1
        
    }
    func URLforRoute(route: String,params:[String: Any]) -> NSURL? {
    if let components: NSURLComponents  = NSURLComponents(string: route){
        var queryItems = [NSURLQueryItem]()
        for(key,value) in params {
            queryItems.append(NSURLQueryItem(name:key,value: "\(value)"))
        }
        components.queryItems = queryItems as [URLQueryItem]?
        return components.url as NSURL?
    }
    return nil
    }
    
    func setSelectedIndexTabar(index: Int) {
        let myTabBar = UIApplication.shared.windows.first?.rootViewController as? TabbarController
        myTabBar?.selectedIndex = index
            
    }
    func swapRootViewController() {
       /* guard let appDelegate = UIApplication.shared.delegate,
            let appDelegateWindow = appDelegate.window,
            let appDelegateView = window.rootViewController?.view,
            let viewContollersView = viewController.view else {
            return
        }
        viewContollersView.frame = (appDelegateWindow?.bounds)!
        appDelegate.window??.addSubview(viewContollersView)
        let transition = CATransition()
        transition.startProgress = 0
        transition.endProgress = 1.0
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.duration = 0.35
        appDelegateView.layer.add(transition, forKey: "transition")
        viewContollersView.layer.add(transition, forKey: "transition")
        appDelegateView.isHidden = true
        viewContollersView.isHidden = false
        appDelegateWindow?.rootViewController = viewController*/
    }
    func setGradient(view: UIView!, color1: UIColor!, color2: UIColor!, angle: Double!, alphaValue: CGFloat!){
        let gradient = CAGradientLayer()
        
        gradient.frame =  CGRect(origin: CGPoint.zero, size: view.frame.size)
        
        gradient.colors = [color1.withAlphaComponent(alphaValue).cgColor, color2.withAlphaComponent(alphaValue).cgColor]
        let x: Double! = angle / 360.0
        let a = pow(sin(Float(2.0 * .pi * ((x + 0.75) / 2.0))),2.0);
        let b = pow(sin(Float(2 * .pi * ((x+0.0)/2))),2);
        let c = pow(sin(Float(2 * .pi * ((x+0.25)/2))),2);
        let d = pow(sin(Float(2 * .pi * ((x+0.5)/2))),2);
        
        gradient.startPoint = CGPoint(x: CGFloat(c),y: CGFloat(d))
        gradient.endPoint = CGPoint(x: CGFloat(a),y:CGFloat(b))
        view.layer.insertSublayer(gradient, at: 0)
    }
    func attributedTwoText(withString narmalString: String, boldString: String) -> NSAttributedString {
        
        let attributes1: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont(name: "Muli-Regular", size: 12.0) ?? UIFont.systemFont(ofSize: 12)]
        let attributes2: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.init(hexString: "#000000"), .font: UIFont(name: "Muli-Semibold", size: 14.0) ?? UIFont.systemFont(ofSize: 12)]
        

        let partOne = NSMutableAttributedString(string: narmalString, attributes: attributes1 as [NSAttributedString.Key : Any])
        let partTwo = NSMutableAttributedString(string: boldString, attributes: attributes2 as [NSAttributedString.Key : Any])

        let combination = NSMutableAttributedString()
        combination.append(partTwo)
        combination.append(partOne)
        
        return combination
    }
    func dateTimeformatConverter(_ format:String) -> String {
       let formatter = Foundation.DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date1  = formatter.date(from: format)
        print("date:\(String(describing: date1))")
        formatter.dateFormat = "dd MMM YYYY, h:mm a"
        let resultTime = formatter.string(from: date1!)
        print("time:\(String(describing: resultTime))")
        return resultTime
    }
    func getDateDiff(start: Date, end: Date) -> Int  {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([Calendar.Component.second], from: start, to: end)

        let seconds = dateComponents.second
        return Int(seconds!)
    }
    func getPlace(currencyName: String) -> Int {
        if ConfigFile.sharedInstance.currencyPriceDecimals.keys.contains(currencyName){
            return ConfigFile.sharedInstance.currencyPriceDecimals[currencyName]!
        } else {
            return ConfigFile.sharedInstance.defaultDecimal
        }
    }
    func getCurrencyCode() -> [String] {
        let marketName = (GlobalVariable.sharedInstance.exchangeModelData?.marketName)!
        let currencyName = marketName.components(separatedBy: "-")
        return currencyName
    }
    func formatToPointString(currncyCode: String, currencyData: String) -> String {
        let place = Helper.app.getPlace(currencyName: currncyCode)
        let value1 = Double(currencyData)?.roundToDecimal(place)
        let string = String(format:"%.\(place)f", value1!)
        return string
    }
  
}
