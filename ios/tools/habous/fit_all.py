"""Fit the ministry's calculation on its own tables, for all 190 cities.
Unknowns: per city lat, lng, horizon depression (hz); global fractional offsets per prayer.
Loop: (1) fit each city's lat/lng on Fajr, Dhuhr, Asr, Isha; (2) fit hz on sunrise + Maghrib;
(3) re-fit global offsets. Writes habous-cities.json (c, n, lat, lng, hz) and prints match rates."""
import json, math, sys
import numpy as np
import sun
from fit2 import H, DAYS, SAMPLE, rnd

geo = {}
for line in open("geo/geo.tsv"):
    p = line.rstrip("\n").split("\t")
    if len(p) >= 4 and p[2] != "-":
        geo[int(p[0])] = (p[1], float(p[2]), float(p[3]))
names = {c["c"]: c["n"] for c in json.load(open("habous/horaires-2026-11.json"))["villes"]}
print(len(geo), "geocoded of", len(names))
# Cities the geocoder missed: longitude from Dhuhr, latitude by a coarse scan.
for code in names:
    if code in geo: continue
    lng = sum((H[(code, m, d)][2] - 5 - sun.transit(y, m, d, 0)) / -4 for (y, m, d) in SAMPLE) / len(SAMPLE)
    lat = max((core_score_seed(code, la, lng), la) for la in [21 + 0.25 * k for k in range(61)])[1] if False else None
    geo[code] = (names[code], None, lng)

off = [-0.5, -0.2, 5.0, 0.2, 1.1, 0.0]
CORE = (0, 2, 3, 5)

def core_score(code, la, lo, days):
    s = 0
    for (y, m, d) in days:
        h = H[(code, m, d)]; r = sun.raw_times(y, m, d, la, lo)
        s += sum(rnd(r[i] + off[i]) == h[i] for i in CORE)
    return s

def fit_ll(code, la, lo):
    best = (core_score(code, la, lo, SAMPLE), la, lo)
    for step in (0.08, 0.02, 0.005, 0.0015):
        moved = True
        while moved:
            moved = False
            _, a, b = best
            for da in (-step, 0, step):
                for db in (-step, 0, step):
                    if da == db == 0: continue
                    s = core_score(code, a + da, b + db, SAMPLE)
                    if s > best[0]: best = (s, a + da, b + db); moved = True
    return best[1], best[2]

HZ = np.arange(0.833, 3.2, 0.01)

def fit_hz(code, la, lo, days):
    rise = np.array([[sun.at_altitude(y, m, d, la, lo, -hz, False) for (y, m, d) in days] for hz in HZ])
    sset = np.array([[sun.at_altitude(y, m, d, la, lo, -hz, True) for (y, m, d) in days] for hz in HZ])
    hr = np.array([H[(code, m, d)][1] for (y, m, d) in days]); hs = np.array([H[(code, m, d)][4] for (y, m, d) in days])
    sc = (np.floor(rise + off[1] + .5) == hr).sum(1) + (np.floor(sset + off[4] + .5) == hs).sum(1)
    top = np.flatnonzero(sc == sc.max())
    return float(HZ[top[len(top) // 2]]), rise, sset, hr, hs   # middle of the best plateau

# Seed every city from its own timetable; keep the geocoder's point only if it fits better.
def data_seed(code):
    lng = sum((H[(code, m, d)][2] - 5 - sun.transit(y, m, d, 0)) / -4 for (y, m, d) in SAMPLE) / len(SAMPLE)
    la = max((core_score(code, 20 + 0.2 * k, lng, SAMPLE), 20 + 0.2 * k) for k in range(81))[1]
    return la, lng
for code in sorted(names):
    n = names[code]
    seeds = [data_seed(code)]
    if code in geo and geo[code][1] is not None: seeds.append(geo[code][1:])
    fits = [fit_ll(code, a, b) for a, b in seeds]
    best = max(fits, key=lambda ab: core_score(code, ab[0], ab[1], DAYS))
    geo[code] = (n, best[0], best[1])
print("seeded all from data")
cities = {}
for it in range(1):
    raw = {}
    for code, (n, la, lo) in sorted(geo.items()):
        la0, lo0 = (cities[code]["lat"], cities[code]["lng"]) if code in cities else (la, lo)
        la2, lo2 = fit_ll(code, la0, lo0)
        hz, *_ = fit_hz(code, la2, lo2, SAMPLE)
        cities[code] = dict(c=code, n=names[code], lat=round(la2, 4), lng=round(lo2, 4), hz=round(hz, 3),
                            moved_km=round(math.hypot((la2 - la) * 111, (lo2 - lo) * 111 * math.cos(math.radians(la))), 1))
        raw[code] = [(sun.raw_times(y, m, d, la2, lo2, horizon=hz), H[(code, m, d)]) for (y, m, d) in DAYS]
    # global offsets per prayer
    for i in range(6):
        cands = np.arange(off[i] - 0.6, off[i] + 0.61, 0.02)
        scores = [sum(rnd(r[i] + o) == h[i] for v in raw.values() for r, h in v) for o in cands]
        off[i] = round(float(cands[int(np.argmax(scores))]), 2)
    tot = [0] * 6; within1 = [0] * 6; n = 0
    for v in raw.values():
        for r, h in v:
            n += 1
            for i in range(6):
                dd = abs(rnd(r[i] + off[i]) - h[i]); tot[i] += dd == 0; within1[i] += dd <= 1
    print(f"iter {it}: offsets {off}")
    print("  exact  ", [f"{t / n:.1%}" for t in tot])
    print("  <=1 min", [f"{t / n:.1%}" for t in within1])

json.dump(sorted(cities.values(), key=lambda c: c["c"]), open("habous-cities.json", "w"), ensure_ascii=False, indent=0)
json.dump(off, open("habous-offsets.json", "w"))
far = sorted(cities.values(), key=lambda c: -c["moved_km"])[:10]
print("largest moves from geocoder (check these):", [(c["n"], c["moved_km"]) for c in far])
