"""Per-city fit: find the coordinates the ministry used (from Fajr, Dhuhr, Asr, Isha), then the horizon
depression for sunrise/Maghrib, then global fractional offsets. Coordinates start from the geocoder."""
import json, math, sys, statistics
import sun
H = {}
for f in ["habous/horaires-2026-10.json", "habous/horaires-2026-11.json"]:
    j = json.load(open(f))
    for c in j["villes"]:
        for i, row in enumerate(c["h"]):
            H[(c["c"], j["mois"], i + 1)] = [int(t[:2]) * 60 + int(t[3:]) for t in row]
DAYS = [(2026, 10, d) for d in range(1, 32)] + [(2026, 11, d) for d in range(1, 31)]
SAMPLE = DAYS[::3]          # fit on every 3rd day, check on all

def rnd(x): return math.floor(x + 0.5)

def score_core(code, lat, lng, off, days):
    s = 0
    for (y, m, d) in days:
        h = H[(code, m, d)]
        r = sun.raw_times(y, m, d, lat, lng)
        s += sum(rnd(r[i] + off[i]) == h[i] for i in (0, 2, 3, 5))
    return s

def fit_city(code, lat0, lng0, off):
    best = (score_core(code, lat0, lng0, off, SAMPLE), lat0, lng0)
    for step in (0.04, 0.01, 0.0025):
        improved = True
        while improved:
            improved = False
            _, la, lo = best
            for dla in (-step, 0, step):
                for dlo in (-step, 0, step):
                    s = score_core(code, la + dla, lo + dlo, off, SAMPLE)
                    if s > best[0]: best = (s, la + dla, lo + dlo); improved = True
    return best[1], best[2]

def fit_horizon(code, lat, lng, offs, days):
    best = None
    for k in range(0, 41):                     # extra depression 0 .. 2.0 degrees
        hz = 0.833 + k * 0.05; s = 0
        for (y, m, d) in days:
            h = H[(code, m, d)]
            sr = sun.at_altitude(y, m, d, lat, lng, -hz, False); ss = sun.at_altitude(y, m, d, lat, lng, -hz, True)
            s += (rnd(sr + offs[1]) == h[1]) + (rnd(ss + offs[4]) == h[4])
        if not best or s > best[0]: best = (s, hz)
    return best[1]
