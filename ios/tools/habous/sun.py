"""Small NOAA/Meeus solar calculator: event times in minutes after 00:00 UTC of the given date."""
import math
R = math.radians; D = math.degrees

def jd(y, m, d):
    if m <= 2: y -= 1; m += 12
    A = y // 100; B = 2 - A + A // 4
    return int(365.25 * (y + 4716)) + int(30.6001 * (m + 1)) + d + B - 1524.5

def sun(jdx):
    t = (jdx - 2451545.0) / 36525
    L0 = (280.46646 + t * (36000.76983 + 0.0003032 * t)) % 360
    M = 357.52911 + t * (35999.05029 - 0.0001537 * t)
    e = 0.016708634 - t * (0.000042037 + 0.0000001267 * t)
    C = (math.sin(R(M)) * (1.914602 - t * (0.004817 + 0.000014 * t)) + math.sin(R(2 * M)) * (0.019993 - 0.000101 * t)
         + math.sin(R(3 * M)) * 0.000289)
    om = 125.04 - 1934.136 * t
    lam = L0 + C - 0.00569 - 0.00478 * math.sin(R(om))
    eps = 23 + (26 + (21.448 - t * (46.815 + t * (0.00059 - t * 0.001813))) / 60) / 60 + 0.00256 * math.cos(R(om))
    dec = D(math.asin(math.sin(R(eps)) * math.sin(R(lam))))
    yv = math.tan(R(eps / 2)) ** 2
    eot = 4 * D(yv * math.sin(2 * R(L0)) - 2 * e * math.sin(R(M)) + 4 * e * yv * math.sin(R(M)) * math.cos(2 * R(L0))
                - 0.5 * yv * yv * math.sin(4 * R(L0)) - 1.25 * e * e * math.sin(2 * R(M)))
    return dec, eot

def transit(y, m, d, lng):
    j0 = jd(y, m, d); tt = 720 - 4 * lng
    for _ in range(3):
        _, eot = sun(j0 + tt / 1440); tt = 720 - 4 * lng - eot
    return tt

def at_altitude(y, m, d, lat, lng, alt, after):
    """Time the sun's centre is at `alt` degrees, before (after=False) or after transit."""
    j0 = jd(y, m, d); tt = transit(y, m, d, lng); ev = tt + (1 if after else -1) * 360
    for _ in range(4):
        dec, eot = sun(j0 + ev / 1440)
        c = (math.sin(R(alt)) - math.sin(R(lat)) * math.sin(R(dec))) / (math.cos(R(lat)) * math.cos(R(dec)))
        H = D(math.acos(max(-1, min(1, c))))
        tr = 720 - 4 * lng - eot
        ev = tr + (4 * H if after else -4 * H)
    return ev

def asr_alt(y, m, d, lat, lng, shadow=1):
    j0 = jd(y, m, d); dec, _ = sun(j0 + transit(y, m, d, lng) / 1440)
    return D(math.atan(1 / (shadow + math.tan(abs(R(lat - dec))))))

def raw_times(y, m, d, lat, lng, fajr=19, isha=17, horizon=0.833):
    a = asr_alt(y, m, d, lat, lng)
    return [at_altitude(y, m, d, lat, lng, -fajr, False), at_altitude(y, m, d, lat, lng, -horizon, False),
            transit(y, m, d, lng), at_altitude(y, m, d, lat, lng, a, True),
            at_altitude(y, m, d, lat, lng, -horizon, True), at_altitude(y, m, d, lat, lng, -isha, True)]
