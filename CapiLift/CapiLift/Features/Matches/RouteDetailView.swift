//
//  RouteDetailView.swift
//  CapiLift
//

import SwiftUI
import MapKit

struct RouteDetailView: View {
    let match: MockMatch
    @Environment(\.dismiss) private var dismiss
    @State private var showChat = false
    @State private var pickupAtHome = true
    @State private var quietRide    = false

    private var dropoffTime: String {
        guard let pickup = parseTime(match.pickupTime) else { return match.pickupTime }
        let dropoff = pickup.addingTimeInterval(Double(match.estimatedDurationMins) * 60)
        return formatTime(dropoff)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.white.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // ── Map hero ─────────────────────────────────────────
                    RouteMapView(
                        driverCoordinate: match.driverCoordinate,
                        campusCoordinate: match.campusCoordinate
                    )
                    .frame(height: 260)
                    .ignoresSafeArea(edges: .top)

                    // ── White card sheet ─────────────────────────────────
                    VStack(alignment: .leading, spacing: 0) {

                        // Driver row
                        HStack(spacing: LCSpacing.sm) {
                            ZStack(alignment: .bottomTrailing) {
                                Circle()
                                    .fill(Color.lcGreen.opacity(0.12))
                                    .frame(width: 56, height: 56)
                                    .overlay {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 26))
                                            .foregroundStyle(Color.lcGreen.opacity(0.5))
                                    }
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 14, height: 14)
                                    .overlay { Circle().stroke(Color.white, lineWidth: 2) }
                                    .offset(x: 2, y: 2)
                            }

                            VStack(alignment: .leading, spacing: 3) {
                                Text(match.driverName)
                                    .font(.lcTitle3)
                                    .foregroundStyle(Color.lcText)
                                Text(match.carDescription)
                                    .font(.lcCaption)
                                    .foregroundStyle(Color.lcMuted)
                            }

                            Spacer()

                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Color(hex: "F5A623"))
                                Text(String(format: "%.1f", match.driverRating))
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Color.lcText)
                            }
                            .padding(.horizontal, LCSpacing.sm)
                            .padding(.vertical, 6)
                            .background(Color(hex: "FFF8EC"))
                            .clipShape(Capsule())
                        }
                        .padding(LCSpacing.md)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
                        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
                        .padding(.horizontal, LCSpacing.md)
                        .offset(y: -28)
                        .padding(.bottom, -28)

                        // ── Details block ────────────────────────────────
                        VStack(alignment: .leading, spacing: LCSpacing.md) {

                            // Time row
                            HStack(spacing: LCSpacing.sm) {
                                ZStack {
                                    Circle()
                                        .fill(Color.lcGreen.opacity(0.1))
                                        .frame(width: 36, height: 36)
                                    Image(systemName: "clock")
                                        .font(.system(size: 15))
                                        .foregroundStyle(Color.lcGreen)
                                }
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Scheduled Time")
                                        .font(.lcCaption)
                                        .foregroundStyle(Color.lcMuted)
                                    Text("\(match.pickupTime) → \(dropoffTime)")
                                        .font(.lcBodyBold)
                                        .foregroundStyle(Color.lcText)
                                }
                            }

                            Divider()

                            // Duration row
                            HStack {
                                Text("Est. Duration")
                                    .font(.lcCallout)
                                    .foregroundStyle(Color.lcText)
                                Spacer()
                                Text("\(match.estimatedDurationMins) Mins")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(Color.lcGreen)
                                    .padding(.horizontal, LCSpacing.sm)
                                    .padding(.vertical, 5)
                                    .background(Color.lcGreen.opacity(0.1))
                                    .clipShape(Capsule())
                            }

                            // Impact score card
                            ZStack {
                                RoundedRectangle(cornerRadius: LCRadius.lg)
                                    .fill(Color.lcCoral)

                                // Faint badge watermark
                                Image(systemName: "bolt.circle.fill")
                                    .font(.system(size: 90))
                                    .foregroundStyle(.white.opacity(0.06))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, LCSpacing.md)

                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 6) {
                                        HStack(spacing: 6) {
                                            Image(systemName: "leaf.fill")
                                                .font(.system(size: 11))
                                                .foregroundStyle(.white.opacity(0.9))
                                            Text("IMPACT SCORE")
                                                .font(.system(size: 11, weight: .bold))
                                                .foregroundStyle(.white.opacity(0.9))
                                                .tracking(1)
                                        }
                                        Text(String(format: "%.1fkg", match.co2Saved))
                                            .font(.system(size: 40, weight: .bold, design: .rounded))
                                            .foregroundStyle(.white)
                                        Text("CO2 emissions saved")
                                            .font(.lcCaption)
                                            .foregroundStyle(.white.opacity(0.8))
                                    }
                                    Spacer()
                                }
                                .padding(LCSpacing.md)
                            }
                            .frame(maxWidth: .infinity)

                        }
                        .padding(.horizontal, LCSpacing.md)
                        .padding(.top, LCSpacing.xl + LCSpacing.sm)
                        .padding(.bottom, LCSpacing.md)

                        // ── Route preferences ────────────────────────────
                        VStack(alignment: .leading, spacing: LCSpacing.sm) {
                            Text("Route Preferences")
                                .font(.lcTitle3)
                                .foregroundStyle(Color.lcText)
                                .padding(.horizontal, LCSpacing.md)

                            VStack(spacing: 0) {
                                PreferenceRow(
                                    icon: "mappin.and.ellipse",
                                    label: "Pickup at home address",
                                    isToggle: false,
                                    checkValue: $pickupAtHome
                                )

                                Divider()
                                    .padding(.leading, 48)

                                PreferenceRow(
                                    icon: "person.2",
                                    label: "Quiet ride preferred",
                                    isToggle: true,
                                    checkValue: $quietRide
                                )
                            }
                            .padding(.horizontal, LCSpacing.md)
                        }
                        .padding(.bottom, LCSpacing.xl)
                    }
                    .background(Color.white)
                }
            }
            .ignoresSafeArea(edges: .top)

            // ── Nav bar overlay ──────────────────────────────────────────
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.lcText)
                        .frame(width: 36, height: 36)
                        .background(.white.opacity(0.9))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
                }

                Spacer()

                Text("Route Details")
                    .font(.lcBodyBold)
                    .foregroundStyle(Color.lcText)

                Spacer()

                Button {} label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.lcText)
                        .frame(width: 36, height: 36)
                        .background(.white.opacity(0.9))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
                }
            }
            .padding(.horizontal, LCSpacing.md)
            .padding(.top, 56)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: LCSpacing.sm) {
                // Confirm Request
                Button {} label: {
                    Text("Confirm Request")
                        .font(.lcBodyBold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, LCSpacing.md)
                        .background(Color.lcGreen)
                        .clipShape(Capsule())
                }

                // Message driver
                Button {
                    showChat = true
                } label: {
                    Text("Message \(match.driverName.components(separatedBy: " ").first ?? match.driverName)")
                        .font(.lcBodyBold)
                        .foregroundStyle(Color.lcGreen)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, LCSpacing.md)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .overlay {
                            Capsule()
                                .stroke(Color.lcGreen, lineWidth: 1.5)
                        }
                }
            }
            .padding(.horizontal, LCSpacing.md)
            .padding(.top, LCSpacing.sm)
            .padding(.bottom, LCSpacing.lg)
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showChat) {
            ChatView(match: match)
        }
    }

    // MARK: - Helpers

    private func parseTime(_ string: String) -> Date? {
        let f = DateFormatter()
        f.dateFormat = "hh:mm a"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f.date(from: string)
    }

    private func formatTime(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "hh:mm a"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f.string(from: date)
    }
}

// MARK: - Map subview

private struct RouteMapView: UIViewRepresentable {
    let driverCoordinate: CLLocationCoordinate2D
    let campusCoordinate: CLLocationCoordinate2D

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.isScrollEnabled = false
        map.isZoomEnabled   = false
        map.isPitchEnabled  = false
        map.mapType         = .standard
        map.delegate        = context.coordinator

        let home   = MKPointAnnotation(); home.coordinate   = driverCoordinate; home.title   = "home"
        let campus = MKPointAnnotation(); campus.coordinate = campusCoordinate; campus.title = "campus"
        map.addAnnotations([home, campus])

        let coords  = [driverCoordinate, campusCoordinate]
        let polyline = MKPolyline(coordinates: coords, count: coords.count)
        map.addOverlay(polyline)

        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude:  (driverCoordinate.latitude  + campusCoordinate.latitude)  / 2,
                longitude: (driverCoordinate.longitude + campusCoordinate.longitude) / 2
            ),
            span: MKCoordinateSpan(latitudeDelta: 0.12, longitudeDelta: 0.12)
        )
        map.setRegion(region, animated: false)
        return map
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator() }

    final class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let r = MKPolylineRenderer(overlay: overlay)
            r.strokeColor = UIColor(Color.lcGreen)
            r.lineWidth   = 3
            r.lineDashPattern = [8, 5]
            return r
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.canShowCallout = false

            if annotation.title == "home" {
                let circle = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
                circle.backgroundColor = UIColor(Color.lcGreen)
                circle.layer.cornerRadius = 16
                circle.layer.borderWidth  = 3
                circle.layer.borderColor  = UIColor.white.cgColor
                let icon = UIImageView(image: UIImage(systemName: "house.fill"))
                icon.tintColor = .white
                icon.frame = CGRect(x: 7, y: 7, width: 18, height: 18)
                icon.contentMode = .scaleAspectFit
                circle.addSubview(icon)
                view.addSubview(circle)
                view.frame = circle.frame
                view.centerOffset = CGPoint(x: 0, y: -16)
            } else {
                let circle = UIView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
                circle.backgroundColor = UIColor(Color.lcCoral)
                circle.layer.cornerRadius = 14
                circle.layer.borderWidth  = 3
                circle.layer.borderColor  = UIColor.white.cgColor
                view.addSubview(circle)
                view.frame = circle.frame
                view.centerOffset = CGPoint(x: 0, y: -14)
            }
            return view
        }
    }
}

// MARK: - Preference Row

private struct PreferenceRow: View {
    let icon: String
    let label: String
    let isToggle: Bool
    @Binding var checkValue: Bool

    var body: some View {
        HStack(spacing: LCSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundStyle(Color.lcMuted)
                .frame(width: 24)

            Text(label)
                .font(.lcCallout)
                .foregroundStyle(Color.lcText)

            Spacer()

            if isToggle {
                Toggle("", isOn: $checkValue)
                    .labelsHidden()
                    .tint(Color.lcGreen)
            } else {
                Image(systemName: checkValue ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundStyle(checkValue ? Color.lcGreen : Color.lcBorder)
                    .onTapGesture { checkValue.toggle() }
            }
        }
        .padding(.vertical, LCSpacing.sm)
    }
}
