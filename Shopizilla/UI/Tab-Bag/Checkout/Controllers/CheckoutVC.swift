//
//  CheckoutVC.swift
//  Shopizilla
//
//  Created by Anh Tu on 01/05/2022.
//

import UIKit
import Stripe
import PassKit

class CheckoutVC: UIViewController {
    
    //MARK: - Properties
    private let separatorView = UIView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    let bottomView = CheckoutBottomView()
    
    var address: Address?
    var promoCode: PromoCode? //Thanh toán
    var coin: Double = 0.0 //Thanh toán
    var hud: HUD?
    
    private var total: Double = 0.0
    
    //ApplePay
    private var applePaySuccess = false
    private var paymentID = ""
    
    //PayPal
    private var headerValue: String?
    private var payPalOrderID: String?
    private var payPalObserver: Any?
    
    private var viewModel: CheckoutViewModel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObserver()
        
        viewModel.getShippingMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        if hud == nil && viewModel.shippingMethods.count == 0 {
            hud = HUD.hud(view)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            removeObserverBy(observer: payPalObserver)
        }
    }
}

//MARK: - Setups

extension CheckoutVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Checkout".localized()
        
        viewModel = CheckoutViewModel(vc: self)
        
        //TODO: - SeparatorView
        setupSeparatorView(view: view, separatorView: separatorView)
        
        //TODO: - TableView
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.rowHeight = 80.0
        tableView.register(CheckoutTVCell.self, forCellReuseIdentifier: CheckoutTVCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        //TODO: - BottomView
        bottomView.isHidden = true
        view.addSubview(bottomView)

        bottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        bottomView.orderBtn.delegate = self
        bottomView.orderBtn.tag = 1

        bottomView.setupTxtForBtn("Place Order".localized())
        
        //let bottomH: CGFloat = (appDL.isIPhoneX ? 39 : 0) + 70 + 50
        //tableView.contentInset.bottom = bottomH
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            bottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -10.0),
        ])
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - Add Observer

extension CheckoutVC {
    
    private func addObserver() {
        payPalObserver = NotificationCenter.default.addObserver(forName: .payPalKey, object: nil, queue: nil) { notif in
            guard notif.object as? String == "success" else {
                self.hud?.removeHUD {}
                self.headerValue = nil
                self.payPalOrderID = nil
                
                self.showAlert(title: "Canceled".localized(), mes: "Payment failed".localized()) {}
                
                return
            }
            
            guard let orderID = self.payPalOrderID, let headerValue = self.headerValue else {
                self.hud?.removeHUD {}
                return
            }
            
            PayPalAPIClient.shared.capturePaymentForOrder(headerValue: headerValue, orderID: orderID) { success in
                self.hud?.removeHUD {}
                self.placeOrder(isPaid: true, paymentID: self.payPalOrderID ?? "")
                
                self.headerValue = nil
                self.payPalOrderID = nil
                
                print("*** PAYPAL SUCCESSFULLY")
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension CheckoutVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? viewModel.shippingMethods.count : viewModel.paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheckoutTVCell.id, for: indexPath) as! CheckoutTVCell
        
        if indexPath.section == 0 {
            viewModel.checkoutTVCellSec1(cell, indexPath: indexPath)
            
        } else {
            viewModel.checkoutTVCellSec2(cell, indexPath: indexPath)
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension CheckoutVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            viewModel.selectedShipping = viewModel.shippingMethods[indexPath.row]
            viewModel.updateTotal()
            reloadData()
            
        } else {
            viewModel.selectedPayment = viewModel.paymentMethods[indexPath.row]
            bottomView.setupAlpha(viewModel.selectedShipping != nil && viewModel.selectedPayment != nil)
            reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let r = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 60.0)
        let headerView = UIView(frame: r)
        headerView.backgroundColor = UIColor(hex: 0xF6F6F6)
        
        let titleLbl = UILabel(frame: CGRect(x: 20.0, y: 15.0, width: screenWidth-40, height: 30.0))
        titleLbl.font = UIFont(name: FontName.ppBold, size: 16.0)
        titleLbl.textColor = .darkGray
        headerView.addSubview(titleLbl)
        
        var txt: String = ""
        if section == 0 {
            headerView.isHidden = viewModel.shippingMethods.count == 0
            
            if viewModel.shippingMethods.count != 0 {
                txt = "Shipping method".uppercased().localized()
            }
            
        } else {
            headerView.isHidden = viewModel.paymentMethods.count == 0
            
            if viewModel.paymentMethods.count != 0 {
                txt = "Payment methods".uppercased().localized()
            }
        }
        
        titleLbl.text = txt
        
        return headerView
    }
}

//MARK: - ButtonAnimationDelegate

extension CheckoutVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 1 { //Order
            guard let selectedPayment = viewModel.selectedPayment else {
                return
            }
            
            switch selectedPayment.index {
            case 0: //Cash On Delivery
                placeOrder(isPaid: false, paymentID: paymentID)
                
            case 1: //Apple Pay
                applePay()
                
            case 2: //Credit card
                let vc = CreditCardVC()
                vc.delegate = self

                let navi = NavigationController(rootViewController: vc)
                navi.modalPresentationStyle = .fullScreen
                present(navi, animated: true)
                
            case 3: //"PayPal"
                payPal()
                
            default: break
            }
        }
    }
}

//MARK: - PlaceOrder

extension CheckoutVC {
    
    private func placeOrder(isPaid: Bool, paymentID: String) {
        guard let selectedShipping = viewModel.selectedShipping else {
            return
        }
        guard let selectedPayment = viewModel.selectedPayment else {
            return
        }
        
        hud = HUD.hud(kWindow)
        
        let f = createDateFormatter()
        f.dateFormat = "yyMMdd"
        
        let uuid = UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(8).uppercased()
        let orderID = f.string(from: Date()) + String(Array(uuid).shuffled())
        
        var dict: [String: Any] = [
            "paymentMethod": selectedPayment.name,
            "orderDate": longFormatter().string(from: Date()),
            "status": "1", //Đã đặt hàng
            "isPaid": isPaid, //Đã thanh toán chưa
            "orderID": orderID,
            "paymentID": paymentID,
        ]
        
        var fee = selectedShipping.fee
        
        if let promoCode = promoCode {
            dict["promoCode"] = promoCode.uid
            
            if promoCode.type == PromoCode.PromoType.Discount.rawValue {
                dict["percentPromotion"] = promoCode.percent //Phần trăm giảm
            }
            
            if promoCode.type == PromoCode.PromoType.Freeship.rawValue {
                fee = selectedShipping.fee * ((100 - promoCode.percent)/100)
            }
            
            //Cập nhật cho Promo Code
            promoCode.updatePromoCode {}
        }
        
        if coin != 0.0 {
            dict["coin"] = coin //Số coin trong ví
            
            //Cập nhật số coin trong ví. Trừ đi, vì đã sử dụng
            if let currentUser = appDL.currentUser {
                currentUser.updateCoin(coin: -coin) {}
            }
        }
        
        dict["shippingFee"] = fee //Phí vận chuyển
        
        if let address = address {
            dict["addressID"] = address.uid
        }
        
        let array = appDL.shoppings

        for i in 0..<array.count {
            let shopping = array[i]
            shopping.model.address = address

            shopping.updateShoppingCart(dict: dict) {
                shopping.saveAddress {
                    if i == array.count - 1 {
                        self.hud?.removeHUD {}

                        let vc = SuccessVC()
                        vc.orderID = orderID
                        vc.naviC = self.navigationController
                        vc.tabBarC = self.tabBarController

                        let navi = NavigationController(rootViewController: vc)
                        navi.modalPresentationStyle = .fullScreen

                        self.present(navi, animated: true, completion: nil)
                        
                        self.paymentID = ""
                        NotificationCenter.default.post(name: .placeOrderKey, object: nil)
                    }
                }
            }
        }
    }
}

//MARK: - Apple Pay

extension CheckoutVC {
    
    func applePay() {
        guard StripeAPI.deviceSupportsApplePay() else {
            showAlert(title: "Oops".localized() + "!", mes: "Device does not support Apple Pay".localized()) {}
            return
        }
        
        guard appDL.shoppings.count != 0 else { return }
        guard let shipping = viewModel.selectedShipping else { return }
        
        let id = WebService.shared.getAPIKey().applePayID
        let request = StripeAPI.paymentRequest(withMerchantIdentifier: id,
                                               country: CurrencyModel.shared.countryCode.rawValue,
                                               currency: CurrencyModel.shared.currency())
        //Chi tiết đơn hàng
        var items: [PKPaymentSummaryItem] = []
        
        for shopping in appDL.shoppings {
            let perc = (100 - shopping.saleOff)/100
            let newPrice = (shopping.total * perc)
            items.append(PKPaymentSummaryItem(label: shopping.name, amount: NSDecimalNumber(value: newPrice)))
        }
        
        //Bao gồm giảm giá...
        var subtotal = (appDL.shoppings.map({ $0.total * ((100 - $0.saleOff)/100) }).reduce(0, +))
        var fee = shipping.fee
        
        if let promoCode = promoCode {
            if promoCode.type == PromoCode.PromoType.Discount.rawValue {
                let sub = subtotal * (promoCode.percent/100)
                subtotal = subtotal - sub
                
                let amount = NSDecimalNumber(value: -sub)
                items.append(PKPaymentSummaryItem(label: "Discount \(promoCode.percent)%", amount: amount))
            }
            
            if promoCode.type == PromoCode.PromoType.Freeship.rawValue {
                fee = shipping.fee * ((100 - promoCode.percent)/100)
            }
        }
        
        //Phương thức vận chuyển
        let method = PKShippingMethod(label: shipping.name, amount: NSDecimalNumber(value: fee))
        method.identifier = "delivery"
        method.detail = "Arrives in 5-7 days"
        
        request.shippingMethods = [method]
        
        total = subtotal + fee - (coin/1000)
        guard total > 0.0 else { return }
        
        if coin != 0.0 {
            let amount = NSDecimalNumber(value: -(coin/1000))
            items.append(PKPaymentSummaryItem(label: "Use coin from wallet", amount: amount))
        }
        
        //... Phí và tổng tiền
        items.append(PKPaymentSummaryItem(label: "Shipping fee", amount: NSDecimalNumber(value: fee)))
        items.append(PKPaymentSummaryItem(label: "iOrder, Inc", amount: NSDecimalNumber(value: total)))
        
        request.paymentSummaryItems = items
        
        //Địa chỉ giao hàng
        guard let address = address else { return }
        let contact = PKContact()
        contact.phoneNumber = CNPhoneNumber(stringValue: address.phoneNumber)
        
        let addr = CNMutablePostalAddress()
        addr.street = address.street
        
        if address.ward != "" {
            addr.street = address.street + ", \(address.ward)"
        }
        
        addr.country = address.country
        addr.state = address.state
        addr.city = address.city
        addr.postalCode = ""
        
        contact.postalAddress = addr
        
        if let user = appDL.currentUser {
            contact.emailAddress = user.email
        }
        
        if #available(iOS 15, *) {
            contact.name = PersonNameComponents(givenName: address.fullName)
        }
        
        request.billingContact = contact
        
        //Các thẻ hỗ trợ
        request.supportedNetworks = [.amex, .visa, .masterCard]
        
        hud = HUD.hud(kWindow)
        
        if StripeAPI.canSubmitPaymentRequest(request),
            let vc = PKPaymentAuthorizationViewController(paymentRequest: request)
        {
            vc.delegate = self
            present(vc, animated: true)
            
        } else {
            hud?.removeHUD {}
            showAlert(title: "Oops".localized() + "!", mes: "There is a problem with your Apple Pay configuration".localized()) {}
        }
    }
}

//MARK: - PKPaymentAuthorizationViewControllerDelegate

extension CheckoutVC: PKPaymentAuthorizationViewControllerDelegate, STPAuthenticationContext {
    
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true) {
            self.hud?.removeHUD {}
            
            if self.applePaySuccess {
                self.applePaySuccess = false
                self.placeOrder(isPaid: true, paymentID: self.paymentID)
                print("*** APPLEPAY SUCCESSFULLY")
                
            } else {
                self.paymentID = ""
                self.showAlert(title: "Oops".localized() + "!", mes: "Error at checkout".localized()) {}
            }
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        submitToStripe(des: "Payment by Apple Pay".localized()) { clientSecret in
            STPAPIClient.shared.createPaymentMethod(with: payment) { (paymentMethod, error) in
                guard let paymentMethod = paymentMethod, error == nil else {
                    self.hud?.removeHUD {}
                    return
                }
                guard let clientSecret = clientSecret else {
                    self.hud?.removeHUD {}
                    return
                }
                
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                paymentIntentParams.paymentMethodId = paymentMethod.stripeId
                
                STPPaymentHandler.shared().confirmPayment(paymentIntentParams, with: self) { status, paymentIntent, error in
                    self.paymentID = paymentIntent?.paymentMethodId ?? ""
                    
                    switch status {
                    case .succeeded:
                        self.applePaySuccess = true
                        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                        
                    case .canceled:
                        completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                        
                    case .failed:
                        let errors = [STPAPIClient.pkPaymentError(forStripeError: error)].compactMap({ $0 })
                        completion(PKPaymentAuthorizationResult(status: .failure, errors: errors))
                        
                    default:
                        completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                    }
                }
            }
        }
    }
    
    private func submitToStripe(des: String, completion: @escaping (String?) -> Void) {
        guard let currentUser = appDL.currentUser else {
            hud?.removeHUD {}
            return
        }
        
        MyAPIClient().createCustomer(user: currentUser) { (customerID) in
            guard let customerID = customerID else {
                self.hud?.removeHUD {}
                return
            }
            
            guard self.total > 0.0 else {
                self.hud?.removeHUD {}
                return
            }
            
            MyAPIClient().createPaymentIntent(total: self.total, customerId: customerID, des: des, email: currentUser.email, completion: completion)
        }
    }
}

//MARK: - CreditCard

extension CheckoutVC {
    
    private func creditCard(_ cardParams: STPPaymentMethodCardParams, postalCode: String) {
        guard appDL.shoppings.count != 0 else { return }
        guard let shipping = viewModel.selectedShipping else { return }
        
        //Bao gồm giảm giá...
        var subtotal = (appDL.shoppings.map({ $0.total * ((100 - $0.saleOff)/100) }).reduce(0, +))
        var fee = shipping.fee
        
        if let promoCode = promoCode {
            if promoCode.type == PromoCode.PromoType.Discount.rawValue {
                let sub = subtotal * (promoCode.percent/100)
                subtotal = subtotal - sub
            }
            
            if promoCode.type == PromoCode.PromoType.Freeship.rawValue {
                fee = shipping.fee * ((100 - promoCode.percent)/100)
            }
        }
        
        total = subtotal + fee - (coin/1000)
        
        //Địa chỉ giao hàng
        guard let address = address else { return }
        guard let currentUser = appDL.currentUser else { return }
        
        hud = HUD.hud(kWindow)
        
        submitToStripe(des: "Payment by Credit Card".localized()) { clientSecret in
            guard let clientSecret = clientSecret else {
                self.hud?.removeHUD {}
                return
            }
            
            let methodAddr = STPPaymentMethodAddress()
            methodAddr.line1 = address.street
            
            if address.ward != "" {
                methodAddr.line1 = address.street + ", \(address.ward)"
            }
            
            methodAddr.country = address.countryCode
            methodAddr.state = address.state
            methodAddr.city = address.city
            methodAddr.postalCode = postalCode
            
            let billing = STPPaymentMethodBillingDetails()
            billing.address = methodAddr
            billing.email = currentUser.email
            billing.phone = address.phoneNumber
            billing.name = address.fullName
            
            let paymentMethod = STPPaymentMethodParams(card: cardParams, billingDetails: billing, metadata: nil)
            let paymentIntent = STPPaymentIntentParams(clientSecret: clientSecret)
            paymentIntent.paymentMethodParams = paymentMethod
            
            STPPaymentHandler.shared().confirmPayment(paymentIntent, with: self) { status, paymentIntent, error in
                self.paymentID = paymentIntent?.paymentMethodId ?? ""
                self.hud?.removeHUD {}
                
                if let error = error {
                    self.showAlert(title: "Oops".localized() + "!", mes: error.localizedDescription) {}
                    return
                }
                
                switch status {
                case .succeeded:
                    self.placeOrder(isPaid: true, paymentID: self.paymentID)
                    print("*** CREDITCARD SUCCESSFULLY")
                case .canceled:
                    self.showAlert(title: "Canceled".localized(), mes: "Payment failed".localized()) {}
                case .failed:
                    self.showAlert(title: "Failed".localized(), mes: "Payment failed".localized()) {}
                default: break
                }
            }
        }
    }
}

//MARK: - CreditCardVCDelegate

extension CheckoutVC: CreditCardVCDelegate {
    
    func creditCardDoneDidTap(_ vc: CreditCardVC, cardParams: STPPaymentMethodCardParams, postalCode: String) {
        vc.dismiss(animated: true) {
            self.creditCard(cardParams, postalCode: postalCode)
        }
    }
}

//MARK: - PayPal

extension CheckoutVC {
    
    private func payPal() {
        guard appDL.shoppings.count != 0 else { return }
        guard let shipping = viewModel.selectedShipping else { return }
        
        //Bao gồm giảm giá...
        var subtotal = (appDL.shoppings.map({ $0.total * ((100 - $0.saleOff)/100) }).reduce(0, +))
        var fee = shipping.fee
        
        if let promoCode = promoCode {
            if promoCode.type == PromoCode.PromoType.Discount.rawValue {
                let sub = subtotal * (promoCode.percent/100)
                subtotal = subtotal - sub
            }
            
            if promoCode.type == PromoCode.PromoType.Freeship.rawValue {
                fee = shipping.fee * ((100 - promoCode.percent)/100)
            }
        }
        
        total = subtotal + fee - (coin/1000)
        guard total > 0.0 else { return }
        
        hud = HUD.hud(kWindow)
        
        PayPalAPIClient.shared.authentication { headerValue in
            guard let headerValue = headerValue else {
                self.hud?.removeHUD {}
                return
            }
            
            self.headerValue = headerValue
            
            PayPalAPIClient.shared.createOrder(headerValue: headerValue, total: "\(self.total)") { orderID, approveLink in
                guard let orderID = orderID, let approveLink = approveLink else {
                    self.hud?.removeHUD {}
                    return
                }
                
                self.payPalOrderID = orderID
                
                let vc = WebKitVC()
                vc.link = approveLink

                let navi = NavigationController(rootViewController: vc)
                navi.isModalInPresentation = true

                self.present(navi, animated: true)
                
                /*
                if let url = URL(string: approveLink) {
                    WebService.shared.goToURL(url)
                }
                */
            }
        }
    }
}
