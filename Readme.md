# BidHaven - Local Property Auction Platform

## Members



| Full Name | ID |
| :--- | :--- |
| Bekalu Addisu    | UGR/9538/16 |
| Fita Alemayehu   | UGR/7071/16  |
| Lemi Gobena      | UGR/1589/16  |
| Misganaw Habtamu | UGR/1707/16   |
| Olit Oljira      | UGR/8925/16   |
| ... | ... |



## Features

### 1. Business Feature 1: Property Listing Management (Seller/Landlord)
- **Create:** Sellers/Landlords can list a property for **sale or rent** with details such as title, description, images, price, and location.
- **Read:** Users can view all properties or detailed information about a single property.
- **Update:** Sellers/Landlords can edit their own active property listings.
- **Delete:** Sellers/Landlords can remove their own property listings.

### 2. Business Feature 2: Auction & Rental Bidding System (Buyer/Renter)
- **Create:** Logged-in buyers/renters can place bids on active property listings. The system ensures each bid is higher than the current highest bid (for auctions).
- **Read:** Users can view the complete bidding history for a property.
- **Update:** Users can retract their own bids, updating the bid status to "retracted".
- **Delete:** Admins can remove inappropriate or invalid bids.

### 3. Business Feature 3: Proposal Submission System (Optional)
- **Create:** For listings that require additional conditions, bidders can submit a **proposal** explaining their offer, background, or qualifications.
- **Read:** Sellers/Landlords can view all submitted proposals for their properties.
- **Update:** Users can edit their submitted proposals before the deadline.
- **Delete:** Users can delete their own proposals, and admins can remove inappropriate ones.

### 4. Authentication & Authorization
- **Authentication:**
  - User Sign Up
  - User Login and Logout
  - Delete Account

- **Authorization (Role-Based Access Control):**
  - **Guest:** View-only access to properties.
  - **Buyer/Renter:** Can place bids and submit proposals.
  - **Seller/Landlord:** Can manage property listings and review bids/proposals.
  - **Admin:** Full control over users, properties, bids, and proposals.

### 5. Unique Features
- **Location-Based Feed:** Displays properties sorted based on proximity to the logged-in user.
- **Auction State Management:** Sellers/Landlords can end auctions early, and the system automatically determines the highest bidder.
- **Flexible Listing Type:** Properties can be listed as either **For Sale** or **For Rent**, supporting both bidding and proposal-based selection.
- **Fayda Digital ID Verification:** Users can verify their identity using **Fayda (Digital ID)** to increase trust and credibility on the platform. Verified users are clearly indicated, helping sellers and landlords make more confident decisions.