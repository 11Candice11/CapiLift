import SwiftUI
import MapKit

struct MatchDetailView: View {
    let match: MockMatch
    @Environment(AuthState.self) private var authState
    @Environment(\.dismiss) private var dismiss
    @State private var showChat = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -33.9249, longitude: 18.8241),
        span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
    )

    var body: some View {
        ZStack(alignment: .top) {
            Color.lcBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Map
                    Map(position: .constant(.region(region))) {
                        Annotation("", coordinate: match.driverCoordinate) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 14, height: 14)
                                .overlay { Circle().stroke(Color.lcGreen, lineWidth: 3) }
                        }
                        Annotation("", coordinate: match.campusCoordinate) {
                            Circle()
                                .fill(Color.lcCoral)
                                .frame(width: 14, height: 14)
                                .overlay { Circle().stroke(.white, lineWidth: 2) }
                        }
                        ForEach(match.pendingPassengers) { p in
                            Annotation("", coordinate: p.coordinate) {
                                ZStack {
                                    Circle()
                                        .fill(Color.lcGreen)
                                        .frame(width: 32, height: 32)
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                    }
                    .frame(height: 300)
                    .ignoresSafeArea(edges: .top)

                    // Bottom sheet
                    VStack(spacing: LCSpacing.lg) {
                        // Drag handle
                        RoundedRectangle(cornerRadius: LCRadius.pill)
                            .fill(Color.lcBorder)
                            .frame(width: 40, height: 4)
                            .padding(.top, LCSpacing.sm)

                        // Route header
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: LCSpacing.xs) {
                                Text("Route to \(match.campus.displayName)")
                                    .font(.lcTitle)
                                    .foregroundStyle(Color.lcText)
                                Text("Morning Commute • \(match.distanceKm, specifier: "%.1f") km")
                                    .font(.lcCallout)
                                    .foregroundStyle(Color.lcMuted)
                            }

                            Spacer()

                            VStack(spacing: 2) {
                                Text("PICKUP")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(.white.opacity(0.8))
                                Text(match.pickupTime)
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                            }
                            .padding(.horizontal, LCSpacing.md)
                            .padding(.vertical, LCSpacing.sm)
                            .background(Color.lcGreen)
                            .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
                        }

                        // Tags
                        HStack(spacing: LCSpacing.sm) {
                            TagChip(
                                icon: "leaf.fill",
                                label: "\(match.co2Saved)kg CO2 Saved",
                                color: .lcGreen
                            )
                            TagChip(
                                icon: "person.2.fill",
                                label: "\(match.openSeats) Open Seats",
                                color: .lcMuted
                            )
                            Spacer()
                        }

                        // Pending requests
                        if !match.pendingPassengers.isEmpty {
                            VStack(alignment: .leading, spacing: LCSpacing.sm) {
                                Text("PENDING REQUESTS")
                                    .font(.lcCaptionBold)
                                    .foregroundStyle(Color.lcMuted)

                                ForEach(match.pendingPassengers) { passenger in
                                    HStack(spacing: LCSpacing.sm) {
                                        Circle()
                                            .fill(Color.lcGreen.opacity(0.15))
                                            .frame(width: 48, height: 48)
                                            .overlay {
                                                Image(systemName: "person.fill")
                                                    .foregroundStyle(Color.lcGreen.opacity(0.5))
                                                    .font(.system(size: 22))
                                            }

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(passenger.name)
                                                .font(.lcBodyBold)
                                                .foregroundStyle(Color.lcText)
                                            HStack(spacing: 4) {
                                                Image(systemName: "location.fill")
                                                    .font(.system(size: 10))
                                                    .foregroundStyle(Color.lcMuted)
                                                Text("\(passenger.distanceKm, specifier: "%.1f") km away")
                                                    .font(.lcCaption)
                                                    .foregroundStyle(Color.lcMuted)
                                            }
                                        }

                                        Spacer()

                                        Button {
                                            // decline
                                        } label: {
                                            Circle()
                                                .fill(Color.lcCoral.opacity(0.12))
                                                .frame(width: 40, height: 40)
                                                .overlay {
                                                    Image(systemName: "xmark")
                                                        .font(.system(size: 14, weight: .semibold))
                                                        .foregroundStyle(Color.lcCoral)
                                                }
                                        }

                                        Button {
                                            // accept
                                        } label: {
                                            Circle()
                                                .fill(Color.lcGreen)
                                                .frame(width: 40, height: 40)
                                                .overlay {
                                                    Image(systemName: "checkmark")
                                                        .font(.system(size: 14, weight: .semibold))
                                                        .foregroundStyle(.white)
                                                }
                                        }
                                    }
                                    .padding(LCSpacing.sm)
                                    .background(Color.lcCard)
                                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
                                    .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
                                }
                            }
                        }

                        // Message button
                        Button {
                            showChat = true
                        } label: {
                            HStack(spacing: LCSpacing.sm) {
                                Image(systemName: "bubble.left.fill")
                                    .font(.system(size: 16))
                                Text("Message Match")
                                    .font(.lcBodyBold)
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, LCSpacing.md)
                            .background(Color.lcGreen)
                            .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
                        }
                        .navigationDestination(isPresented: $showChat) {
                            ChatView(match: match)
                        }

                        // Ride details
                        VStack(alignment: .leading, spacing: LCSpacing.sm) {
                            Text("RIDE DETAILS")
                                .font(.lcCaptionBold)
                                .foregroundStyle(Color.lcMuted)

                            VStack(spacing: LCSpacing.md) {
                                HStack(spacing: LCSpacing.md) {
                                    Image(systemName: "car.fill")
                                        .foregroundStyle(Color.lcGreen)
                                        .frame(width: 24)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(match.carDescription)
                                            .font(.lcBodyBold)
                                            .foregroundStyle(Color.lcText)
                                        Text("License: \(match.licensePlate)")
                                            .font(.lcCaption)
                                            .foregroundStyle(Color.lcMuted)
                                    }
                                }

                                HStack(spacing: LCSpacing.md) {
                                    Image(systemName: "calendar")
                                        .foregroundStyle(Color.lcGreen)
                                        .frame(width: 24)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(match.rideDateFormatted)
                                            .font(.lcBodyBold)
                                            .foregroundStyle(Color.lcText)
                                        Text("Recurring: \(match.recurringDays)")
                                            .font(.lcCaption)
                                            .foregroundStyle(Color.lcMuted)
                                    }
                                }
                            }
                            .padding(LCSpacing.md)
                            .background(Color.lcCard)
                            .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
                            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, LCSpacing.md)
                    .padding(.bottom, LCSpacing.xl)
                    .background(Color.lcBackground)
                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.xl))
                    .offset(y: -LCRadius.xl)
                }
            }
            .scrollIndicators(.hidden)
            .ignoresSafeArea(edges: .top)

            // Nav bar overlay
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: LCSpacing.xs) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Match Details")
                            .font(.lcBodyBold)
                    }
                    .foregroundStyle(Color.lcText)
                    .padding(.horizontal, LCSpacing.sm)
                    .padding(.vertical, LCSpacing.xs)
                    .background(Color.lcBackground.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
                }

                Spacer()

                PointsPill(points: authState.currentUser?.totalPoints ?? 0)
            }
            .padding(.horizontal, LCSpacing.md)
            .padding(.top, 56)
        }
        .navigationBarHidden(true)
    }
}

// MARK: — Tag Chip
private struct TagChip: View {
    let icon: String
    let label: String
    let color: Color

    var body: some View {
        HStack(spacing: LCSpacing.xxs) {
            Image(systemName: icon)
                .font(.system(size: 11))
            Text(label)
                .font(.lcCaptionBold)
        }
        .foregroundStyle(color)
        .padding(.horizontal, LCSpacing.sm)
        .padding(.vertical, LCSpacing.xxs + 2)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
    }
}
