//
//  CoreDataStack.swift
//  Shopizilla
//
//  Created by Anh Tu on 19/04/2022.
//

import UIKit
import CoreData

enum EntityName: String {
    case SearchHistory, RecentlyViewed, AllNotification
}

class CoreDataStack: NSObject {
    
    //MARK: - Properties
    private let modelName: String
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        
        container.loadPersistentStores { des, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    //MARK: - Initializes
    init(modelName: String) {
        self.modelName = modelName
    }
}

//MARK: - Save

extension CoreDataStack {
    
    ///Lưu trữ dữ liệu
    func saveData() {
        guard viewContext.hasChanges else {
            return
        }
        do {
            try viewContext.save()
            getCoreDataPath()
            
        } catch let error as NSError {
            print("saveData error: \(error.localizedDescription)")
        }
    }
}

//MARK: - Update

extension CoreDataStack {
    
    ///Cập nhật Keyword đã tồn tại. Hoặc lưu mới. SearchHistory
    class func updateKeywordSearchHistory(with keyword: String, id: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName.SearchHistory.rawValue)
        request.predicate = NSPredicate(format: "id == %@", id)
        
        var history: SearchHistory?
        
        do {
            //Cập nhật
            if let results = try appDL.coreData.viewContext.fetch(request) as? [SearchHistory],
                results.count != 0
            {
                history = results.first
                history!.date = Date()
                history!.keyword = keyword
            }
            
        } catch let error as NSError {
            print("updateFloorPrice error: \(error.localizedDescription)")
        }
        
        //Thêm mới
        if history == nil {
            history = SearchHistory(context: appDL.coreData.viewContext)
            history!.id = id
            history!.date = Date()
            history!.keyword = keyword
        }
        
        if history != nil {
            appDL.coreData.saveData()
            NotificationCenter.default.post(name: .searchHistoryKey, object: nil)
        }
    }
    
    ///Cập nhật Product đã tồn tại. Hoặc lưu mới. RecentlyViewed
    class func updateProductIDRecentlyViewed(with product: Product, id: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName.RecentlyViewed.rawValue)
        request.predicate = NSPredicate(format: "id == %@", id)
        
        var recently: RecentlyViewed?
        
        do {
            //Cập nhật
            if let results = try appDL.coreData.viewContext.fetch(request) as? [RecentlyViewed],
                results.count != 0
            {
                recently = results.first
                recently!.date = Date()
                recently!.productID = product.productID
                recently!.category = product.category
                recently!.subcategory = product.subcategory
            }
            
        } catch let error as NSError {
            print("updateFloorPrice error: \(error.localizedDescription)")
        }
        
        //Thêm mới
        if recently == nil {
            recently = RecentlyViewed(context: appDL.coreData.viewContext)
            recently!.id = id
            recently!.date = Date()
            recently!.productID = product.productID
            recently!.category = product.category
            recently!.subcategory = product.subcategory
        }
        
        if recently != nil {
            appDL.coreData.saveData()
            NotificationCenter.default.post(name: .recentlyViewedKey, object: nil)
        }
    }
    
    ///Cập nhật hoặc thêm mới Notificaiton
    class func updateNotificationBy(id: String, isOn: Bool) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName.AllNotification.rawValue)
        request.predicate = NSPredicate(format: "id == %@", id)
        
        var notif: AllNotification?
        
        do {
            if let results = try appDL.coreData.viewContext.fetch(request) as? [AllNotification],
               results.count != 0 {
                notif = results.first
                notif!.isOn = isOn
            }
            
        } catch let error as NSError {
            print("updateNotificationBy error: \(error.localizedDescription)")
        }
        
        if notif == nil {
            notif = AllNotification(context: appDL.coreData.viewContext)
            notif!.id = id
            notif!.isOn = isOn
        }
        
        if notif != nil {
            appDL.coreData.saveData()
        }
    }
}

//MARK: - SearchHistory

extension CoreDataStack {
    
    ///Lấy các SearchHistory đã lưu trữ
    class func fetchSearchHistories(completion: @escaping ([SearchHistory]) -> Void) {
        var array: [SearchHistory] = []
        let request: NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()
        
        do {
            array = try appDL.coreData.viewContext.fetch(request).sorted(by: { $0.date > $1.date })
            
        } catch let error as NSError {
            print("fetchSearchHistories error: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            completion(array)
        }
    }
}

//MARK: - RecentlyViewed

extension CoreDataStack {
    
    ///Lấy các RecentlyViewed đã lưu trữ
    class func fetchRecentlyViewed(completion: @escaping ([RecentlyViewed]) -> Void) {
        var array: [RecentlyViewed] = []
        let request: NSFetchRequest<RecentlyViewed> = RecentlyViewed.fetchRequest()
        
        do {
            array = try appDL.coreData.viewContext.fetch(request).sorted(by: { $0.date > $1.date })
            
        } catch let error as NSError {
            print("fetchRecentlyViewed error: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            completion(array)
        }
    }
}

//MARK: - Notification

extension CoreDataStack {
    
    ///Lấy các Notification đã lưu trữ
    class func fetchNotifications(completion: @escaping ([AllNotification]) -> Void) {
        var array: [AllNotification] = []
        let request: NSFetchRequest<AllNotification> = AllNotification.fetchRequest()
        
        do {
            array = try appDL.coreData.viewContext.fetch(request)
            
        } catch let error as NSError {
            print("fetchNotifications error: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            completion(array)
        }
    }
}

//MARK: - Delete

extension CoreDataStack {
    
    ///Xoá tất cả Items bởi entityName
    class func deleteAllItem(entityName: EntityName) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        let batch = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try appDL.coreData.viewContext.execute(batch)
            
        } catch let error as NSError {
            print("deleteAllItem error: \(error.localizedDescription)")
        }
        
        appDL.coreData.saveData()
    }
    
    ///Xoá 1 Item bởi entityName
    class func deleteItem(by id: String, entityName: EntityName) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        request.predicate = NSPredicate(format: "id == %@", id)
        
        let batch = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try appDL.coreData.viewContext.execute(batch)
            
        } catch let error as NSError {
            print("deleteItem error: \(error.localizedDescription)")
        }
        
        appDL.coreData.saveData()
        
    }
}

func getCoreDataPath() {
    let urls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
    print("CoreData Path: \(urls.first?.path ?? "")")
}
