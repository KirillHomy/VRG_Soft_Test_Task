News App – iOS Test Task

Overview
Simple iOS app built with SwiftUI that displays news from NewsAPI.
The project demonstrates clean architecture, async networking, pagination, and pull-to-refresh.

Tech Stack
SwiftUI
MVVM
async / await
URLSession
SwiftData (Favorites)

Features
Home – news feed with search
Categories – filter news by category
Favorites – save/remove articles locally

Pull-to-Refresh
Pull-to-refresh is implemented using .refreshable on Home and Categories screens.
During refresh:
A full data reload is triggered
Pagination state is reset
UI shows “Refreshing…” status and last updated time

Pagination (optional)
Pagination is implemented using a sentinel row approach:
A ProgressView is displayed at the bottom of the List
When the sentinel row appears on screen, the next page is requested
A gate (canTriggerNextFromSentinel()) prevents duplicate requests caused by
SwiftUI list re-layout or repeated view appearances
Pagination logic is extracted into a reusable PaginatedListView component and shared across screens.

Architecture Notes
Networking models are separated using DTO
API responses are mapped into domain models
Pagination logic is encapsulated in a reusable loader
No third-party libraries are used

How to Run
Insert your NewsAPI key
Build and run on iOS 17+


![Task](https://github.com/KirillHomy/VRG_Soft_Test_Task/blob/main/TestTask_DEV_iOS_PDF.jpg)

