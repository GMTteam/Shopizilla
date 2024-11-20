//
//  CategoryModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 16/04/2022.
//

import UIKit
import Firebase

enum CategoryKey: String {
    case NewArrivals = "New Arrivals"
    case Accessories
    case Men
    case Women
}

enum SubcategoryKey: String {
    case TShirts = "T-Shirts"
    case Sweatshirts
    case Hoodies
    case Shirts
    case Jackets
    case Jeans
    case Pants
    case Shorts
}

struct CategoryModel {
    
    let bannerURL: String
    let category: String
    
    //Accessories, Men, Women
    let subcategories: [String]
}

class Category {
    
    private let model: CategoryModel
    
    var bannerURL: String { return model.bannerURL }
    var category: String { return model.category }
    
    //Accessories, Men, Women
    var subcategories: [String] { return model.subcategories }
    
    init(model: CategoryModel) {
        self.model = model
    }
}

extension Category {
    
    convenience init(dict: [String: Any]) {
        let bannerURL = dict["bannerURL"] as? String ?? ""
        let category = dict["category"] as? String ?? ""
        let subcategories = dict["subcategories"] as? [String] ?? []
        
        let model = CategoryModel(bannerURL: bannerURL, category: category, subcategories: subcategories)
        self.init(model: model)
    }
}

//MARK: - Get

extension Category {
    
    ///Lấy tất cả danh mục
    static func fetchCategories(completion: @escaping ([Category]) -> Void) {
        let db = Firestore.firestore().collection("Categories")
        db.getDocuments { snapshot, error in
            var categories: [Category] = []
            
            if let error = error {
                print("fetchCategories error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot {
                categories = snapshot.documents.map({ Category(dict: $0.data()) })
            }
            
            DispatchQueue.main.async {
                completion(categories)
            }
        }
    }
}

//MARK: - Equatable

extension Category: Equatable {}
func ==(lhs: Category, rhs: Category) -> Bool {
    return lhs.category == rhs.category
}
