# 📊✨ ht_dashboard

![coverage: percentage](https://img.shields.io/badge/coverage-XX-green)
[![Demo: Live](https://img.shields.io/badge/Demo-Live-orange)](https://headlines-toolkit.github.io/ht-dashboard/)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![License: PolyForm Free Trial](https://img.shields.io/badge/License-PolyForm%20Free%20Trial-blue)](https://polyformproject.org/licenses/free-trial/1.0.0)

`ht_dashboard` is a Flutter web application designed as a comprehensive content management and administration interface for the [Headlines Toolkit](https://github.com/headlines-toolkit) ecosystem. It provides a powerful, intuitive platform for managing news content, application configurations, and user-related settings, complementing the [mobile app](https://github.com/headlines-toolkit/ht-main) and the [backend service](https://github.com/headlines-toolkit/ht-api).

## ⭐ Features & Capabilities

`ht_dashboard` offers a robust set of tools for efficient administration:

#### 📰 **Comprehensive Content Management**
Effortlessly manage all aspects of your news content, including:
*   **Headlines:** Create, edit, and delete news articles.
*   **Categories:** Organize and define news categories.
*   **Sources:** Maintain and update news sources.
*   **Benefit for you:** Centralized control over your content, ensuring accuracy and consistency across your news platform. ✍️

#### ⚙️ **Dynamic Application Configuration**
Control the behavior and appearance of the `ht_main` mobile application remotely:
*   **User Preference Limits:** Set limits for followed items and saved headlines
    based on user roles (Guest, Authenticated, Premium).
*   **Ad Settings:** Configure ad frequency and placement intervals for
    different user tiers.
*   **In-App Prompts:** Manage the display frequency of account-related
    calls-to-action.
*   **Operational Status (Kill Switch):** Remotely enable maintenance mode or
    disable the app.
*   **Force Update:** Mandate or suggest app updates to users.
*   **Benefit for you:** Granular control over app features and monetization
    strategies without requiring app store updates. 🚀

#### 📊 **Intuitive User Interface**
Built with Flutter, the dashboard provides a responsive and user-friendly
experience across various web browsers and screen sizes.
*   **Benefit for you:** A modern, maintainable, and visually appealing
    interface for your administrative tasks. ✨

#### 🏗️ **Clean & Modern Architecture**
Developed with best practices for a maintainable and scalable codebase:
*   **Flutter & Dart:** Cutting-edge web development.
*   **BLoC Pattern:** Predictable and robust state management.
*   **GoRouter:** Well-structured and powerful navigation.
*   **Adaptive UI:** Responsive layouts using `flutter_adaptive_scaffold` for
    optimal experience on different screen sizes.
*   **Benefit for you:** An easy-to-understand, extendable, and testable
    foundation for your project. 📈

#### 🌍 **Localization Ready**
Fully internationalized with working English and Arabic localizations (`.arb` files).
*   **Benefit for you:** Easily adapt your dashboard for a global team. 🌐

---

## 🔑 Access and Licensing

`ht_dashboard` is source-available as part of the Headlines Toolkit ecosystem.

To acquire a commercial license for building unlimited news applications, please visit 
the [Headlines Toolkit GitHub organization page](https://github.com/headlines-toolkit)
for more details.

---

## 🚀 Getting Started

1.  **Ensure Flutter is installed.** (See [Flutter documentation](https://flutter.dev/docs/get-started/install))
2.  **Clone the repository:**
    ```bash
    git clone https://github.com/headlines-toolkit/ht-dashboard.git
    cd ht-dashboard
    ```
3.  **Get dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Run the app for web:**
    ```bash
    flutter run -d chrome
    # Or to run on a web server (e.g., for CORS testing with ht_api)
    # flutter run -d web-server --web-hostname 0.0.0.0 --web-port 3000
    ```
    *(Note: For full functionality, ensure the `ht_api` backend service is running and accessible. If running `ht_api` locally, ensure its `CORS_ALLOWED_ORIGIN` environment variable is configured to allow requests from the dashboard's origin, e.g., `http://localhost:3000` if using the web-server option.)*

---

## ✅ Testing

This project aims for high test coverage to ensure quality and reliability.

*   Run tests with:
    ```bash
    flutter test
    ```
    *(Note: Ensure `very_good_cli` is activated: `dart pub global activate very_good_cli`)*
