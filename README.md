# AquaSense — Soil Moisture & Irrigation Monitor

A simple Flutter app for a soil-moisture / irrigation controller.

## Features
- Login screen (simple email/password gate)
- Dashboard: live moisture %, circuit on/off switch, disconnect alert banner,
  today's irrigation count, litres used today/total
- Calendar view: irrigation events per day (`table_calendar`)
- History view: full event log grouped by date, separate from the calendar
- Dark mode toggle + 5 accent color variants (top-right of app bar)
- Responsive layout (stat grid adapts columns to screen width)

## Run it
```bash
flutter pub get
flutter run
```

## Connecting your real sensor
All sensor data currently comes from a **simulator** in
`lib/services/sensor_service.dart` so the app runs without hardware.

To connect a real device, edit that one file only — everything else listens
to `SensorService.readings` and doesn't need to change:

- **Bluetooth (BLE):** add `flutter_blue_plus`, connect to your device's
  service/characteristic, and call `_controller.add(SensorReading(...))`
  whenever a notification arrives.
- **WiFi / MQTT:** add `mqtt_client`, subscribe to your sensor's topic
  (e.g. `farm/soil1/moisture`), and forward each payload the same way.
- **HTTP polling:** replace the `Timer.periodic` in `start()` with a call to
  your device's REST endpoint.

The `circuitOn` on/off switch already calls `setCircuitPower()` — wire that
to whatever command turns your relay/circuit on and off.

## Folder structure
```
lib/
  main.dart                 # entry point, theme + provider setup
  app_theme.dart             # light/dark themes, color-seed based
  models/irrigation_event.dart
  services/sensor_service.dart   # <-- swap this for real hardware
  state/app_state.dart       # auth, theme, live data, history
  screens/
    login_screen.dart
    main_scaffold.dart       # bottom nav: Home / Calendar / History
    home_screen.dart
    calendar_screen.dart
    history_screen.dart
  widgets/
    moisture_gauge.dart
    stat_card.dart
```
