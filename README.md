<div align="center">
<img src="https://avatars.githubusercontent.com/u/202675624?s=400&u=2daf23e8872a3b666bcd4f792a21fe2633097e79&v=4" alt="Flutter News App Toolkit Logo" width="220">

# Flutter News App - Web Dashboard Full Source Code

<p>
<img src="https://img.shields.io/badge/coverage-XX-green?style=for-the-badge" alt="coverage: percentage">
<a href="https://flutter-news-app-full-source-code.github.io/flutter-news-app-web-dashboard-full-source-code/"><img src="https://img.shields.io/badge/Demo-Live-orange?style=for-the-badge" alt="Demo: Live"></a>
<a href="https://github.com/sponsors/flutter-news-app-full-source-code"><img src="https://img.shields.io/badge/DOCS-READ-purple?style=for-the-badge" alt="DOCS READ"></a>
<a href="https://github.com/sponsors/flutter-news-app-full-source-code"><img src="https://img.shields.io/badge/LICENSE-BUY-pink?style=for-the-badge" alt="License: Buy"></a>
</p>
</div>

This is a complete and fully-functional Flutter web application for comprehensive content management and administration. It is a key component of the [**flutter news app full source code toolkit**](https://github.com/flutter-news-app-full-source-code), an ecosystem that also includes a dart frog [backend API](https://github.com/flutter-news-app-full-source-code/flutter-news-app-api-server-full-source-code) and a [mobile client](https://github.com/flutter-news-app-full-source-code/flutter-news-app-mobile-client-full-source-code).

## ⭐ Everything You Get, Ready to Go

This dashboard comes packed with all the features you need to manage a professional news application.

#### 📰 **Comprehensive Content Management**
Effortlessly manage all aspects of your news content with full CRUD (Create, Read, Update, Delete) capabilities:
*   **Headlines:** Create, edit, and publish news articles.
*   **Topics:** Organize and define news topics.
*   **Sources:** Maintain and update news sources.
> **Your Advantage:** You get a powerful, centralized system to control your content, ensuring accuracy and consistency across your news platform. ✍️

#### ⚙️ **Dynamic Application Configuration**
Control the behavior and appearance of the mobile application remotely:
*   **User Preference Limits:** Set limits for followed items and saved headlines based on user roles (Guest, Authenticated, Premium).
*   **Ad Settings:** Configure ad frequency and placement intervals for different user tiers.
*   **In-App Prompts:** Manage the display frequency of account-related calls-to-action.
*   **Operational Status:** Remotely enable maintenance mode or suggest app updates to users.
> **Your Advantage:** Granular control over app features and monetization strategies without requiring app store updates. 🚀

#### 📊 **Dashboard Analytics**
Get a quick overview of your content ecosystem with key statistics:
*   **Content Counts:** View the total number of headlines, topics, and sources at a glance.
> **Your Advantage:** Instantly understand the scale of your content operation. 📈

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

*   **TRY IT:** Download and explore the full source code under the polyForm free trial [license](LICENSE). Perfect for evaluation.
*   **BUY IT:** Get an unlimited commercial lifetime license with a **one-time payment**. No subscriptions!
*   **GET YOURS:** [**Purchase via GitHub Sponsors**](https://github.com/sponsors/flutter-news-app-full-source-code).

> *<p style="color:grey">Note: The single purchase provides a comprehensive commercial license covering every repository within the [Flutter News App - Full Source Code Toolkit](https://github.com/flutter-news-app-full-source-code) organization. No separate purchases are needed for the API or mobile client.</p>*
---

## 🚀 Getting Started & Running Locally

1.  **Ensure Flutter is installed.** (See [Flutter documentation](https://flutter.dev/docs/get-started/install))
2.  **Clone the repository:**
    ```bash
    git clone https://github.com/flutter-news-app-full-source-code/flutter-news-app-web-dashboard-full-source-code.git
    cd flutter-news-app-web-dashboard-full-source-code
    ```
3.  **Get dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Run the app:**

### Running the App

To run the app, first select your desired environment in `lib/main.dart`:

```dart
// lib/main.dart

// Use `AppEnvironment.demo` to run with in-memory data (no API needed).
// Use `AppEnvironment.development` to connect to a local backend API.
const appEnvironment = AppEnvironment.demo; 
```

Then, run the app from your terminal:
```bash
flutter run -d chrome
```
*(Note: For `development` environment, ensure the [backend service](https://github.com/flutter-news-app-full-source-code/flutter-news-app-api-server-full-source-code) is running.)*

---

## ✅ Testing

This project aims for high test coverage to ensure quality and reliability.

*   Run tests with:
    ```bash
    flutter test
