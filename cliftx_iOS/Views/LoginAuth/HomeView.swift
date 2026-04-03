//
//  HomeView.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 03/04/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var themeManager = ThemeManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DiscoverView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "flame.fill" : "flame")
                    Text("Discover")
                }
                .tag(0)
            
//            MatchesView()
//                .tabItem {
//                    Image(systemName: selectedTab == 1 ? "message.fill" : "message")
//                    Text("Matches")
//                }
//                .tag(1)
//            
//            ProfileView()
//                .tabItem {
//                    Image(systemName: selectedTab == 2 ? "person.fill" : "person")
//                    Text("Profile")
//                }
//                .tag(2)
        }
        .tint(themeManager.current.primary)
    }
}

// MARK: - Discover/Swipe View
struct DiscoverView: View {
    @StateObject private var themeManager = ThemeManager()
    @State private var profiles: [Profile] = MockData.profiles
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack {
            themeManager.current.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
            }
        }
    }
    
    private func handleSwipe(_ action: SwipeAction) {
        withAnimation(.spring()) {
            currentIndex += 1
        }
    }
}

enum SwipeAction {
    case like, pass, superLike
}

// MARK: - Mock Data
struct Profile: Identifiable {
    let id = UUID()
    let name: String
    let age: Int
    let company: String
    let jobTitle: String
    let imageName: String
    let distance: Int
    let interests: [String]
}

struct MockData {
    static let profiles = [
        Profile(name: "Priya Sharma", age: 28, company: "Google", jobTitle: "Product Manager", imageName: "person1", distance: 3, interests: ["Travel", "Yoga", "Coffee"]),
        Profile(name: "Rahul Verma", age: 30, company: "Microsoft", jobTitle: "Senior Engineer", imageName: "person2", distance: 5, interests: ["Cricket", "Tech", "Movies"]),
        Profile(name: "Neha Patel", age: 27, company: "Amazon", jobTitle: "Marketing Lead", imageName: "person3", distance: 2, interests: ["Reading", "Hiking", "Art"]),
    ]
}

#Preview {
    HomeView()
}
