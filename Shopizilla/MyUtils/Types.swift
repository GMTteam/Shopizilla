//
//  Types.swift
//  Shopizilla
//
//  Created by Anh Tu on 02/04/2022.
//

import UIKit
import SystemConfiguration
import CoreData

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

///Kích thước mặc định 960x1440 px
///imageHeightRatio: dùng để tính chiều cao Image của Product
let imageHeightRatio: CGFloat = 1440/1080

let defaultColor = UIColor(hex: 0x121212)
let separatorColor = UIColor.lightGray.withAlphaComponent(0.4)

///Khoảng cách từ nút Bag của thanh TabBar
var spBottom: CGFloat {
    return (15/315) + ((screenWidth * (200/1000))/2) + 20
}

///Font chung cho UIButton
let btnFont = UIFont(name: FontName.ppBold, size: 16.0)!

var appURL: String {
    return "https://itunes.apple.com/app/id\(WebService.shared.getAPIKey().appID)"
}

let appDL = UIApplication.shared.delegate as! AppDelegate
//let sceneDL = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
var sceneDL: SceneDelegate! {
    return UIApplication.shared.connectedScenes
        .compactMap({ $0 as? UIWindowScene })
        .first?.delegate as? SceneDelegate
}

//let kWindow = sceneDL.window!.windowScene!.windows.first!
var kWindow: UIWindow! {
    return UIApplication.shared.connectedScenes
        .compactMap({ ($0 as? UIWindowScene)?.windows.first(where: { $0.isKeyWindow }) })
        .first
}

let defaults = UserDefaults.standard
let deviceUUID = UIDevice.current.identifierForVendor!.uuidString

var topPadding: CGFloat {
    return kWindow?.safeAreaInsets.top ?? (appDL.isIPhoneX ? 47 : 0)
}

var bottomPadding: CGFloat {
    return kWindow?.safeAreaInsets.bottom ?? (appDL.isIPhoneX ? 34 : 0)
}

var statusH: CGFloat {
    return kWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? (appDL.isIPhoneX ? 44 : 20)
}

public func removeObserverBy(observer: Any?) {
    if let observer = observer {
        NotificationCenter.default.removeObserver(observer)
    }
}

///Thay đổi vị trí của 'element' trong 'array'
public func rearrange<T>(array: Array<T>, fromIndex: Int, toIndex: Int) -> Array<T> {
    var arr = array
    let element = arr.remove(at: fromIndex)
    arr.insert(element, at: toIndex)
    return arr
}

public func createStackView(spacing: CGFloat, distribution: UIStackView.Distribution, axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment) -> UIStackView {
    let sv = UIStackView()
    sv.spacing = spacing
    sv.distribution = distribution
    sv.axis = axis
    sv.alignment = alignment
    sv.translatesAutoresizingMaskIntoConstraints = false
    
    return sv
}

///NSAttributedString.Key for UIButton
public func createAttributedString(fgColor: UIColor) -> [NSAttributedString.Key: Any] {
    let att: [NSAttributedString.Key: Any] = [
        .font: btnFont,
        .foregroundColor: fgColor
    ]
    return att
}

///NSMutableAttributedString for UIButton
public func createMutableAttributedString(fgColor: UIColor, txt: String) -> NSMutableAttributedString {
    let att = createAttributedString(fgColor: fgColor)
    let attr = NSMutableAttributedString(string: txt, attributes: att)
    return attr
}

public func setupTitleForBtn(_ btn: UIButton, txt: String, bgColor: UIColor, fgColor: UIColor) {
    let attr = createMutableAttributedString(fgColor: fgColor, txt: txt)
    btn.setAttributedTitle(attr, for: .normal)
    btn.backgroundColor = bgColor
}

///Tạo LeftMenuView
func createLeftView(_ menuBtn: ButtonAnimation) -> UIView {
    let frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
    
    //TODO: - LeftView
    let leftView = UIView(frame: frame)
    leftView.clipsToBounds = true
    leftView.backgroundColor = .clear
    
    //TODO: - MenuBtn
    menuBtn.frame = frame
    menuBtn.clipsToBounds = true
    menuBtn.setImage(UIImage(named: "icon-menuLeft")?.withRenderingMode(.alwaysTemplate), for: .normal)
    menuBtn.tintColor = defaultColor
    menuBtn.tag = 0
    leftView.addSubview(menuBtn)
    
    return leftView
}

///Tạo BagView
func createRightView(_ bagBtn: ButtonAnimation, _ badgeLbl: UILabel) -> UIView {
    let frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
    
    //TODO: - RightView
    let rightView = UIView(frame: frame)
    rightView.clipsToBounds = true
    rightView.backgroundColor = .clear
    
    //TODO: - BagBtn
    bagBtn.frame = frame
    bagBtn.clipsToBounds = true
    bagBtn.setImage(UIImage(named: "icon-bagRight")?.withRenderingMode(.alwaysTemplate), for: .normal) //icon-bagCenter
    bagBtn.tintColor = defaultColor
    bagBtn.tag = 1
    rightView.addSubview(bagBtn)
    
    //TODO: - BadgeLbl
    let badgeH: CGFloat = 12.0
    badgeLbl.frame = CGRect(x: 40-14, y: 2.0, width: badgeH, height: badgeH)
    badgeLbl.font = UIFont(name: FontName.ppBold, size: 7.0)
    badgeLbl.textColor = .white
    badgeLbl.textAlignment = .center
    badgeLbl.backgroundColor = defaultColor
    badgeLbl.clipsToBounds = true
    badgeLbl.layer.cornerRadius = badgeH/2
    badgeLbl.isHidden = true
    rightView.insertSubview(badgeLbl, aboveSubview: bagBtn)
    
    return rightView
}

//MARK: - Shadow -
public func setupShadow(_ view: UIView, radius: CGFloat = 2.0, opacity: Float = 0.2) {
    view.layer.masksToBounds = false
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
    view.layer.shadowRadius = radius
    view.layer.shadowOpacity = opacity
    view.layer.shouldRasterize = true
    view.layer.rasterizationScale = UIScreen.main.scale
}

public func createNoItems(view: UIView, txt: String = "No Items") -> UILabel {
    let noItemsLbl = UILabel()
    noItemsLbl.isHidden = true
    noItemsLbl.font = UIFont(name: FontName.ppBold, size: 18.0)
    noItemsLbl.text = txt
    noItemsLbl.textColor = .black
    noItemsLbl.textAlignment = .center
    view.addSubview(noItemsLbl)
    noItemsLbl.translatesAutoresizingMaskIntoConstraints = false
    
    noItemsLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    noItemsLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
    return noItemsLbl
}

func createDateFormatter() -> DateFormatter {
    let f = DateFormatter()
    f.locale = .current //Locale(identifier: "en_US_POSIX")
    return f
}

///yyyyMMddHHmmss
func longFormatter() -> DateFormatter {
    let f = createDateFormatter()
    f.dateFormat = "yyyyMMddHHmmss"
    return f
}

//MARK: - Text(k) -
func kText(_ num: Double) -> String {
    var txt: String {
        if num >= 1000 && num < 999999 {
            return String(format: "%0.1fK", locale: .current, num/1_000)
                .replacingOccurrences(of: ".0", with: "")
        }
        
        if num > 999999 {
            return String(format: "%0.1fM", locale: .current, num/1_000_000)
                .replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%0.0f", locale: .current, num)
    }
    
    return txt
}

func getPath() {
    let fileManager = FileManager.default
    let urls = fileManager.urls(for: .libraryDirectory, in: .userDomainMask)
    print("*** CoreData: \(urls[0].path)")
}

///Kiểm tra Internet có đang hoạt động ko
func isInternetAvailable() -> Bool {
    var zeroAddr = sockaddr_in()
    zeroAddr.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddr))
    zeroAddr.sin_family = sa_family_t(AF_INET)
    
    let reachability = withUnsafePointer(to: &zeroAddr, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddr in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddr)
        }
    })
    
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(reachability!, &flags) { return false }
    let reachable = flags.contains(.reachable)
    let connection = flags.contains(.connectionRequired)
    return reachable && !connection
}

public func delay(duration: TimeInterval, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: completion)
}

///Đánh giá App ngay tại bên trong App
func ratingAndReview() {
    guard let url = URL(string: appURL) else { return }
    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    components?.queryItems = [URLQueryItem(name: "action", value: "write-review")]

    guard let writeReview = components?.url else { return }
    UIApplication.shared.open(writeReview, options: [:], completionHandler: nil)
}

//MARK: - BorderView - Tạo hoạt ảnh khi gõ sai
public func setupAnimBorderView(_ view: UIView) {
    let posAnim = CABasicAnimation(keyPath: "position.x")
    posAnim.fromValue = view.center.x + 2.0
    posAnim.toValue = view.center.x - 2.0
    
    let borderAnim = CASpringAnimation(keyPath: "borderColor")
    borderAnim.damping = 5.0
    borderAnim.initialVelocity = 10.0
    borderAnim.toValue = UIColor(hex: 0xFF755F).cgColor
    
    let animGroup = CAAnimationGroup()
    animGroup.duration = 0.1
    animGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)
    animGroup.autoreverses = true
    animGroup.animations = [posAnim, borderAnim]
    
    view.layer.add(animGroup, forKey: nil)
    view.layer.borderColor = UIColor(hex: 0xFF755F).cgColor
}

//MARK: - BorderView - Thay đổi màu cho viền
public func borderView(_ view: UIView, color: UIColor = .white) {
    view.layer.borderColor = color.cgColor
}
