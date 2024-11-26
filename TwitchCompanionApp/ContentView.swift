import SwiftUI

// Define the Follower struct
struct Follower: Identifiable {
    let id: String
    let name: String
}

class TwitchAPI {
    private let clientID = "rgm70mt2reh57ov42x5wo9ruvx2cvn"
    private let clientSecret = "2qtflz9t6dzy8wo0u6x78xdbdqowce"

    func fetchAccessToken(completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://id.twitch.tv/oauth2/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Add the required parameters
        let params = "client_id=\(clientID)&client_secret=\(clientSecret)&grant_type=client_credentials"
        request.httpBody = params.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // Make the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching token: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            // Parse the response
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let accessToken = json["access_token"] as? String {
                    completion(accessToken)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error parsing token response: \(error)")
                completion(nil)
            }
        }.resume()
    }

    func fetchFollowers(accessToken: String, userID: String, completion: @escaping ([[String: Any]]?) -> Void) {
        let url = URL(string: "https://api.twitch.tv/helix/users/follows?to_id=\(userID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Add required headers
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue(clientID, forHTTPHeaderField: "Client-ID")

        // Make the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching followers: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            // Parse the response
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let followerData = json["data"] as? [[String: Any]] {
                    completion(followerData)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error parsing follower response: \(error)")
                completion(nil)
            }
        }.resume()
    }

    func fetchUserInfo(accessToken: String, completion: @escaping ([String: Any]?) -> Void) {
        let url = URL(string: "https://api.twitch.tv/helix/users?login=davidkairu")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Add the required headers
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue(clientID, forHTTPHeaderField: "Client-ID")

        // Make the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching user info: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            // Parse the response
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(json)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error parsing user info response: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

struct ContentView: View {
    @State private var profileImageURL: String = ""
    @State private var viewCount: Int = 0
    @State private var displayName: String = "Fetching..."
    @State private var followers: [Follower] = [] // Array of Follower structs
    @State private var followerCount: Int = 0

    var body: some View {
        VStack {
            // Profile Image
            if let imageURL = URL(string: profileImageURL), !profileImageURL.isEmpty {
                AsyncImage(url: imageURL) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else if phase.error != nil {
                        Text("Failed to load image")
                    } else {
                        ProgressView()
                    }
                }
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 100, height: 100)
            }

            // Display Name
            Text("Display Name: \(displayName)")
                .font(.headline)
                .padding()

            // View Count
            Text("View Count: \(viewCount)")
                .padding()

            // Follower Count
            Text("Followers: \(followerCount)")
                .font(.title2)
                .padding()

            // Recent Followers
            Text("Recent Followers:")
                .font(.headline)
                .padding(.top)

            List(followers) { follower in
                Text(follower.name)
            }

            // Fetch Followers Button
            Button("Fetch Follower Metrics") {
                fetchFollowerMetrics()
            }
            .padding()
        }
        .onAppear {
            fetchFollowerMetrics()
        }
    }

    func fetchFollowerMetrics() {
        let api = TwitchAPI()
        api.fetchAccessToken { token in
            if let token = token {
                // Fetch user info first to get the user ID
                api.fetchUserInfo(accessToken: token) { userInfo in
                    if let userData = userInfo?["data"] as? [[String: Any]],
                       let firstUser = userData.first {
                        DispatchQueue.main.async {
                            self.displayName = firstUser["display_name"] as? String ?? "Unknown"
                            self.viewCount = firstUser["view_count"] as? Int ?? 0
                            self.profileImageURL = firstUser["profile_image_url"] as? String ?? ""
                        }

                        // Fetch followers for the user ID
                        let userID = firstUser["id"] as? String ?? ""
                        api.fetchFollowers(accessToken: token, userID: userID) { followerData in
                            if let followerData = followerData {
                                DispatchQueue.main.async {
                                    self.followers = followerData.compactMap { data in
                                        if let id = data["from_id"] as? String,
                                           let name = data["from_name"] as? String {
                                            return Follower(id: id, name: name)
                                        }
                                        return nil
                                    }
                                    self.followerCount = self.followers.count
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
