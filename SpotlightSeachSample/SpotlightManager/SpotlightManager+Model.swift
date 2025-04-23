//
//  SpotlightManager+Model.swift
//  SpotlightSeachSample
//
//  Created by Kuldeep Solanki on 23/04/25.
//

import UIKit

/// Represents high-level navigation features within the app that can be indexed in Spotlight.
enum SpotlightFeature: String {
    case home
    case settings
    // Extend with more features relevant to your project.
}

/// Represents more granular navigation targets under each `SpotlightFeature`.
enum SpotlightSubfeature: String {
    case people
    case favorites
    // Extend with more subfeatures as needed.
}

/// A model representing a Spotlight-searchable item within the app.
///
/// Use this struct to define and configure items that can be indexed and discovered via iOS Spotlight Search.
struct SpotlightItem {
    
    /// A unique identifier for the item. This should be used to restore or navigate to the item.
    let itemID: String
    
    /// The title displayed in the Spotlight result.
    let title: String
    
    /// A short description that provides context in the search result.
    let description: String?
    
    /// Related keywords to help improve searchability if the user does not search by exact title.
    let relatedKeywords: [String]?
    
    /// The feature (or section) of the app this item belongs to. Used for routing/navigation.
    let feature: SpotlightFeature
    
    /// A more specific sub-feature within the app, if applicable.
    let subfeature: SpotlightSubfeature?
    
    /// An optional image shown alongside the Spotlight result.
    let itemImage: UIImage?
    
    /// A thumbnail image URL (used in Universal Links and rich previews, if supported).
    let thumbnailURL: URL?
    
    /// Initializes a new instance of `SpotlightItem`.
    ///
    /// - Parameters:
    ///   - itemID: A unique identifier for the item.
    ///   - title: The title of the item to display in Spotlight results.
    ///   - description: A brief description of the item.
    ///   - relatedKeywords: Additional keywords that improve search matching.
    ///   - feature: The high-level app section this item belongs to.
    ///   - subfeature: A more specific target within the feature.
    ///   - itemImage: A display image for the item.
    ///   - thumbnailURL: A URL for thumbnail display or universal linking.
    init(itemID: String,
         title: String,
         description: String? = nil,
         relatedKeywords: [String]? = nil,
         feature: SpotlightFeature,
         subfeature: SpotlightSubfeature? = nil,
         itemImage: UIImage? = nil,
         thumbnailURL: URL? = nil) {
        self.itemID = itemID
        self.title = title
        self.description = description
        self.relatedKeywords = relatedKeywords
        self.feature = feature
        self.subfeature = subfeature
        self.itemImage = itemImage
        self.thumbnailURL = thumbnailURL
    }
}

