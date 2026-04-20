import SwiftUI


// MARK: - Theme Selector View
struct ThemeSelectorView: View {
    @ObservedObject var themeManager: ThemeManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(themeManager.themes.indices, id: \.self) { index in
                    let theme = themeManager.themes[index]
                    let isSelected = themeManager.selectedIndex == index
                    
                    VStack(spacing: 8) {
                        // Theme preview card
                        RoundedRectangle(cornerRadius: 16)
                            .fill(theme.surface)
                            .frame(width: 60, height: 60)
                            .overlay(
                                VStack(spacing: 8) {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: theme.gradientColors,
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 30, height: 30)
                                    
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(theme.primary)
                                        .frame(width: 30, height: 3)
                                    
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(theme.textSecondary)
                                        .frame(width: 20, height: 2)
                                }
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        isSelected ? theme.primary : Color.clear,
                                        lineWidth: 3
                                    )
                            )
                            .shadow(color: theme.primary.opacity(isSelected ? 0.5 : 0.2), radius: 8)
                        
                        Text(theme.name)
                            .font(.caption2)
                            .fontWeight(isSelected ? .semibold : .regular)
                            .foregroundColor(isSelected ? theme.primary : theme.textSecondary)
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            themeManager.selectTheme(at: index)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}



// MARK: - Updated LoginView
struct LoginView: View {
    @StateObject private var themeManager = ThemeManager()
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var animateFields = false
    @State private var showForgotPassword = false
    
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @State private var navigateToSignUp = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                themeManager.current.background
                    .ignoresSafeArea()
                
                // Animated gradient blobs
                ForEach(0..<3) { i in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    themeManager.current.primary.opacity(colorScheme == .dark ? 0.25 : 0.15),
                                    themeManager.current.accent.opacity(colorScheme == .dark ? 0.12 : 0.08)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: CGFloat(300 + i * 50))
                        .position(
                            x: i == 0 ? -50 : (i == 1 ? UIScreen.main.bounds.width + 50 : UIScreen.main.bounds.width / 2),
                            y: i == 0 ? 100 : (i == 1 ? UIScreen.main.bounds.height - 200 : UIScreen.main.bounds.height / 3)
                        )
                        .blur(radius: colorScheme == .dark ? 70 : 50)
                        .opacity(animateFields ? 0.8 : 0)
                        .animation(.easeInOut(duration: 1.5).delay(Double(i) * 0.3), value: animateFields)
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer(minLength: 40)
                        
                        // Theme Selector
                        ThemeSelectorView(themeManager: themeManager)
                            .padding(.bottom, 40)
                            .offset(y: animateFields ? 0 : -30)
                            .opacity(animateFields ? 1 : 0)
                        
                        // Logo Area
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: themeManager.current.gradientColors,
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                    .opacity(0.15)
                                    .scaleEffect(animateFields ? 1 : 0.5)
                                
                                Image(systemName: "sparkles")
                                    .font(.system(size: 36, weight: .light))
                                    .foregroundColor(themeManager.current.primary)
                                    .scaleEffect(animateFields ? 1 : 0)
                                    .rotationEffect(.degrees(animateFields ? 0 : -90))
                            }
                            
                            Text("Welcome Back")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(themeManager.current.textPrimary)
                            
                            Text("Sign in to continue")
                                .font(.subheadline)
                                .foregroundColor(themeManager.current.textSecondary)
                        }
                        .padding(.bottom, 48)
                        .offset(y: animateFields ? 0 : -40)
                        .opacity(animateFields ? 1 : 0)
                        
                        // Input Fields
                        VStack(spacing: 20) {
                            AppTextField("Email", text: $email, icon: "envelope.fill", focused: $isEmailFocused)
                            AppTextField("Password", text: $password, isSecure: true, icon: "lock.fill", focused: $isPasswordFocused)
                        }
                        .padding(.horizontal, 24)
                        
                        // Sign In Button
                        PrimaryButton("Sign In", isLoading: isLoading) {
                            login()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 32)
                        
                        // Forgot Password
                        Button(action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                showForgotPassword.toggle()
                            }
                        }) {
                            Text("Forgot Password?")
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(themeManager.current.textSecondary.opacity(0.7))
                        }
                        .padding(.top, 20)
                        .offset(y: animateFields ? 0 : 80)
                        .opacity(animateFields ? 1 : 0)
                        
                        Spacer(minLength: 40)
                        
                        // Sign Up Section
                        HStack(spacing: 8) {
                            Text("Don't have an account?")
                                .foregroundColor(themeManager.current.textSecondary.opacity(0.6))
                                .font(.system(size: 14, weight: .medium))
                            
                            Button(action: {
                                navigateToSignUp = true
                            }) {
                                Text("Sign Up")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(themeManager.current.primary)
                            }
                        }
                        .padding(.bottom, 30)
                        .offset(y: animateFields ? 0 : 80)
                        .opacity(animateFields ? 1 : 0)
                    }
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7, blendDuration: 0.5)) {
                    animateFields = true
                }
            }
            .navigationDestination(isPresented: $navigateToSignUp) {
                SignUpView()
                    .navigationBarBackButtonHidden(false)
                    .environmentObject(themeManager)
            }
            .alert("Coming Soon", isPresented: $showForgotPassword) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Password reset will be available in the next update.")
            }
        }
        .environmentObject(themeManager)
    }
    
    private func login() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                isLoading = false
            }
        }
    }
}


//// MARK: - Preview
//#Preview {
//    LoginView()
//}
