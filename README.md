<div align="center">
<img src="https://avatars.githubusercontent.com/u/202675624?s=400&u=2daf23e8872a3b666bcd4f792a21fe2633097e79&v=4" alt="Flutter News App Dashboard Logo" width="220">

# Flutter News App Web Dashboard Full Source Code

<p>
<img src="https://img.shields.io/badge/coverage-0%25-green?style=for-the-badge" alt="coverage: 0%">
<a href="https://flutter-news-app-full-source-code.github.io/flutter-news-app-web-dashboard-full-source-code/"><img src="https://img.shields.io/badge/LIVE_DEMO-VIEW-orange?style=for-the-badge" alt="Live Demo: View"></a>
<a href="https://flutter-news-app-full-source-code.github.io/docs/web-dashboard/local-setup/"><img src="https://img.shields.io/badge/DOCUMENTATION-READ-slategray?style=for-the-badge" alt="Documentation: Read"></a>
<a href="LICENSE"><img src="https://img.shields.io/badge/TRIAL_LICENSE-VIEW_TERMS-blue?style=for-the-badge" alt="Trial License: View Terms"></a>
<a href="https://github.com/sponsors/flutter-news-app-full-source-code"><img src="https://img.shields.io/badge/LIFETIME_LICENSE-PURCHASE-purple?style=for-the-badge" alt="Lifetime License: Purchase"></a>
</p>
</div>

This repository contains the complete, production-ready source code for a Flutter web dashboard designed for comprehensive content management. It is a key component of the [**Flutter News App - Full Source Code Toolkit**](https://github.com/flutter-news-app-full-source-code), an ecosystem that also includes a Dart Frog [backend API](https://github.com/flutter-news-app-full-source-code/flutter-news-app-api-server-full-source-code) and a [mobile client](https://github.com/flutter-news-app-full-source-code/flutter-news-app-mobile-client-full-source-code).

## ⭐ Everything You Get, Ready to Go

This dashboard comes packed with all the features you need to manage a professional news application.

#### 📰 **Comprehensive Content Management**
Effortlessly manage the entire lifecycle of your news content with full CRUD (Create, Read, Update, Delete) capabilities, complemented by advanced archiving and restoration features:
*   **Headlines:** Create, edit, publish, archive, restore, and permanently delete news articles.
*   **Topics:** Organize, define, archive, and restore news topics.
*   **Sources:** Maintain, update, archive, and restore news sources.
> **Your Advantage:** Gain unparalleled control over your content. This centralized system ensures accuracy, consistency, and data integrity, allowing you to manage active content flows and easily retrieve or permanently remove archived items with robust undo functionality. ✍️

#### 📺 **Flexible Local Ads Management**
Take full control of your in-app advertising strategy with a dedicated management suite for local ads. Create, edit, and manage various ad formats, including:
*   **Native Ads:** Design ads that blend seamlessly with your content.
*   **Banner Ads:** Implement traditional banner advertisements.
*   **Interstitial Ads:** Configure full-screen ads for strategic placements.
*   **Video Ads:** Integrate engaging video advertisements.
Each ad type supports full CRUD operations, along with archiving, restoration, and permanent deletion, providing complete lifecycle management.
> **Your Advantage:** Monetize your application effectively with flexible, locally managed ad campaigns. This feature empowers you to rapidly deploy and iterate on ad content without relying on external ad networks or app store updates, ensuring maximum control and revenue potential. 💰

#### 📊 **Dashboard Overview**
Get a quick, real-time overview of your content ecosystem with key statistics and quick actions:
*   **Content Counts:** View the total number of headlines, topics, and sources at a glance.
*   **Recent Activity:** See recently created headlines to stay on top of new content.
*   **Quick Actions:** Directly create new headlines, topics, or sources from the overview.
> **Your Advantage:** Instantly understand the pulse of your content operation and jump directly into key management tasks, streamlining your workflow. 📈

#### ⚙️ **Customizable Dashboard Settings**
Provide your administrative team with the ability to personalize their dashboard experience through a robust settings interface. This feature allows individual administrators and publishers to tailor the dashboard's appearance and behavior to their preferences, including:
*   **Appearance Settings:** Adjust base themes (light/dark/system), accent colors, font families, text scale factors, and font weights for the dashboard UI.
*   **Language Selection:** Choose their preferred language for the dashboard interface.
These settings are user-specific, ensuring a comfortable and efficient working environment for each team member.
> **Your Advantage:** Enhance the productivity and satisfaction of your administrative team with a highly customizable dashboard. By allowing personalized display and language options, you create a more efficient and user-friendly management experience. 🎨

#### 📱 **App Configuration: Dynamic Remote Settings for Mobile Client**
Manage the mobile client's remote configuration directly from the dashboard. This powerful feature allows you to dynamically control various aspects of the mobile application without requiring an app store update, ensuring agility and responsiveness to business needs. Configurable elements include:
*   **Maintenance Mode:** Instantly enable or disable maintenance mode for the mobile app, displaying a custom message to users.
*   **Force Update:** Mandate app updates to a specific version (`latestAppVersion`), with an option to force users to update (`isLatestVersionOnly`). Configurable update URLs for iOS and Android are also available.
*   **Ad Settings:** Comprehensive control over advertising strategy:
    *   **Global Ad Enablement:** A master switch to enable or disable all ads.
    *   **Primary Ad Platform:** Choose between `AdMob` or `Local` ad platforms.
    *   **Ad Unit Identifiers:** Configure specific ad unit IDs for each platform, including `feedNativeAdId`, `feedBannerAdId`, `feedToArticleInterstitialAdId`, `inArticleNativeAdId`, and `inArticleBannerAdId`.
    *   **Feed Ad Configuration:** Define ad types (`native`, `banner`) and frequency (`adFrequency`, `adPlacementInterval`) based on user roles (`guestUser`, `standardUser`, `premiumUser`).
    *   **Article Ad Configuration:** Control in-article ad enablement, preferred `bannerAdShape` (`square`, `rectangle`), and specific `inArticleAdSlotConfigurations` (`aboveArticleContinueReadingButton`, `belowArticleContinueReadingButton`).
    *   **Interstitial Ad Configuration:** Manage global interstitial ad enablement and frequency (`transitionsBeforeShowingInterstitialAds`) for page transitions, also tiered by user role.
*   **Feed Decorators:** Manage the enablement and visibility of various in-feed promotional and engagement elements, such as `linkAccount`, `upgrade`, `rateApp`, `enableNotifications`, `suggestedTopics`, and `suggestedSources`. Each decorator can be configured for specific user roles and `daysBetweenViews`.
*   **User Preference Limits:** Set maximum limits for followed items (countries, sources, topics) and saved headlines, tiered by user roles (`guestUser`, `standardUser`, `premiumUser`).
> **Your Advantage:** Gain dynamic control over your mobile application's behavior and monetization strategy. Adjust critical settings on the fly, ensuring your users always have the best experience and your business goals are met without the overhead of app store releases. 🚀

#### 🔐 **Robust User Authentication**
Secure and flexible authentication flows are built-in for administrators and publishers using Email + Code (Passwordless) Sign-In.
> **Your Advantage:** All the complex security and user management for your administrative team is already done for you. ✅

#### 🖥️ **Responsive Web UI**
Built with `flutter_adaptive_scaffold`, the dashboard offers a clean, responsive interface that looks great on any screen size.
> **Your Advantage:** Deliver a consistent and optimized administrative experience on desktops, tablets, and even mobile browsers. ↔️

#### 🏗️ **Clean & Modern Architecture**
Developed with best practices for a maintainable and scalable codebase:
*   **Flutter & Dart:** Cutting-edge web development.
*   **BLoC Pattern:** Predictable and robust state management.
*   **GoRouter:** Well-structured and powerful navigation.
> **Your Advantage:** The dashboard is built on a clean, modern architecture that's easy to understand and maintain. It's solid and built to last. 📈

#### ⚙️ **Flexible Environment Configuration**
Easily switch between development (in-memory data or local API) and production environments with a simple code change. This empowers rapid prototyping, robust testing, and seamless deployment.
> **Your Advantage:** A flexible setup that speeds up your development cycle and makes deployment simple. 🚀

#### 🌍 **Localization Ready**
Fully internationalized with working English and Arabic localizations (`.arb` files). Adding more languages is straightforward.
> **Your Advantage:** Easily adapt your dashboard for a global team. 🌐

---

## 🔑 License: Source-Available with a Free Trial

Get started for free and purchase when you're ready to launch!

*   **TRY IT:** Download and explore the full source code under the PolyForm Free Trial [license](LICENSE). Perfect for evaluation.
*   **BUY IT:** One-time payment for a lifetime license to publish unlimited commercial apps.
*   **GET YOURS:** [**Purchase via GitHub Sponsors**](https://github.com/sponsors/flutter-news-app-full-source-code).

> [!NOTE]
> *A single purchase provides a commercial license for every repository within the [Flutter News App - Full Source Code Toolkit](https://github.com/flutter-news-app-full-source-code). No other purchases are needed..*

---

## 🚀 Getting Started & Running Locally

For a complete guide on setting up your local environment, running the web dashboard, and understanding the configuration, please see the **[Local Setup Guide](https://flutter-news-app-full-source-code.github.io/docs/web-dashboard/local-setup/)** in our official documentation.

Our documentation provides a detailed, step-by-step walkthrough to get you up and running smoothly.

---

## ✅ Testing

This project aims for high test coverage to ensure quality and reliability.

*   Run tests with:
    ```bash
    flutter test
