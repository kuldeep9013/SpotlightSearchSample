//
//  SpotlightManager.swift
//  SpotlightSeachSample
//
//  Created by Kuldeep Solanki on 23/04/25.
//

import UIKit
import CoreSpotlight

/// Manages indexing, deleting, and handling Spotlight search actions for app-specific items.
final class SpotlightManager {
    
    /// Unique identifier prefix used for all Spotlight items.
    private let baseIdentifier = "com.kk"
    
    /// Background queue for Spotlight indexing operations.
    private let backgroundQueue = DispatchQueue(
        label: "com.kk.spotlight.background",
        qos: .background,
        attributes: .concurrent
    )
    
    // MARK: - Indexing
    
    /// Indexes an array of items in Spotlight.
    ///
    /// - Parameter items: The items to be indexed.
    func index(items: [SpotlightItem]) {
        for item in items {
            let searchableItem = createSearchableItem(from: item)
            backgroundQueue.async {
                CSSearchableIndex.default().indexSearchableItems([searchableItem]) { error in
                    if let error {
                        print("Spotlight indexing error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    /// Constructs a `CSSearchableItem` from a `SpotlightItem`.
    ///
    /// - Parameter item: The item to convert.
    /// - Returns: A configured `CSSearchableItem`.
    private func createSearchableItem(from item: SpotlightItem) -> CSSearchableItem {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: UTType.text.identifier)
        attributeSet.title = item.title
        attributeSet.identifier = item.itemID
        attributeSet.contentDescription = item.description
        attributeSet.keywords = item.relatedKeywords
        
        if let thumbnailURL = item.thumbnailURL {
            attributeSet.thumbnailURL = thumbnailURL
        } else {
            attributeSet.thumbnailData = item.itemImage?.pngData() ?? UIImage(named: "AppIcon")?.pngData()
        }
        
        var itemIdentifier = "\(baseIdentifier)?feature=\(item.feature.rawValue)&itemID=\(item.itemID)"
        var domainIdentifier = "\(baseIdentifier).\(item.feature.rawValue)"
        
        if let sub = item.subfeature?.rawValue {
            domainIdentifier += ".\(sub)"
            itemIdentifier += "&subfeature=\(sub)"
        }
        
        return CSSearchableItem(
            uniqueIdentifier: itemIdentifier,
            domainIdentifier: domainIdentifier,
            attributeSet: attributeSet
        )
    }
    
    // MARK: - Delete Operations
    
    /// Deletes all items previously indexed in Spotlight.
    func deleteAllSearchableItems() {
        backgroundQueue.async {
            CSSearchableIndex.default().deleteAllSearchableItems()
            debugPrint("All Item Deleted")
        }
    }
    
    /// Deletes Spotlight items associated with a specific feature or subfeature.
    ///
    /// - Parameters:
    ///   - feature: The high-level app section.
    ///   - subfeature: Optional sub-section under the feature.
    func deleteItems(for feature: SpotlightFeature, subfeature: SpotlightSubfeature? = nil) {
        var domainIdentifier = "\(baseIdentifier).\(feature.rawValue)"
        if let sub = subfeature?.rawValue {
            domainIdentifier += ".\(sub)"
        }
        backgroundQueue.async {
            CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [domainIdentifier])
        }
    }
    
    /// Deletes a specific indexed item by feature, subfeature, and ID.
    ///
    /// - Parameters:
    ///   - feature: The main app section the item belongs to.
    ///   - subfeature: An optional sub-section of the feature.
    ///   - itemID: The unique item identifier.
    func deleteItem(feature: SpotlightFeature, subfeature: SpotlightSubfeature?, itemID: String) {
        var identifier = "\(baseIdentifier)?feature=\(feature.rawValue)&itemID=\(itemID)"
        if let sub = subfeature?.rawValue {
            identifier += "&subfeature=\(sub)"
        }
        backgroundQueue.async {
            CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [identifier])
            debugPrint("Item Deleted with id \(itemID)")
        }
    }
    
    // MARK: - Handling Spotlight Taps and Navigation
    
    /// Handles a Spotlight search result tap. Call from `scene(_:continue:)` or `application(_:continue:)`.
    ///
    /// - Parameter activity: The `NSUserActivity` passed from the system.
    func handleSpotlightActivity(_ activity: NSUserActivity) {
        guard activity.activityType == CSSearchableItemActionType,
              let url = activity.userInfo?[CSSearchableItemActivityIdentifier] as? String else { return }
        parseAndNavigate(from: url)
    }
    
    /// Parses the URL query string and triggers appropriate navigation.
    ///
    /// - Parameter url: A spotlight URL string.
    private func parseAndNavigate(from url: String) {
        var parameters: [String: String] = [:]
        if let components = URLComponents(string: url) {
            components.queryItems?.forEach { parameters[$0.name] = $0.value }
        }
        navigate(using: parameters)
    }
    
    /// Navigates to the appropriate screen based on parsed Spotlight parameters.
    ///
    /// - Parameter parameters: Parsed key-value pairs from the Spotlight URL.
    private func navigate(using parameters: [String: String]) {
        guard let featureKey = parameters["feature"],
              let feature = SpotlightFeature(rawValue: featureKey) else { return }
        switch feature {
        case .home:
            // Navigate to Home screen
            break
        case .settings:
            // Navigate to Settings screen
            break
        }
    }
}

