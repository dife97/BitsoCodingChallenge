import Foundation
import ArtApp

protocol ArtDetailsViewModelProtocol {
    func getArtDetails(with artId: Int)
}

protocol ArtDetailsViewModelDelegate: AnyObject {
    func showArtDetails(with artDetailsModel: ArtDetailsSetupModel)
}

final class ArtDetailsViewModel: ArtDetailsViewModelProtocol {
    // MARK: - Dependency
    private let getArtDetailsUseCase: ArtDetailsProtocol
    weak var delegate: ArtDetailsViewModelDelegate?

    // MARK: - Initializer
    init(getArtDetailsUseCase: ArtDetailsProtocol) {
        self.getArtDetailsUseCase = getArtDetailsUseCase
    }

    // MARK: - Public Method
    func getArtDetails(with artId: Int) {
        getArtDetailsUseCase.execute(model: .init(artId: artId)) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                switch result {
                case .success(let data):
                    let artDetailsModel = getArtDetailsModel(from: data)
                    delegate?.showArtDetails(with: artDetailsModel)

                case .failure(let error):
                    print("FAIL: \(error)")
                }
            }
        }
    }

    private func getArtDetailsModel(from data: ArtDetailsModel) -> ArtDetailsSetupModel {
        let details: ArtDetails = [
            ("Place", data.place),
            ("Date", data.date),
            ("Medium", data.medium),
            ("Inscriptions", data.inscriptions),
            ("Dimensions", data.dimensions),
            ("Credit Line", data.creditLine),
            ("Reference Number", data.referenceNumber)
        ].compactMap { title, value in
            value.map {
                .init(
                    title: title,
                    description: $0
                )
            }
        }

        return .init(
            description: data.description,
            details: details
        )
    }
}
