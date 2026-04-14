import SwiftUI

struct LoginView: View {
    
    @StateObject private var themeManager = ThemeManager()
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var animateFields = false
    @State private var animateButton = false
    @State private var showForgotPassword = false
    
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @State private var navigateToSignUp = false

    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.current.background
                    .ignoresSafeArea()
                // Apple-style adaptive glow
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                themeManager.current.primary
                                    .opacity(colorScheme == .dark ? 0.45 : 0.25),
                                themeManager.current.accent
                                    .opacity(colorScheme == .dark ? 0.18 : 0.10)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 340, height: 340)
                    .position(x: -70, y: 120)
                    .blur(radius: colorScheme == .dark ? 90 : 60)

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                themeManager.current.accent
                                    .opacity(colorScheme == .dark ? 0.35 : 0.18),
                                themeManager.current.primary
                                    .opacity(colorScheme == .dark ? 0.12 : 0.08)
                            ],
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                        )
                    )
                    .frame(width: 260, height: 260)
                    .position(
                        x: UIScreen.main.bounds.width + 40,
                        y: UIScreen.main.bounds.height - 320
                    )
                    .blur(radius: colorScheme == .dark ? 80 : 55)
                
                VStack(spacing: 0) {
                    Spacer(minLength: 40)
                    
                    HStack(spacing: 12) {
                        ForEach(themeManager.themes.indices, id: \.self) { index in
                            Circle()
                                .fill(themeManager.themes[index].primary)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: themeManager.selectedIndex == index ? 3 : 0)
                                )
                                .scaleEffect(themeManager.selectedIndex == index ? 1.1 : 1.0)
                                .onTapGesture { themeManager.selectTheme(at: index) }
                        }
                    }
                    .padding(.bottom, 30)
                    .offset(y: animateFields ? 0 : -30)
                    .opacity(animateFields ? 1 : 0)
                    
                    // Animated logo area
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(themeManager.current.primary.opacity(0.2))
                                .frame(width: 90, height: 90)
                                .scaleEffect(animateFields ? 1 : 0.5)
                                .opacity(animateFields ? 1 : 0)
                            
                            Image(systemName: "sparkles")
                                .font(.system(size: 42, weight: .light))
                                .foregroundColor(themeManager.current.primary)
                                .scaleEffect(animateFields ? 1 : 0)
                                .rotationEffect(.degrees(animateFields ? 0 : -90))
                        }
                        
                        Text(UITitle.appName)
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .foregroundColor(themeManager.current.textPrimary)
                        
                        Text(UITitle.tagline)
                            .font(.subheadline)
                            .foregroundColor(themeManager.current.textSecondary.opacity(0.7))
                    }
                    .padding(.bottom, 45)
                    .offset(y: animateFields ? 0 : -40)
                    .opacity(animateFields ? 1 : 0)
                    
                    // Input fields container
                    VStack(spacing: 30) {
                        AppTextField(UIPlaceholderText.email, text: $email, kind: .plain, systemIcon: "envelope.fill", focused: $isEmailFocused)
                        AppTextField(UIPlaceholderText.password, text: $password, kind: .secure, systemIcon: "lock.fill", focused: $isPasswordFocused)
                    }
                    .padding(.horizontal, 24)
                    
                    // Sign In button
                    PrimaryButton(UIButtonTitle.signIn, isLoading: isLoading) { login() }
                        .padding(.horizontal, 24)
                        .padding(.top, 35)
                    
                    // Forgot password
                    Button(action: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showForgotPassword.toggle()
                        }
                    }) {
                        Text(UITitle.forgotPassword)
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(themeManager.current.textSecondary.opacity(0.6))
                    }
                    .padding(.top, 20)
                    .offset(y: animateButton ? 0 : 80)
                    .opacity(animateButton ? 1 : 0)
                    
                    Spacer()
                    
                    // Sign up section
                    HStack(spacing: 8) {
                        Text(UITitle.signUpPrompt)
                            .foregroundColor(themeManager.current.textSecondary.opacity(0.5))
                            .font(.system(size: 14, weight: .medium))
                        
                        Button(action: {
                            navigateToSignUp = true
                        }) {
                            Text(UIButtonTitle.signup)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(themeManager.current.primary)
                        }
                    }
                    .padding(.bottom, 30)
                    .offset(y: animateButton ? 0 : 80)
                    .opacity(animateButton ? 1 : 0)
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7, blendDuration: 0.5)) {
                    animateFields = true
                }
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7, blendDuration: 0.5).delay(0.3)) {
                    animateButton = true
                }
            }
            .navigationDestination(isPresented: $navigateToSignUp) {
                SignUpView()
                    .navigationBarBackButtonHidden(false)
            }
        }
    }
    
    private func login() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation {
                isLoading = false
            }
        }
    }
}

//#Preview {
//    LoginView()
//        .environment(\.themeManager, ThemeManager())
//}
