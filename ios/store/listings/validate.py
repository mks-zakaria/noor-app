#!/usr/bin/env python3
"""Check every locale file against Apple's field limits before anything is pushed.

App Store Connect rejects an over-length field with a generic 409, one locale at a
time, so a bad character count costs a round trip per mistake. Counting here is
free. Run: python3 validate.py
"""
import json
import pathlib
import sys
import unicodedata

HERE = pathlib.Path(__file__).parent

# Apple's limits, in characters (not bytes).
LIMITS = {
    "name": 30,
    "subtitle": 30,
    "keywords": 100,
    "promotionalText": 170,
    "description": 4000,
    "whatsNew": 4000,
}
REQUIRED = set(LIMITS)

# Every App Store localization Apple offers, as of 2026.
ALL_LOCALES = [
    "ar-SA", "ca", "cs", "da", "de-DE", "el", "en-AU", "en-CA", "en-GB", "en-US",
    "es-ES", "es-MX", "fi", "fr-CA", "fr-FR", "he", "hi", "hr", "hu", "id",
    "it", "ja", "ko", "ms", "nl-NL", "no", "pl", "pt-BR", "pt-PT", "ro",
    "ru", "sk", "sv", "th", "tr", "uk", "vi", "zh-Hans", "zh-Hant",
]


def load_all() -> dict:
    """Merge every group file into one locale → fields map, resolving `extends`.

    Regional twins (en-GB/en-AU/en-CA, es-MX, fr-CA, pt-BR) run the same copy as
    their parent and differ only in a field or two, so they name a parent with
    `extends` and override what actually differs. Everything downstream sees a
    fully resolved locale.
    """
    merged = {}
    for path in sorted(HERE.glob("*.json")):
        data = json.loads(path.read_text(encoding="utf-8"))
        for locale, fields in data.items():
            if locale in merged:
                print(f"DUPLICATE: {locale} defined twice (second in {path.name})")
            merged[locale] = fields

    def resolve(locale: str, seen: frozenset = frozenset()) -> dict:
        fields = dict(merged[locale])
        parent = fields.pop("extends", None)
        if parent is None:
            return fields
        if parent in seen or parent not in merged:
            raise SystemExit(f"{locale}: bad `extends` → {parent}")
        return {**resolve(parent, seen | {locale}), **fields}

    return {locale: resolve(locale) for locale in merged}


def width(text: str) -> int:
    """Count the way App Store Connect counts: NFC code points, combining marks
    included.

    This used to skip combining marks, on the theory that Apple counts a mark as
    part of its base character the way the editor renders it. It does not. Hindi
    keywords measured 92 here and were rejected live with "Keywords for Hindi
    cannot be longer than 100 characters" — Apple saw 102, the raw NFC count.
    Devanagari matras and Thai vowel signs each cost a character, so scripts that
    lean on them have far less room than a rendered-glyph count suggests.
    """
    return len(unicodedata.normalize("NFC", text))


def main() -> int:
    listings = load_all()
    problems = []

    missing = [loc for loc in ALL_LOCALES if loc not in listings]
    extra = [loc for loc in listings if loc not in ALL_LOCALES]
    if missing:
        problems.append(f"missing locales ({len(missing)}): {', '.join(missing)}")
    if extra:
        problems.append(f"unknown locales: {', '.join(extra)}")

    for locale in sorted(listings):
        fields = listings[locale]
        for field in sorted(REQUIRED - set(fields)):
            problems.append(f"{locale}: missing field '{field}'")
        for field, value in sorted(fields.items()):
            if field not in LIMITS:
                problems.append(f"{locale}: unknown field '{field}'")
                continue
            n = width(value)
            if n > LIMITS[field]:
                problems.append(
                    f"{locale}.{field}: {n}/{LIMITS[field]} — over by {n - LIMITS[field]}"
                    f"  →  {value[:60]!r}"
                )
            if not value.strip():
                problems.append(f"{locale}.{field}: empty")

    # Keywords are a comma-separated list; Apple counts the separators too, and a
    # space after a comma is a wasted character.
    for locale in sorted(listings):
        kw = listings[locale].get("keywords", "")
        if ", " in kw:
            problems.append(f"{locale}.keywords: spaces after commas waste characters")

    print(f"{len(listings)} locales checked against {len(ALL_LOCALES)} expected\n")
    if problems:
        for p in problems:
            print("  ✗ " + p)
        print(f"\n{len(problems)} problem(s)")
        return 1

    print("  ✓ every field within Apple's limits")
    for locale in sorted(listings):
        f = listings[locale]
        print(
            f"  {locale:8} name {width(f['name']):2}/30  "
            f"sub {width(f['subtitle']):2}/30  "
            f"kw {width(f['keywords']):3}/100  "
            f"promo {width(f['promotionalText']):3}/170  "
            f"desc {width(f['description']):4}/4000"
        )
    return 0


if __name__ == "__main__":
    sys.exit(main())
