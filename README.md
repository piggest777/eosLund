# Eos Lund Basket for iOS

The original iOS app for Eos Lund Basket, a basketball club in Lund, Sweden. Fans can browse league fixtures and results, see a countdown to the next game, explore team and player profiles, and follow club news.

The app uses Swift, UIKit, and storyboards. Firestore provides schedule and roster data, Firebase Storage serves images, and Firebase Cloud Messaging handles push notifications. Realm stores team and player data locally.

## Open in Xcode

1. On macOS, install Xcode and CocoaPods. Run `pod install` from the repository root.
2. Add the Firebase configuration for your own development project at `eosLund/GoogleService-Info.plist`.
3. Open `eosLund.xcworkspace` and select the `eosLund` scheme. Choose an iOS simulator for local development. Device builds require signing for your own development team.

This is a legacy project. Newer Xcode versions may require dependency or deployment target updates. Live content requires a Firebase backend with data matching the app models. Push notifications require Firebase Cloud Messaging and Apple Push Notification service configuration.

## Where to start

- [GameScheduleVC.swift](eosLund/Controller/GameScheduleVC.swift) connects the schedule screen to Firestore updates and the local team cache.
- [GameInfoVC.swift](eosLund/Controller/GameInfoVC.swift) displays match details and links to statistics.
- [TeamInformationVC.swift](eosLund/Controller/TeamInformationVC.swift) manages roster and player information.
- [NewsVC.swift](eosLund/Controller/NewsVC.swift) loads news and video content.
