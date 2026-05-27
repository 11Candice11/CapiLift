//
//  LocationSearchViewModel.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import MapKit
import Combine

@MainActor
class LocationSearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var query = ""
    @Published var suggestions: [MKLocalSearchCompletion] = []

    private var completer: MKLocalSearchCompleter

    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        completer.delegate = self
        completer.resultTypes = .address
        // Bias towards South Africa
        completer.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -33.9249, longitude: 18.4241),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )

        $query
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] text in
                if text.isEmpty {
                    self?.suggestions = []
                } else {
                    self?.completer.queryFragment = text
                }
            }
            .store(in: &cancellables)
    }

    private var cancellables = Set<AnyCancellable>()

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        suggestions = Array(completer.results.prefix(5))
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        suggestions = []
    }

    func selectSuggestion(
        _ suggestion: MKLocalSearchCompletion,
        completion: @escaping (String, Double, Double) -> Void
    ) {
        let request = MKLocalSearch.Request(completion: suggestion)
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let item = response?.mapItems.first else { return }
            let address = [
                suggestion.title,
                suggestion.subtitle
            ].filter { !$0.isEmpty }.joined(separator: ", ")
            completion(
                address,
                item.placemark.coordinate.latitude,
                item.placemark.coordinate.longitude
            )
        }
    }
}