import Foundation
import ArtApp

protocol ArtDetailsInputProtocol {
    func getArtDetails(with artId: Int)
}

protocol ArtDetailsOutputProtocol: AnyObject {
    func showArtDetails(with artDetailsModel: ArtDetailsSetupModel)
    func showErrorAlert(with alertErrorModel: AlertErrorModel)
}

final class ArtDetailsViewModel: ArtDetailsInputProtocol {
    // MARK: - Dependency
    private let getArtDetailsUseCase: ArtDetailsProtocol
    weak var viewController: ArtDetailsOutputProtocol?

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
                    viewController?.showArtDetails(with: artDetailsModel)

                case .failure(let error):
                    handleArtDetailsError(error)
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

    private func handleArtDetailsError(_ error: ArtDetailsError) {
        switch error {
        case .connection:
            showAlertError(with: .init(
                title: "Oops 😪",
                description: "It seems that you have no internet connection.",
                confirmButtonTitle: "Ok"
            ))
        case .invalidData, .unexpected:
            showAlertError(with: .init(
                title: "Oops 😪",
                description: "Something wrong happened.",
                confirmButtonTitle: "Try Again"
            ))
        }
    }

    private func showAlertError(with alertErrorModel: AlertErrorModel) {
        let alertErrorModel: AlertErrorModel = .init(
            title: alertErrorModel.title,
            description: alertErrorModel.description,
            confirmButtonTitle: alertErrorModel.confirmButtonTitle
        )
        viewController?.showErrorAlert(with: alertErrorModel)
    }
}
