import SwiftUI

struct LoginView: View {
    
    @StateObject private var themeManager = ThemeManager()
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var animateFields = false
    @State private var animateButton = false
    @State private var showForgotPassword = false
    
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    
    var body: some View {
        ZStack {
            // Deep elegant background
            themeManager.current.background
                .ignoresSafeArea()
            
            // Subtle animated gradient orbs
            Circle()
                .fill(themeManager.current.primary.opacity(0.15))
                .frame(width: 300, height: 300)
                .position(x: -50, y: 100)
                .blur(radius: 60)
            
            Circle()
                .fill(themeManager.current.accent.opacity(0.12))
                .frame(width: 250, height: 250)
                .position(x: UIScreen.main.bounds.width + 50, y: UIScreen.main.bounds.height - 300)
                .blur(radius: 60)
            
            Circle()
                .fill(themeManager.current.primary.opacity(0.1))
                .frame(width: 200, height: 200)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 150)
                .blur(radius: 50)
            
            VStack(spacing: 0) {
                Spacer(minLength: 40)
                
                // Theme selector pills
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
                VStack(spacing: 20) {
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
                    
                    Button(action: {}) {
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
        .overlay(
            // Forgot password modal
            Group {
                if showForgotPassword {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showForgotPassword = false
                            }
                        }
                    
                    VStack(spacing: 20) {
                        Image(systemName: "key.fill")
                            .font(.system(size: 50))
                            .foregroundColor(themeManager.current.primary)
                        
                        Text(UITitle.resetPasswordTitle)
                            .font(.title2.bold())
                            .foregroundColor(themeManager.current.textPrimary)
                        
                        Text(UITitle.resetPasswordSubtitle)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(themeManager.current.textSecondary.opacity(0.6))
                        
                        TextField(UIPlaceholderText.email, text: .constant(""))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .foregroundColor(themeManager.current.textPrimary)
                            .colorScheme(.dark)
                            .padding(.top)
                        
                        HStack(spacing: 12) {
                            Button(UIButtonTitle.cancel) {
                                withAnimation(.spring()) {
                                    showForgotPassword = false
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(themeManager.current.surface.opacity(0.1))
                            .cornerRadius(12)
                            .foregroundColor(themeManager.current.textPrimary)
                            
                            Button(UIButtonTitle.send) {
                                withAnimation(.spring()) {
                                    showForgotPassword = false
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(themeManager.current.primary)
                            .cornerRadius(12)
                            .foregroundColor(themeManager.current.textPrimary)
                        }
                    }
                    .padding(24)
                    .background(
                        themeManager.current.surface
                            .cornerRadius(24)
                    )
                    .padding(.horizontal, 32)
                    .transition(.scale.combined(with: .opacity))
                }
            }
        )
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

// Placeholder modifier for TextField
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        self.background(
            ZStack(alignment: alignment) {
                if shouldShow {
                    placeholder()
                }
            }
        )
    }
}

#Preview {
    LoginView()
        .environment(\.themeManager, ThemeManager())
}
