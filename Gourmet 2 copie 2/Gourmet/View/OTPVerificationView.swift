import SwiftUI

struct OTPVerificationView: View {
    var email: String
    var userId: String?
    @State private var otpCode: [String] = ["", "", "", ""] // Four OTP digits
    @State private var isOTPValid: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToResetPassword = false // Navigation state for ResetPasswordView
    
    var body: some View {
        NavigationView {
            VStack {
                // Back button and title
                HStack {
                    Button(action: {
                        // Handle back navigation
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.red)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Title
                Text("OTP Verification")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
                    .padding(.top, 10)
                
                // Image
                Image(uiImage: UIImage(named: "deset") ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 150)
                    .cornerRadius(10)
                    .padding(.top, 10)
                
                // OTP Fields
                Text("Enter OTP Sent to \(email)")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.top, 20)
                
                HStack(spacing: 10) {
                    ForEach(0..<4) { index in
                        TextField("", text: $otpCode[index])
                            .frame(width: 50, height: 50)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                    }
                }
                .padding(.vertical, 20)
                
                // Verify OTP Button
                Button(action: {
                    verifyOTP()
                }) {
                    Text("Verify OTP")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.pink)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Resend OTP link
                HStack {
                    Text("Didn't Receive the OTP?")
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        // Handle resend action
                    }) {
                        Text("Resend")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.pink)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                // Navigation to ResetPasswordView
                NavigationLink(
                    destination: ResetPasswordView(userId: userId ?? ""), // Pass the userId
                    isActive: $navigateToResetPassword
                ) { EmptyView() }
            }
            .padding(.vertical, 10)
            .background(Color.white)
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text("OTP Verification"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationBarHidden(true) // Hide default navigation bar
    }
    
    func verifyOTP() {
        // Combine OTP input into a single string
        let enteredOTP = otpCode.joined()
        
        // Ensure userId is not nil
        guard let userId = userId else {
            alertMessage = "User ID is missing"
            isShowingAlert = true
            return
        }
        
        // Construct the URL
        guard let url = URL(string: "http://localhost:3001/auth/verify-otp/\(userId)") else {
            alertMessage = "Invalid URL"
            isShowingAlert = true
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the body
        let body: [String: String] = ["otp": enteredOTP]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        // Perform the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for network errors
            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = "Network error: \(error.localizedDescription)"
                    self.isShowingAlert = true
                }
                return
            }
            
            // Check HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.alertMessage = "Invalid response from server"
                    self.isShowingAlert = true
                }
                return
            }
            
            // Handle different response scenarios
            switch httpResponse.statusCode {
            case 200, 201:
                // OTP Verified Successfully (both 200 and 201 are considered successful)
                DispatchQueue.main.async {
                    self.isOTPValid = true
                    self.navigateToResetPassword = true
                }
            case 400:
                // Bad Request (Invalid OTP)
                DispatchQueue.main.async {
                    self.alertMessage = "Invalid OTP. Please try again."
                    self.isShowingAlert = true
                }
            case 404:
                // User Not Found
                DispatchQueue.main.async {
                    self.alertMessage = "User not found. Please try again."
                    self.isShowingAlert = true
                }
            case 401:
                // Unauthorized (OTP Expired)
                DispatchQueue.main.async {
                    self.alertMessage = "OTP has expired. Please request a new one."
                    self.isShowingAlert = true
                }
            default:
                // Unknown error
                DispatchQueue.main.async {
                    self.alertMessage = "An unexpected error occurred."
                    self.isShowingAlert = true
                }
            }
        }.resume()
    }
}

struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerificationView(email: "example@example.com", userId: "6745dcd7f854604f7231cb40")
    }
}
