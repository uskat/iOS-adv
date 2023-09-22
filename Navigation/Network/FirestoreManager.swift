
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserProfile: Codable {
    @DocumentID var id: String?
    var login: String
    var name: String
    var status: String
}

class FirestoreManager {
    
    let profilesCollection = Firestore.firestore().collection("profiles")
    static let shared = FirestoreManager()
    
    private init() {}
    
    func setData(to login: String, name: String, status: String) {
        // Add a second document with a generated ID.
        var ref: DocumentReference? = nil
        ref = profilesCollection.addDocument(data: [
            "login": login,
            "name": name,
            "status": status
        ]) { error in
            if let error = error {
                print("🚫Error adding document: \(dump(error))")
            } else {
                print("✅Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func getData(for login: String, completion: @escaping (UserProfile?) -> ()) {
        profilesCollection.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                let profile = querySnapshot?.documents.compactMap({ doc in
                    return try? doc.data(as: UserProfile.self)
                })
                let result = profile?.first { $0.login == login }
                completion(result)
            }
        }
    }
    
    func deleteData() {
    }
}
