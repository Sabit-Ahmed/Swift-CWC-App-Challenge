//
//  LoginView.swift
//  LearningApp
//
//  Created by Sabit Ahmed on 4/11/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct LoginView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var loginMode = Constants.LoginMode.login
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @State var errorMessage: String? = nil
    
    var buttonText: String {
        if loginMode == Constants.LoginMode.createAccount {
            return "Sign up"
        }
        else {
            return "Login"
        }
    }
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            Spacer()
            
            // Logo
            Image(systemName: "book")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 150)
            
            // Title
            Text("Learn Swift")
            
            
            Spacer()
            
            // Picker
            Picker(selection: $loginMode, label: Text("sad")) {
                
                Text("Login")
                    .tag(Constants.LoginMode.login)
                
                Text("Sign up")
                    .tag(Constants.LoginMode.createAccount)
                
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Group {
                // Form
                TextField("Email", text: $email)
                
                if loginMode == Constants.LoginMode.createAccount {
                    TextField("Name", text: $name)
                }
                
                SecureField("Password", text: $password)
                
                if errorMessage != nil {
                    Text(errorMessage!)
                }
            }
            
            // Button
            Button {
                
                if loginMode == Constants.LoginMode.login {
                    
                    // Log user in
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        
                        guard error == nil else {
                            self.errorMessage = error!.localizedDescription
                            return
                        }
                        
                        // Clear error message
                        self.errorMessage = nil
                        
                        // TODO: Fetch the user data
                        self.model.getUserData()
                        
                        // Change the view to the logged in view
                        self.model.checkLogin()
                    }
                }
                else {
                    // Create a new account
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        
                        guard error == nil else {
                            self.errorMessage = error!.localizedDescription
                            return
                        }
                        // Clear error message
                        self.errorMessage = nil
                        
                        // Save the first name
                        let firebaseUser = Auth.auth().currentUser
                        let db = Firestore.firestore()
                        let ref = db.collection("users").document(firebaseUser!.uid)
                        
                        ref.setData(["name": name], merge: true)
                        
                        // Change the view to logged in view
                        self.model.checkLogin()
                        
                        let user = UserService.shared.user
                        user.name = name
                    }
                }
                
            } label: {
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.blue)
                        .frame(height: 40)
                        .cornerRadius(10)
                    
                    Text(buttonText)
                        .foregroundColor(.white)
                }
                
            }
            
            Spacer()

            
        }
        .padding(.horizontal, 40)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        
    }
}

