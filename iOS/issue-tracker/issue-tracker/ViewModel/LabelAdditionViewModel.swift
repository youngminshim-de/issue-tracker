import Foundation
import Combine

class LabelAdditionViewModel {

    @Published private var isCorrectColor: Bool
    @Published private var isEnableSaveButton: Bool
    @Published private var backgroundColor: String
    @Published private var resultMessage: String?
    private var id: Int?
    private var title: String
    private var description: String?
    private let additionUseCase: AdditionUseCase
    
    init() {
        self.isCorrectColor = true
        self.isEnableSaveButton = false
        self.backgroundColor = "#FFFFFF"
        self.resultMessage = nil
        self.id = nil
        self.title = ""
        self.description = nil
        self.additionUseCase = AdditionUseCase()
    }
    
    func updateLabel() {
        if let id = self.id {
            additionUseCase.executeEditingLabel(makeNewLabelDTO(), labelID: id) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let resultMessage):
                    self.resultMessage = resultMessage
                }
            }
        } else {
            additionUseCase.executeAddingLabel(makeNewLabelDTO()) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let resultMessage):
                    self.resultMessage = resultMessage
                }
            }
        }
    }
    
    func configureTitle(_ title: String) {
        self.title = title
        self.isEnableSaveButton = self.isCorrectColor && isNotEmptyTitle()
    }
    
    func configureDescription(_ description: String) {
        self.description = description
    }
    
    func configureBackgroundColor(_ color: String) {
        self.isCorrectColor = isCorrect(color: color)
        if isCorrectColor {
            self.backgroundColor = color.uppercased()
        }
        self.isEnableSaveButton = self.isCorrectColor && isNotEmptyTitle()
    }
    
    //MARK: 편집할 때는 바로 저장 버튼 활성화
    func configureExistingLabel(_ label: DetailLabel) {
        self.id = label.id
        self.title = label.title
        self.description = label.content
        self.backgroundColor = label.color
        self.isEnableSaveButton = true
    }
    
    func didUpdateResultMessage() -> AnyPublisher<String?, Never> {
        return $resultMessage
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func didUpdateCorrectColor() -> AnyPublisher<Bool, Never> {
        return $isCorrectColor
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func didUpdateSaveButton() -> AnyPublisher<Bool, Never> {
        return $isEnableSaveButton
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func didUpdateBackgroundColor() -> AnyPublisher<String, Never> {
        return $backgroundColor
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func isNotEmptyTitle() -> Bool {
        return self.title.isEmpty == false
    }
    
    private func isCorrect(color: String) -> Bool {
        return isCorrectFirstString(color)
            && isCorrectStringCount(color)
            && isCorrectColorRange(color)
    }
    
    private func isCorrectFirstString(_ string: String) -> Bool {
        if let firstString = string.first, firstString == "#" {
            return true
        } else {
            return false
        }
    }
    
    private func isCorrectStringCount(_ string: String) -> Bool {
        return string.count == 7
    }
    
    private func isCorrectColorRange(_ string: String) -> Bool {
        let colorString = string.uppercased().dropFirst()
        for character in colorString {
            if character < "0" || character > "F" {
                return false
            }
        }
        return true
    }
    
    func makeRandomColor() -> String {
        let hexArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
                        "A", "B", "C", "D", "E", "F"]
        var randomColor = "#"
        
        for _ in 0...5 {
            randomColor += hexArray.randomElement() ?? "F"
        }
        
        self.isCorrectColor = true
        self.backgroundColor = randomColor
        return randomColor
    }
    
    func isColorDark() -> Bool {
        let hexColor = self.backgroundColor.dropFirst()
        var rgbArray: [Float] = []
        
        for index in 0...2 {
            let first = hexColor.index(hexColor.startIndex, offsetBy: index * 2)
            let last = hexColor.index(hexColor.startIndex, offsetBy: index * 2 + 1)
            let subString = hexColor[first...last]
            if let decimal = Int(subString, radix: 16) {
                rgbArray.append(Float(decimal))
            }
        }
        
        return (rgbArray[0] * 0.299 + rgbArray[1] * 0.587 + rgbArray[2] * 0.114) <= 186
    }
    
    func makeNewLabelDTO() -> NewLabelDTO {
        return NewLabelDTO(title: self.title, content: self.description, color: self.backgroundColor)
    }
    
}
