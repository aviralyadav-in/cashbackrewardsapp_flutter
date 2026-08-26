# CashKaro App — Complete Architecture, Workflow & Screens Guide

A clean, concise, plain-language reference explaining what the app does, why this specific folder structure is used, how the user journey works, and a breakdown of all 30 screens.

---

## 1. What This App Does (In Simple Words)

**CashKaro** is a shopping rewards and cashback mobile app. When users want to buy anything online (clothes, electronics, medicines, groceries, or apply for personal loans/credit cards), they:
1. Open the **CashKaro app** and choose a partner store (Amazon, Flipkart, Myntra, Ajio, Nykaa, Navi Loans, etc.).
2. Tap **"Shop Now"** to open the retailer's website or app.
3. Make their purchase as normal.
4. The retailer pays CashKaro a commission, and CashKaro gives that money back to the user as **Real Cashback**.
5. Once verified, users can transfer that money directly into their **Bank Account (via NEFT)**, **UPI (GPay/PhonePe/Paytm)**, or redeem as **Amazon Pay Gift Cards**.

---

## 2. Why We Use This Specific Folder Structure

In Flutter, putting all code in one place makes projects messy and difficult to maintain. We divided the codebase into 6 distinct, organized folders so any developer can easily locate, modify, and fix features without breaking anything else:

| Folder | What It Contains | Why We Use It (In Plain Words) |
| :--- | :--- | :--- |
| **`lib/screens/`** | Full App Pages | Every file here represents a complete screen the user sees (e.g. Login, Home, Profile, Withdraw). Keeps page-level layouts, scrolling, and navigation strictly separated so you know exactly which file to open when editing a specific screen. |
| **`lib/widgets/`** | Reusable UI Building Blocks | Holds small UI components used on multiple screens (like `CustomAppBar`, `ModalDragHandle`, and `NetworkImageWithSkeleton`). Instead of rewriting the exact same 40 lines of App Bar code on 20 different screens, we write it once here and reuse it everywhere. If we need to change a style, we update 1 file instead of 20. |
| **`lib/models/`** | Data Blueprints (Contracts) | Defines what data looks like in code (e.g. what a Product has: name, price, cashback, image URL). Prevents bugs and typos by turning raw data from APIs or databases into safe, strongly-typed Dart objects. |
| **`lib/providers/`** | App State & Memory Management | Holds live data in memory (e.g. is user logged in, current wallet balance, active dark/light theme, selected category). When a user updates their profile name in Account Settings, Provider updates it in memory and immediately reflects it across Home, Profile, and Settings without restarting the app or passing variables manually. |
| **`lib/services/`** | Outside World Communication Layer | Handles background communication: Firebase Authentication, Cloud Firestore database syncing, HTTP REST API network calls, saving local preferences, and opening phone/browser links. Screens only handle UI; if the database or API changes, we only edit this folder. |
| **`lib/data/`** | Catalog & Mock Registries | Stores large datasets (like 14 top categories, 2,000+ brand catalogs, banners, and offline deals). Keeps huge lists of store data cleanly separated so they don't clutter UI screen files. |
| **`lib/main.dart`** | The Front Door of the App | The starting point of the application where themes, state providers, and all 30 screen route names are registered and initialized. |

---

## 3. Complete App Workflow (Step-by-Step)

```text
[App Launch] ──> Splash Screen ──> Onboarding / Login ──> Home Screen
                                                             │
┌────────────────────────────────────────────────────────────┘
├── 1. Browse Deals & Categories (Home / Search / Categories / Offer Reels)
├── 2. View Product & Effective Price (Product Detail Screen)
├── 3. Activate Cashback & Visit Store (Shopping Confirmation ──> Retailer App/Web)
├── 4. Complete Purchase on Retailer (Amazon, Flipkart, etc.)
├── 5. Cashback Tracked (Appears in Pending Earnings within 24-48 hrs)
├── 6. Store Return Window Closes (Money shifts to Confirmed Earnings)
└── 7. Withdraw Money (Transfer to Bank NEFT, UPI ID, or Amazon Pay)
```

1. **Launch & Login**: App opens → Splash Screen checks if user is logged in. If new, Onboarding Screen explains benefits, then Login Screen authenticates via Phone OTP or Email. Profile data syncs with Cloud Firestore.
2. **Browsing & Discovering Deals**: User lands on Home Screen → Can search items, scroll 14 top categories (Fashion, Mobiles, Pharmacy, Loans, etc.), check flash deal reels (Flipkart, Meesho Under ₹99), or scratch the Golden Ticket for bonus cash.
3. **Visiting Retailer & Tracking Order**: User selects a product or store → Views effective discounted price on Product Detail Screen → Taps "Shop Now" → Shopping Confirmation screen activates tracking session → Redirects user into the retailer's app/website (Amazon, Flipkart, etc.) where they complete the purchase.
4. **Cashback Lifecycle (Pending to Confirmed)**: Retailer reports the purchase within 24-48 hours → Cashback appears in user's Pending Earnings. After retailer's 30-day return period ends, the cashback automatically shifts into Confirmed Earnings.
5. **Withdrawing Real Money**: User opens My Earnings → Taps "Request Payment" → Selects UPI ID, Bank NEFT, or Amazon Pay Gift Card → Enters amount (minimum ₹250) → Confirms withdrawal.
6. **Referral Bonus & Support**: User shares their unique invite link from Refer & Earn → Friends join and shop → User earns a 10% lifetime commission. If any purchase wasn't tracked, user raises a claim in Missing Cashback Tickets.

---

## 4. Complete Breakdown of All 30 Screens

### Group 1: Onboarding & Authentication
* **1. [Splash Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/splash_screen.dart) (`/splash`)**: Entry screen; displays pulsating logo and checks if user is logged in to route to Onboarding or Home.
* **2. [Onboarding Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/onboarding_screen.dart) (`/onboarding`)**: 3-page introductory swipe slider explaining Cashback, Instant Withdrawals, and 10% Referrals.
* **3. [Login & Sign Up Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/login_screen.dart) (`/login`)**: Dual-mode login supporting Phone Number OTP verification and Email/Password login, plus registration bottom sheet.
* **4. [Sign Up Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/signup_screen.dart) (`/signup`)**: Lightweight direct route alias forwarding new users into the registration flow.

### Group 2: Home & Shopping Marketplace
* **5. [Home Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/home_screen.dart) (`/` or `/home`)**: Main app hub with live search bar, 14 categories, Golden Ticket banner, store deal reels, and 12 discovery sections.
* **6. [Live Search Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/search_screen.dart) (`/search`)**: Instant real-time search filtering across 2,000+ brand deals, products, and categories as you type.
* **7. [Categories Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/categories_screen.dart) (`/categories`)**: Product catalog with a top auto-centering category bar and a live feed of discounted products.
* **8. [All Categories Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/all_categories_screen.dart) (`/all-categories`)**: Visual 2-column image grid showing all 24 eCommerce shopping categories with deal counters.
* **9. [Top Category Brands Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/top_category_brands_screen.dart) (`/top-category-brands`)**: Lists all partner stores for a specific category (e.g. Fashion or Pharmacy) with exit confirmation dialogs.
* **10. [Offer Section Deals Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/offer_section_screen.dart) (`/offer-section`)**: Grid displaying special promotional sales (Flipkart Deals, Meesho Under ₹99, Best of Loans).
* **11. [Product Detail Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/product_detail_screen.dart) (`/product-detail`)**: Full offer page with image carousel, effective price math ("Final Price = Price - Cashback"), 3-step guide, and "Shop Now" button.
* **12. [Shopping Confirmation Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/shopping_confirmation_screen.dart) (`/shopping-confirmation`)**: Transition screen confirming cashback tracking before opening the retailer website/app.
* **13. [Golden Ticket Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/ticket_screen.dart) (`/ticket`)**: Interactive gamified golden ticket with real-time 3D wave physics and gesture scratch reveal for vouchers.

### Group 3: Profile, Wallet & Payouts
* **14. [Profile Dashboard Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/profile_screen.dart) (`/profile`)**: Account control center showing user info, total cashback stats, menu links, dark mode switch, and logout.
* **15. [Account Settings Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/account_settings_screen.dart) (`/account-settings`)**: Form allowing users to edit and update their Full Name, Email, and Phone number with Cloud Firestore sync.
* **16. [My Earnings Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/my_earnings_screen.dart) (`/my-earnings`)**: Financial wallet breakdown showing Lifetime Earnings, Confirmed Balance (ready to withdraw), and Pending Balance.
* **17. [Why Is Earnings Pending Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/know_why_screen.dart) (`/know-why`)**: Educational 4-step timeline explaining tracking, return period wait, store validation, and confirmation.
* **18. [Withdraw Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/withdraw_screen.dart) (`/withdraw`)**: Payout interface allowing users to transfer confirmed money (min ₹250) to UPI, Bank Account, or Amazon Pay.
* **19. [Payments Guide Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/payments_screen.dart) (`/payments`)**: Informational guide explaining withdrawal thresholds, payment rules, and payout methods.
* **20. [Payments History Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/payments_history_screen.dart) (`/payments-history`)**: Searchable statement of all past payouts with a Digital Receipt popup showing bank reference IDs.
* **21. [My Order Details Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/my_order_details_screen.dart) (`/my-order-details`)**: Transaction history ledger of all tracked store purchases with status, dates, and cashback earned.

### Group 4: Referrals, Customer Support & Legal
* **22. [Refer & Earn Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/refer_earn_screen.dart) (`/refer-earn`)**: Referral hub with auto-sliding banner, 1-tap link copy button, WhatsApp sharing, and 10% lifetime commission guide.
* **23. [My Referrals Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/my_referrals_screen.dart) (`/my-referrals`)**: Tracker showing total invited friends who joined, total referral bonus earned, and list of referrals.
* **24. [Missing Cashback Tickets Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/missing_tickets_screen.dart) (`/missing-tickets`)**: Claim tool for untracked store orders; allows submitting retailer name, order ID, and amount for resolution.
* **25. [Get Help & Support Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/get_help_screen.dart) (`/get-help`)**: Customer FAQ center with categorized topics (Shopping, Tracking, Payouts) and contact support modal.
* **26. [Call Us Helpline Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/call_us_screen.dart) (`/call-us`)**: Direct phone contact portal with 1-tap toll-free helpline caller (1800-227-4527), hours, email, and WhatsApp.
* **27. [Your Queries Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/your_queries_screen.dart) (`/your-queries`)**: Overview of open support queries and missing ticket claims with quick navigation links.
* **28. [Review Us Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/review_us_screen.dart) (`/review-us`)**: 5-star rating picker, feedback submission box, Play Store link, and community review feed with upvote buttons.
* **29. [Notifications Center Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/notifications_screen.dart) (`/notifications`)**: Filterable alert inbox for cashback updates, flash sales, and payouts with "Mark all as read".
* **30. [Privacy Policy Screen](file:///d:/all_flutter_projects/cashback_reward_app/lib/screens/privacy_policy_screen.dart) (`/privacy-policy`)**: 10-section structured legal policy covering data protection, encryption, account security, and user rights.

---

## 5. Categories & Loans Overview

* **14 Featured Home Categories**: Most Popular, Fashion, Credit Cards, Beauty & Grooming, Home & Kitchen, Electronics, Food & Grocery, Mobiles, Pharmacy, Health & Wellness, Loans & Financial Services, Departmental, Flights & Hotels, Education.
* **Loans & Financial Services**: Features Instant Personal Loans (Navi, MoneyView, KreditBee), Pre-Approved Home Loans, and Zero-Interest Credit Cards. When a user's loan application is approved by the partner lender, flat cash rewards are automatically credited to the user's wallet.
