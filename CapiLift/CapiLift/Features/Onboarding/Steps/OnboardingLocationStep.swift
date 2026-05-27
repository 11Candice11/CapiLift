//
//  OnboardingLocationStep.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import SwiftUI
import MapKit

struct OnboardingLocationStep: View {
    @Binding var profile: OnboardingProfile
    @StateObject private var searchVM = LocationSearchViewModel()
    @State private var showSuggestions = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LCSpacing.lg) {
                VStack(alignment: .leading, spacing: LCSpacing.xs) {
                    Text("Where do you live?")
                        .font(.lcTitle)
                        .foregroundStyle(Color.lcText)
                    Text("We'll use this to find colleagues near you.")
                        .font(.lcCallout)
                        .foregroundStyle(Color.lcMuted)
                }

                // Search field
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color.lcMuted)
                        TextField("Search your address...", text: $searchVM.query)
                            .font(.lcBody)
                            .autocorrectionDisabled()
                            .onChange(of: searchVM.query) { _, _ in
                                showSuggestions = !searchVM.query.isEmpty
                            }
                        if !searchVM.query.isEmpty {
                            Button {
                                searchVM.query = ""
                                showSuggestions = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Color.lcMuted)
                            }
                        }
                    }
                    .padding(LCSpacing.sm)
                    .background(Color.lcCard)
                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
                    .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)

                    // Suggestions dropdown
                    if showSuggestions && !searchVM.suggestions.isEmpty {
                        VStack(spacing: 0) {
                            ForEach(searchVM.suggestions, id: \.self) { suggestion in
                                Button {
                                    searchVM.selectSuggestion(suggestion) { address, lat, lng in
                                        profile.homeAddress = address
                                        profile.homeLat = lat
                                        profile.homeLng = lng
                                        searchVM.query = address
                                        showSuggestions = false
                                    }
                                } label: {
                                    HStack(spacing: LCSpacing.sm) {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundStyle(Color.lcGreen)
                                            .font(.system(size: 18))
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(suggestion.title)
                                                .font(.lcBodyBold)
                                                .foregroundStyle(Color.lcText)
                                            Text(suggestion.subtitle)
                                                .font(.lcCaption)
                                                .foregroundStyle(Color.lcMuted)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, LCSpacing.sm)
                                    .padding(.vertical, LCSpacing.sm)
                                }
                                if suggestion != searchVM.suggestions.last {
                                    Divider().padding(.leading, 44)
                                }
                            }
                        }
                        .background(Color.lcCard)
                        .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                    }
                }

                // Map preview
                Map(position: .constant(.region(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: profile.homeLat,
                        longitude: profile.homeLng
                    ),
                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                )))) {
                    Marker("Home", coordinate: CLLocationCoordinate2D(
                        latitude: profile.homeLat,
                        longitude: profile.homeLng
                    ))
                    .tint(.green)
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)

                // Selected address chip
                if !profile.homeAddress.isEmpty {
                    HStack(spacing: LCSpacing.xs) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.lcGreen)
                        Text(profile.homeAddress)
                            .font(.lcCaption)
                            .foregroundStyle(Color.lcText)
                            .lineLimit(2)
                    }
                    .padding(LCSpacing.sm)
                    .background(Color.lcGreen.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
                }
            }
            .padding(.horizontal, LCSpacing.md)
        }
    }
}
