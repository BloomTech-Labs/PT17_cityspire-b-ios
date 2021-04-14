//
//  ProfileController.swift
//  LabsScaffolding
//
//  Created by Spencer Curtis on 7/23/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import OktaAuth

class ProfileController {
    
    static let shared = ProfileController()
    
    let oktaAuth = OktaAuth(baseURL: URL(string: "https://auth.lambdalabs.dev/")!,
                            clientID: "0oa18is3355KlyP5C4x7",
                            redirectURI: "labs://cityspire/implicit/callback")
    
    private(set) var authenticatedUserProfile: Profile?
    private(set) var profiles: [Profile] = []
    
    private let baseURL = URL(string: "https://pt17-cityspire-b.herokuapp.com/")!
    
    private init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshProfiles),
                                               name: .oktaAuthenticationSuccessful,
                                               object: nil)
    }
    
    @objc func refreshProfiles() {
        getAllProfiles()
    }
    
    /// called during login process to fetch an array of all profiles in Okta
    /// - Parameter completion: populates profiles array in ProfileController, which is unused
    func getAllProfiles(completion: @escaping () -> Void = {}) {
        
        var oktaCredentials: OktaCredentials
        
        do {
            oktaCredentials = try oktaAuth.credentialsIfAvailable()
        } catch {
            postAuthenticationExpiredNotification()
            NSLog("Credentials do not exist. Unable to get profiles from API")
            DispatchQueue.main.async {
                completion()
            }
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("profiles")
        var request = URLRequest(url: requestURL)
        
        request.addValue("Bearer \(oktaCredentials.idToken)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            
            if let error = error {
                NSLog("Error getting all profiles: \(error)")
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                NSLog("Returned status code is not the expected 200. Instead it is \(response.statusCode)")
            }
            
            guard let data = data else {
                NSLog("No data returned from getting all profiles")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let profiles = try decoder.decode([Profile].self, from: data)
                
                DispatchQueue.main.async {
                    self.profiles = profiles
                }
            } catch {
                NSLog("Unable to decode [Profile] from data: \(error)")
            }
        }
        
        dataTask.resume()
    }
    
    /// called in checkForExistingAuthenticatedUserProfile (below)
    /// - Parameter completion: fetches the authenticated user's profile and stores it in profile variable in ProfileController
    func getAuthenticatedUserProfile(completion: @escaping () -> Void = { }) {
        var oktaCredentials: OktaCredentials
        
        do {
            oktaCredentials = try oktaAuth.credentialsIfAvailable()
        } catch {
            postAuthenticationExpiredNotification()
            NSLog("Credentials do not exist. Unable to get authenticated user profile from API")
            DispatchQueue.main.async {
                completion()
            }
            return
        }
        
        guard let userID = oktaCredentials.userID else {
            NSLog("User ID is missing.")
            DispatchQueue.main.async {
                completion()
            }
            return
        }
        
        getSingleProfile(userID) { (profile) in
            self.authenticatedUserProfile = profile
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    /// called in checkForExistingProfile in LoginVC
    /// - Parameter completion: returns a Bool indicating whether the authenticated user profile was successfully fetched
    func checkForExistingAuthenticatedUserProfile(completion: @escaping (Bool) -> Void) {
        getAuthenticatedUserProfile {
            completion(self.authenticatedUserProfile != nil)
        }
    }
    
    /// called in getAuthenticatedUserProfile (above) to fetch a profile from Okta
    /// - Parameters:
    ///   - userID: accepts a userID
    ///   - completion: if successful, returns a user profile
    func getSingleProfile(_ userID: String, completion: @escaping (Profile?) -> Void) {
        
        var oktaCredentials: OktaCredentials
        
        do {
            oktaCredentials = try oktaAuth.credentialsIfAvailable()
        } catch {
            postAuthenticationExpiredNotification()
            NSLog("Credentials do not exist. Unable to get profile from API")
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
        let requestURL = baseURL
            .appendingPathComponent("profiles")
            .appendingPathComponent(userID)
        var request = URLRequest(url: requestURL)
        
        request.addValue("Bearer \(oktaCredentials.idToken)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            var fetchedProfile: Profile?
            
            defer {
                DispatchQueue.main.async {
                    completion(fetchedProfile)
                }
            }
            
            if let error = error {
                NSLog("Error getting all profiles: \(error)")
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                NSLog("Returned status code is not the expected 200. Instead it is \(response.statusCode)")
            }
            
            guard let data = data else {
                NSLog("No data returned from getting all profiles")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let profile = try decoder.decode(Profile.self, from: data)
                fetchedProfile = profile
            } catch {
                NSLog("Unable to decode Profile from data: \(error)")
            }
        }
        
        dataTask.resume()
    }
    
    /// could be used to update a user profile in Okta, unused in this project
    func updateAuthenticatedUserProfile(_ profile: Profile, with name: String, email: String, avatarURL: URL, completion: @escaping (Profile) -> Void) {
        
        var oktaCredentials: OktaCredentials
        
        do {
            oktaCredentials = try oktaAuth.credentialsIfAvailable()
        } catch {
            postAuthenticationExpiredNotification()
            NSLog("Credentials do not exist. Unable to get authenticated user profile from API")
            DispatchQueue.main.async {
                completion(profile)
            }
            return
        }
        
        let requestURL = baseURL
            .appendingPathComponent("profiles")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(oktaCredentials.idToken)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONEncoder().encode(profile)
        } catch {
            NSLog("Error encoding profile JSON: \(error)")
            DispatchQueue.main.async {
                completion(profile)
            }
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            var profile = profile
            
            defer {
                DispatchQueue.main.async {
                    completion(profile)
                }
            }
            
            if let error = error {
                NSLog("Error adding profile: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                NSLog("Returned status code is not the expected 200. Instead it is \(response.statusCode)")
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from updating profile")
                return
            }
            
            do {
                profile = try JSONDecoder().decode(ProfileWithMessage.self, from: data).profile
                self.authenticatedUserProfile = profile
            } catch {
                NSLog("Error decoding `ProfileWithMessage`: \(error)")
            }
        }
        
        dataTask.resume()
    }
    
    // NOTE: This method is unused, but left as an example for creating a profile.
    
    func createProfile(with email: String, name: String, avatarURL: URL) -> Profile? {
        var oktaCredentials: OktaCredentials
        
        do {
            oktaCredentials = try oktaAuth.credentialsIfAvailable()
        } catch {
            postAuthenticationExpiredNotification()
            NSLog("Credentials do not exist. Unable to create a profile for the authenticated user")
            return nil
        }
        
        guard let userID = oktaCredentials.userID else {
            NSLog("Credentials do not exist. Unable to create profile")
            return nil
        }
        return Profile(id: userID, email: email, name: name, avatarURL: avatarURL)
    }
    
    // NOTE: This method is unused, but left as an example for creating a profile on the scaffolding backend.
    
    func addProfile(_ profile: Profile, completion: @escaping () -> Void) {
        
        var oktaCredentials: OktaCredentials
        
        do {
            oktaCredentials = try oktaAuth.credentialsIfAvailable()
        } catch {
            postAuthenticationExpiredNotification()
            NSLog("Credentials do not exist. Unable to add profile to API")
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("profiles")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("Bearer \(oktaCredentials.idToken)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONEncoder().encode(profile)
        } catch {
            NSLog("Error encoding profile: \(profile)")
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            
            if let error = error {
                NSLog("Error adding profile: \(error)")
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                NSLog("Returned status code is not the expected 200. Instead it is \(response.statusCode)")
                return
            }
            
            self.profiles.append(profile)
        }
        dataTask.resume()
    }
    
    /// could be used to fetch the avatar image associated with the user
    /// unused in this project due to the avatarURLs of test users not being present or functional
    func image(for url: URL, completion: @escaping (UIImage?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            var fetchedImage: UIImage? = nil
            
            defer {
                DispatchQueue.main.async {
                    completion(fetchedImage)
                }
            }
            if let error = error {
                NSLog("Error fetching image for url: \(url.absoluteString), error: \(error)")
                return
            }
            
            guard let data = data,
                let image = UIImage(data: data) else {
                    return
            }
            fetchedImage = image
        }
        dataTask.resume()
    }
    
    func postAuthenticationExpiredNotification() {
        NotificationCenter.default.post(name: .oktaAuthenticationExpired, object: nil)
    }
}
