//
//  OnboardingLocationStep.swift
//  CapiLift
//

import SwiftUI
import MapKit

struct OnboardingLocationStep: View {
    @Binding var profile: OnboardingProfile
    @StateObject private var searchVM = LocationSearchViewModel()
    @State private var showSuggestions = false
    @State private var searchTouched = false
    @State private var mapPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -33.9249, longitude: 18.4241),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ))

    var isAddressConfirmed: Bool { !profile.homeAddress.isEmpty }
    var notesCount: Int { profile.driverNotes.count }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: LCSpacing.lg) {

                // ── Title ────────────────────────────────────────────
                VStack(alignment: .leading, spacing: LCSpacing.xs) {
                    Text("Where do you live?")
                        .font(.lcTitle)
                        .foregroundStyle(Color.lcText)
                    Text("Help us match you with the best carpools in your area.")
                        .font(.lcCallout)
                        .foregroundStyle(Color.lcMuted)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(3)
                }

                // ── Map with auto-detect pill ─────────────────────────
                ZStack(alignment: .bottom) {
                    Map(position: $mapPosition) {
                        if isAddressConfirmed {
                            Annotation("", coordinate: CLLocationCoordinate2D(
                                latitude: profile.homeLat, longitude: profile.homeLng
                            )) {
                                ZStack {
                                    Circle()
                                        .fill(Color.lcSecondary.opacity(0.3))
                                        .frame(width: 48, height: 48)
                                    Image(systemName: "mappin.fill")
                                        .font(.system(size: 28))
                                        .foregroundStyle(Color.lcSecondary)
                                }
                            }
                        }
                    }
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
                    .allowsHitTesting(false)

                    // Auto-detect pill
                    HStack(spacing: LCSpacing.xs) {
                        Image(systemName: "location.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.lcGreen)
                        Text(isAddressConfirmed ? profile.homeAddress : "Auto-detecting...")
                            .font(.lcCaption)
                            .foregroundStyle(Color.lcText)
                            .lineLimit(1)
                    }
                    .padding(.horizontal, LCSpacing.md)
                    .padding(.vertical, LCSpacing.xs)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
                    .padding(.bottom, LCSpacing.sm)
                }

                // ── Address field ────────────────────────────────────
                VStack(alignment: .leading, spacing: LCSpacing.xs) {
                    Text("Home Address")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.lcGreen)

                    VStack(spacing: 0) {
                        HStack(spacing: LCSpacing.sm) {
                            Image(systemName: "house")
                                .font(.system(size: 15))
                                .foregroundStyle(Color.lcMuted)

                            TextField("Street, City, Postcode", text: $searchVM.query)
                                .font(.lcBody)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.words)
                                .onChange(of: searchVM.query) { _, newVal in
                                    searchTouched = true
                                    showSuggestions = !newVal.isEmpty
                                    if newVal != profile.homeAddress { profile.homeAddress = "" }
                                }

                            if !searchVM.query.isEmpty {
                                Button {
                                    searchVM.query = ""
                                    profile.homeAddress = ""
                                    showSuggestions = false
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(Color.lcMuted)
                                }
                            }
                        }
                        .padding(.vertical, LCSpacing.sm)

                        Rectangle()
                            .fill(isAddressConfirmed ? Color.lcGreen : Color.lcBorder)
                            .frame(height: 1)

                        // Suggestions
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
                                            withAnimation {
                                                mapPosition = .region(MKCoordinateRegion(
                                                    center: CLLocationCoordinate2D(latitude: lat, longitude: lng),
                                                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                                ))
                                            }
                                        }
                                    } label: {
                                        HStack(spacing: LCSpacing.sm) {
                                            Image(systemName: "mappin.circle.fill")
                                                .foregroundStyle(Color.lcGreen)
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(suggestion.title).font(.lcBodyBold).foregroundStyle(Color.lcText)
                                                if !suggestion.subtitle.isEmpty {
                                                    Text(suggestion.subtitle).font(.lcCaption).foregroundStyle(Color.lcMuted)
                                                }
                                            }
                                            Spacer()
                                        }
                                        .padding(.horizontal, LCSpacing.sm)
                                        .padding(.vertical, LCSpacing.sm)
                                    }
                                    .buttonStyle(.plain)
                                    if suggestion != searchVM.suggestions.last {
                                        Divider().padding(.leading, 44)
                                    }
                                }
                            }
                            .background(Color.lcCard)
                            .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                            .padding(.top, 4)
                        }
                    }
                }

                // ── Pickup same as home ───────────────────────────────
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Pickup is the same as home")
                            .font(.lcBodyBold)
                            .foregroundStyle(Color.lcText)
                        Text("Your driver will meet you at your doorstep.")
                            .font(.lcCaption)
                            .foregroundStyle(Color.lcMuted)
                    }
                    Spacer()
                    Toggle("", isOn: $profile.pickupSameAsHome)
                        .tint(Color.lcGreen)
                        .labelsHidden()
                }
                .padding(LCSpacing.md)
                .background(Color.lcGreen.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))

                // ── Notes for driver ─────────────────────────────────
                VStack(alignment: .leading, spacing: LCSpacing.xs) {
                    Text("NOTES FOR THE DRIVER")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.lcGreen)
                        .tracking(1.2)

                    ZStack(alignment: .topLeading) {
                        if profile.driverNotes.isEmpty {
                            Text("e.g. Please wait near the blue gate, I'll be wearing a red cap...")
                                .font(.lcBody)
                                .foregroundStyle(Color.lcMuted)
                                .padding(.horizontal, LCSpacing.xs)
                                .padding(.vertical, LCSpacing.xs + 2)
                        }
                        TextEditor(text: $profile.driverNotes)
                            .font(.lcBody)
                            .foregroundStyle(Color.lcText)
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 90)
                            .onChange(of: profile.driverNotes) { _, new in
                                if new.count > 200 {
                                    profile.driverNotes = String(new.prefix(200))
                                }
                            }
                    }
                    .padding(LCSpacing.xs)
                    .background(Color.lcCard)
                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
                    .overlay {
                        RoundedRectangle(cornerRadius: LCRadius.md)
                            .stroke(Color.lcBorder, lineWidth: 1)
                    }

                    HStack {
                        Spacer()
                        Text("\(notesCount)/200")
                            .font(.lcCaption)
                            .foregroundStyle(Color.lcMuted)
                    }
                }

                // ── Bonus points banner ───────────────────────────────
                HStack(spacing: LCSpacing.sm) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.lcSecondary)
                    Text("Complete your profile to earn **50 bonus points**!")
                        .font(.lcCaption)
                        .foregroundStyle(Color.lcText)
                }
                .padding(LCSpacing.sm)
                .background(Color.lcSecondary.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
            }
            .padding(.horizontal, LCSpacing.md)
            .padding(.bottom, LCSpacing.lg)
        }
    }
}
