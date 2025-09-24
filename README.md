# 🛍️ E-commerce Application with Flutter and Firebase
A full-featured, cross-platform E-commerce application built with **Flutter** for a dynamic user interface and **Firebase** for a robust, scalable backend.

## 🌟 Overview

This project implements a complete E-commerce solution, featuring separate, dedicated applications for the **Customer** and the **Administrator**.

### Key Technology Stack
* **Frontend:** Flutter (Dart)
* **Backend & Database:** Firebase (Firestore, Authentication, Storage)

---

## ✨ Features

The application is split into two distinct modules, each with its own set of features:

### 1. Customer Application (User Module)
This is the main shopping interface for customers.
* **Authentication:** Seamless sign-in and sign-up with email and password.
* **Product Discovery:** Browse products by categories (e.g., Jackets, T-shirts, Shoes) and utilize a dedicated search function.
* **Shopping Experience:**
    * Detailed **Product View** with images, descriptions, and pricing.
    * Add items to a **Shopping Cart** with quantity management.
    * **Checkout** process with order summary and delivery details.
* **Personalization:**
    * **My Favorites:** Save products to a personal wishlist.
    * **Profile Management:** View and edit user details (name, email, address).
    * **Order Tracking:** View the status of past and current orders (Placed, Confirmed, Delivered).

### 2. Administrator Application (Admin Module)
A powerful dashboard designed for managing the entire E-commerce operation.
* **Admin Dashboard:** Overview of key metrics, including recent orders, product counts, and category statistics.
* **Products Management:**
    * **CRUD** operations (Create, Read, Update, Delete) on all product listings.
    * Search and filter products by type.
    * Add new products with images, price, and description.
* **Categories Management:** Manage and organize product categories.
* **Orders Management:**
    * View all customer orders with detailed information.
    * Update the **Order Status** (e.g., from Placed to Confirmed to Delivered).
* **Analytics:** Basic data visualization for sales and user engagement.

---

## 🎨 Design Screenshots

The following screenshots illustrate the user interfaces for both the Admin and User modules.

### Customer (User) Interface
A modern, clean, and intuitive design focusing on an excellent shopping experience.
<img width="1080" height="954" alt="تصميم بدون عنوان (1)" src="https://github.com/user-attachments/assets/32255a5a-e414-4782-b631-6a21b7e8b0a8" />

### Administrator (Admin) Interface
A dark-themed, centralized dashboard for efficient management and control.
<img width="1209" height="983" alt="تصميم بدون عنوان" src="https://github.com/user-attachments/assets/070701d9-b8fe-419a-9f5f-08a67e75d885" />

---

## 🚀 Getting Started

Follow these steps to get your copy of the project up and running on your local machine.

### Prerequisites

* **Flutter SDK:** Make sure you have the latest stable version installed.
* **Dart SDK:** Included with Flutter.
* **Firebase CLI:** For interacting with your Firebase project.
* **IDE:** VS Code or Android Studio.

### Installation

1.  **Clone the Repository**
    ```bash
    git clone [Your Repository URL Here]
    cd ecommerce_flutter_firebase
    ```

2.  **Install Dependencies**
    Navigate to the project root and run:
    ```bash
    flutter pub get
    ```

3.  **Firebase Setup**
    This project requires a Firebase project for authentication and database services.
    * Create a new project in the [Firebase Console](https://console.firebase.google.com/).
    * Add both **Android** and **iOS** applications to your Firebase project.
    * Enable **Firestore Database** and **Firebase Authentication** (with Email/Password sign-in).
    * Follow the standard FlutterFire instructions to connect your project using the `flutterfire configure` command, or manually place your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files in their respective directories.

4.  **Run the Application**
    Select your desired device (emulator or physical) and run:
    ```bash
    flutter run
    ```

---

## 🤝 Contribution

Contributions are welcome! If you find a bug or have a feature request, please open an issue or submit a pull request.

---

## 📄 License

This project is licensed under the MIT License - see the `LICENSE` file for details.

---

## 📞 Contact

* **Developer:** https://github.com/AbdouNavaa/
* **Project Link:** https://github.com/AbdouNavaa/Ecommerce-with-firebase/
