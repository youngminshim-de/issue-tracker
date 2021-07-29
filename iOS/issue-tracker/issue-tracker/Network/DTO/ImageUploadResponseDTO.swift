import Foundation

struct ImageUploadResponseDTO: Decodable {
    
    let data: ImageUploadDTO?
    let success: Bool?
    let status: Int?
    
}

struct ImageUploadDTO: Decodable {
    
    let link: String?
    
}
