# Artwork provenance

Every illustration shipped in `assets/art/` is a public-domain museum object,
cropped and re-encoded for a specific slot. This file is the audit record.

CC0 / public-domain-dedicated works impose **no attribution requirement**, and
the app does not display attribution anywhere. This manifest exists because
Siraat is monetised: if provenance is ever questioned, it has to be answerable
from a committed file rather than reconstructed from memory.

**Verification method.** The licence status of each object was checked
individually against the source API — never inferred from the collection, the
department, or a search term. For The Metropolitan Museum of Art that is the
`isPublicDomain` boolean on `GET /public/collection/v1/objects/{id}`; the value
recorded below is the verbatim field value as returned on 2026-10-10.

Two precisions worth stating, because they are easy to get wrong in an audit:

* `isPublicDomain` is the Met's own designated Open Access flag — the field
  that marks an object's images as released under CC0. It is the right field
  to rely on. The neighbouring `rightsAndReproduction` field is an **empty
  string** on all nine objects below; that is normal for OA records and is
  *not* a licence statement either way. Do not read the empty value as a
  restriction, and do not cite it as the permission.
* A collection-level licence never transferred to any object here. In
  particular, the Art Institute of Chicago's API advertises CC0 in
  `info.license_text`, but that covers **the API metadata, not the artwork
  images**. No AIC image is shipped in this app, so the distinction does not
  bear on anything below — it is recorded so nobody later assumes it would
  have been safe to treat it as one.

> Met API note: the v1 **search** endpoint was retired and now returns HTTP 410.
> Search is `GET /public/collection/v1.1/search` (`offset`/`limit` paginated).
> Object detail is still `GET /public/collection/v1/objects/{id}`.

---

## Content rule applied to every piece

**Nothing figurative.** No prophets, companions, deities, saints, or any human
or divine figure a user could read as a religious representation. Permitted:
geometry, calligraphy, illumination, floral interlace, tiles, lamps,
architecture, textiles.

Every image below was **viewed before selection** — no piece was accepted on
the strength of its title, department, or search term. Pieces rejected on sight
are listed at the end, with the reason.

---

## Islam

| Asset | Object | Title | Date | Culture | Medium | Dept | `isPublicDomain` | Source |
|---|---|---|---|---|---|---|---|---|
| `islam/illumination_band.webp` | 452669 | Illuminated Frontispiece of a Bustan of Saʿdi | 920 AH / 1514 CE | present-day Afghanistan | Ink, opaque watercolor, gold on paper | Islamic Art | `true` | [452669](https://www.metmuseum.org/art/collection/search/452669) |
| `islam/illumination_corner.webp` | 452669 | *(second crop of the same folio)* | 920 AH / 1514 CE | present-day Afghanistan | Ink, opaque watercolor, gold on paper | Islamic Art | `true` | [452669](https://www.metmuseum.org/art/collection/search/452669) |
| `islam/star_tile.webp` | 450428 | Star-Shaped Tile | 13th–14th century | Iran | Stonepaste, luster-painted | Islamic Art | `true` | [450428](https://www.metmuseum.org/art/collection/search/450428) |
| `islam/tile_interlace.webp` | 450428 | *(second crop of the same tile)* | 13th–14th century | Iran | Stonepaste, luster-painted | Islamic Art | `true` | [450428](https://www.metmuseum.org/art/collection/search/450428) |
| `islam/lamp_enamel.webp` | 444718 | Mosque Lamp | 14th century | Egypt (Cairo) or Syria | Glass; blown, enameled, gilded | Islamic Art | `true` | [444718](https://www.metmuseum.org/art/collection/search/444718) |
| `islam/lamp_band.webp` | 444718 | *(wide crop of the same lamp)* | 14th century | Egypt (Cairo) or Syria | Glass; blown, enameled, gilded | Islamic Art | `true` | [444718](https://www.metmuseum.org/art/collection/search/444718) |

## Hindu

| Asset | Object | Title | Date | Culture | Medium | Dept | `isPublicDomain` | Source |
|---|---|---|---|---|---|---|---|---|
| `hindu/tent_panel_band.webp` | 453054 | Floral Tent Panel | ca. 1635 | India | Silk, gold; cut velvet, painted | Islamic Art | `true` | [453054](https://www.metmuseum.org/art/collection/search/453054) |
| `hindu/floral_arch.webp` | 453054 | *(single-arch crop of the same panel)* | ca. 1635 | India | Silk, gold; cut velvet, painted | Islamic Art | `true` | [453054](https://www.metmuseum.org/art/collection/search/453054) |
| `hindu/shawl_paisley_band.webp` | 359318 | Motif from Kashmir Shawl: Pheerozee (Turquoise Color), No. 23 | ca. 1822–23 | *(not stated; Kashmir shawl design)* | Gouache on paper, varnished | Drawings and Prints | `true` | [359318](https://www.metmuseum.org/art/collection/search/359318) |
| `hindu/jali_lattice.webp` | 453344 | Pierced Window Screen (Jali) | second half 16th century | India | Red sandstone; pierced, carved | Islamic Art | `true` | [453344](https://www.metmuseum.org/art/collection/search/453344) |
| `hindu/patola_ikat.webp` | 308007 | Indian Trade Cloth (Patola) | 19th century or earlier | India, Gujarat region | Silk | The Michael C. Rockefeller Wing | `true` | [308007](https://www.metmuseum.org/art/collection/search/308007) |
| `hindu/sari_border.webp` | 127540 | Sari | 19th century | India | Silk, metal thread | Asian Art | `true` | [127540](https://www.metmuseum.org/art/collection/search/127540) |

### Slot assignment

Resolution lives in `lib/core/art/artwork.dart` as a single pure switch over
`(FaithId, ArtSlot)`. Slots are positional, not per-feature, so the same code
path serves Dhikr under Islam and Japa under Hindu.

| Slot | Islam | Hindu |
|---|---|---|
| `practiceHero`, `scriptureHeader` | `illumination_band` | `tent_panel_band` |
| `narrativeHeader` | `lamp_band` | `shawl_paisley_band` |
| `practiceTile1`, `empty` | `star_tile` | `floral_arch` |
| `todayGoal` | `illumination_corner` | `floral_arch` |
| `practiceTile2` | `illumination_corner` | `sari_border` |
| `practiceTile3` | `lamp_enamel` | `jali_lattice` |
| `practiceTile4` | `tile_interlace` | `patola_ikat` |

---

## Judgment calls worth knowing about

**Two Hindu-slot objects are filed by the Met under *Islamic Art*.**
`453054` (Floral Tent Panel) and `453344` (Jali) are both made in India, in the
Mughal period, and the Met classifies them by patronage rather than by
geography. They were chosen anyway, for two reasons: the motifs themselves —
a gold floral arcade and a geometric pierced screen — carry no religious
marking in either direction, and jali geometry was explicitly named as
acceptable subject matter for this slot. The alternative was to restrict the
Hindu set to objects the Met files under Asian Art with Hindu provenance, which
in practice means figurative sculpture and painting — the exact content the
rule above forbids.

If this reads wrong to a reviewer, `453054` and `453344` are the two to swap,
and only those two; the other four Hindu assets are unambiguously Indian
textile and shawl work.

**`359318` has no `culture` field.** It is a Kashmir shawl design drawing held
under Drawings and Prints. Its subject is unambiguously an Indian shawl motif;
its draughtsman is not recorded. Public-domain status is confirmed on the
object itself.

---

## Rejected

| Object | Why |
|---|---|
| 455054 — Haft Paikar, Khamsa of Nizami | **Named in the brief as a confirmed candidate, but unusable.** Its `primaryImage` is a monochrome archival photograph of a text page with one small illuminated header — not painterly, and nothing like the colour illumination the brief expected. Rejected on quality, not content. |
| 126455 — Sari (India, 19th c.) | Contains figurative bands: rows of horse-and-rider figures and a border of birds. The upper floral field is clean, but the piece as a whole fails the rule and better material was available. |
| 24306, 24298, 31681 — Daggers (Mughal) | Non-figurative and public domain, but weapons are wrong for a prayer app. |
| Tibetan / Nepali "mandala" results | The Met and AIC `mandala` and `lotus ornament` searches return overwhelmingly Tibetan Buddhist thangkas with a deity at the centre — fails the content rule — plus Chinese and Japanese decorative work, which is the wrong tradition for the Hindu slot even when non-figurative. |
| 452521 — Pawn in the Form of an Indian Lady | Figurative. |
| AIC 180287 — "Patolu" | Metadata and title read as pure geometry; at zoom the field is densely figurative (elephants with riders, human figures, tigers). Caught only by looking. |

### A note on patola and sari borders specifically

Indian textiles of exactly the kind used here routinely carry figurative rows —
elephants-with-riders, birds, human processions — inside bands that read as
abstract pattern at thumbnail size. `AIC 180287` above is one such trap, and
`126455` is another.

The two shipped assets most exposed to this, `patola_ikat.webp` (308007) and
`sari_border.webp` (127540), were therefore re-rendered at 3× and inspected a
second time **after cropping**, to confirm the shipped region specifically.
`patola_ikat` is diamond-lattice geometry with floral and star fills;
`sari_border` is rows of flowering plants and a rosette band. Neither contains
a figure. Anyone re-cropping either source should repeat that check rather than
trusting the existing crop's clearance.

## Sources that did not work

**Art Institute of Chicago** was the intended primary source for the Hindu half
(50k+ CC0, and the deepest pool of Indian textiles). Its **IIIF image endpoint
sits behind a Cloudflare interstitial**: `https://www.artic.edu/iiif/2/{image_id}/full/843,/0/default.jpg`
returns a 5,690-byte `Just a moment...` HTML challenge page instead of JPEG
bytes, for every object, via plain HTTP clients. The JSON API itself responds
normally — only the images are gated. Every Hindu asset therefore comes from
the Met. If the Hindu set is ever widened, AIC images will need a browser
session or a different mirror.

**Digital Walters** holds complete Islamic manuscripts under CC0 and would suit
the Islam half, but has nothing for the Hindu half. Not needed — the three Met
Islamic objects covered all six Islam slots.
