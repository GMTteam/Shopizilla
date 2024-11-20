//
//  DynamicLinkModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 14/06/2022.
//

import UIKit
import FirebaseDynamicLinks

class DynamicLinkModel {

    static func shared() -> DynamicLinkModel {
        return DynamicLinkModel()
    }

    let link = "https://hoangmtv.vn/" //Create short link
    let openAppURL = "https://shopizilla.page.link/H3Ed" //Open App

    private let dynamicLink = "https://shopizilla.page.link"
    private var bundleID: String {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""
    }

    func shortLinks(_ link: String, title: String, imgURL: URL?, completion: @escaping (URL?) -> Void) {
        if let url = URL(string: link) {
            if let linkerBuilder = DynamicLinkComponents(link: url, domainURIPrefix: dynamicLink) {
                linkerBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: bundleID)
                linkerBuilder.iOSParameters?.appStoreID = WebService.shared.getAPIKey().appID

                linkerBuilder.navigationInfoParameters = DynamicLinkNavigationInfoParameters()
                linkerBuilder.navigationInfoParameters?.isForcedRedirectEnabled = true

                linkerBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
                linkerBuilder.socialMetaTagParameters?.imageURL = imgURL
                linkerBuilder.socialMetaTagParameters?.title = title
                //linkerBuilder.socialMetaTagParameters?.descriptionText = ""

                linkerBuilder.options = DynamicLinkComponentsOptions()
                linkerBuilder.options?.pathLength = .short

                linkerBuilder.shorten(completion: { (url, warnings, error) in
                    DynamicLinks.performDiagnostics(completion: nil)

                    var newUrl: URL?
                    if let url = url, error == nil {
                        newUrl = url
                    }

                    DispatchQueue.main.async {
                        print("*** Short link: \(newUrl?.absoluteString ?? "")")
                        completion(newUrl)
                    }
                })
            }
        }
    }
}
