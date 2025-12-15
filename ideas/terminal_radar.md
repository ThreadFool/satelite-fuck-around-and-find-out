# Terminal Radar (PPI) – Logic & Program Structure

This document describes the core **logic** and the recommended **program structure**
for building a **terminal-based rotating radar (PPI)** using ADS-B data (SBS-1 stream).

The goal is a **text-mode radar** with:
- a circular scope
- a rotating sweep line
- moving aircraft dots
- all positions relative to the receiver

---

## 1. Input Data (ADS-B / SBS-1)

### Source
- TCP stream from `dump1090-fa`
- Port: `30003`
- Format: **SBS-1 BaseStation**

Example line:
MSG,3,111,11111,48C2AF,...,38000,...,50.45915,19.00417,...

### Required fields
For each aircraft:
- `hex` (ICAO address)
- `latitude`
- `longitude`
- `altitude` (optional)
- `lastSeen` timestamp

### Processing rules
- Ignore messages without position (`lat/lon`)
- Keep **only the latest position per aircraft**
- Remove aircraft not seen for *N* seconds (e.g. 60 s)

---

## 2. Radar Math (Relative Positioning)

Each aircraft position must be converted from **absolute coordinates**
to **relative polar coordinates** centered on the receiver.

### Inputs
- Receiver position: `(lat0, lon0)`
- Aircraft position: `(lat1, lon1)`

### Outputs
- `distance` (kilometers)
- `bearing` (degrees, 0–360, clockwise from North)

### Formulas
- Distance: **Haversine**
- Bearing:

bearing = atan2(
sin(Δlon) * cos(lat1),
cos(lat0) * sin(lat1) − sin(lat0) * cos(lat1) * cos(Δlon)
)

Normalize bearing to `0–360°`.

---

## 3. Screen Projection (Radar Geometry)

The terminal screen is treated as a **2D grid of characters**.

### Radar model
- Square grid (e.g. `41 × 41`)
- Center point `(cx, cy)`
- Radar radius `R = min(width, height) / 2`
- Maximum range `maxRangeKm`

### Mapping polar → cartesian
For each aircraft:
r = (distance / maxRangeKm) * R
x = cx + r * sin(bearing)
y = cy - r * cos(bearing)


### Constraints
- If `distance > maxRangeKm` → do not draw
- Clip points that fall outside the grid

---

## 4. Sweep Line (Rotating Beam)

The sweep simulates a classic radar PPI rotation.

### State
- `sweepAngle` (degrees)
- Rotation speed (e.g. `+2° per frame`)

### Rendering
- Draw a line from the center `(cx, cy)`
- Angle = `sweepAngle`
- Length = radar radius
- Update angle each frame:
sweepAngle = (sweepAngle + delta) % 360

Optional:
- Leave a short fading trail
- Highlight aircraft near the sweep line

---

## 5. Render Loop (Real-Time Update)

The radar runs in a continuous **render loop**.

### Frame cycle
1. Clear screen buffer
2. Draw radar circle
3. Draw sweep line
4. Draw aircraft dots
5. Render buffer to terminal
6. Sleep for frame timing (e.g. 40–50 ms)

### Frame rate
- 20–25 FPS is sufficient
- Must be independent from ADS-B input rate

### Terminal control
- ANSI escape codes:
  - Clear screen
  - Move cursor
- No external UI required

---

# Program Structure (Recommended)


RadarApp
├─ SbsListener
│ └─ Reads TCP 30003 stream
│ └─ Updates aircraft state
│
├─ AircraftStore
│ └─ Thread-safe map (hex → aircraft)
│ └─ Cleanup of stale aircraft
│
├─ RadarMath
│ └─ Distance calculation
│ └─ Bearing calculation
│
├─ RadarRenderer
│ └─ Screen buffer
│ └─ Circle, sweep, dots drawing
│
└─ MainLoop
└─ Controls FPS
└─ Advances sweep
└─ Triggers rendering

### Design principles
- **Single process**
- **Two threads minimum**:
  - input (ADS-B)
  - rendering
- Rendering must never block input
- All coordinates are relative to the receiver

---

## Result

The final output is a **classic radar PPI**, fully rendered in the terminal,
with smooth sweep animation and real-time aircraft motion — without
web UI, HTTP servers, or external frontends.
