# Spotlight Search Integration in iOS 🔍📱

This project demonstrates how to integrate **Core Spotlight Search** in an iOS app using Swift. It enables indexing of in-app content for quick access via iOS Spotlight.

---

## 🚀 Features

- Register searchable items with titles, keywords, images
- Support for feature/subfeature for better navigation
- Handle Spotlight taps and navigate accordingly
- Live Example in ViewController file.

---

## 🛠 Technologies

- Swift 5
- UIKit
- Core Spotlight
- Mobile indexing & deep linking

---

## 🧩 Structure

### Only these two files are important and containing all spotlight related code
- `SpotlightManager.swift`: Handles all Spotlight-related logic (add, delete, tap, navigation)
- `SpotlightManager+Model.swift`: In this filer SpotlightItem model representing the searchable item


### In SeceneDelegate Tap Event Handling
- `func scene(_ scene: UIScene, continue userActivity: NSUserActivity)` - In this method we have handled Spotlight Tap event.


 ### Sample or Live Example 
- `ViewController`: Live example of indexing items into Spotlight, Also some operations like delete, deleteAll.



## 💡 Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/kuldeep9013/SpotlightSearchSample.git

