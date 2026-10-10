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
| `islam/mihrab_lattice.webp` | 449537 | Mihrab (Prayer Niche) | 755 AH / 1354–55 CE | Iran | Mosaic of polychrome-glazed cut tiles | Islamic Art | `true` | [449537](https://www.metmuseum.org/art/collection/search/449537) |
| `islam/mihrab_hood.webp` | 449537 | *(vault crop of the same mihrab)* | 755 AH / 1354–55 CE | Iran | Mosaic of polychrome-glazed cut tiles | Islamic Art | `true` | [449537](https://www.metmuseum.org/art/collection/search/449537) |
| `islam/mihrab_field_band.webp` | 449537 | *(lower field crop of the same mihrab)* | 755 AH / 1354–55 CE | Iran | Mosaic of polychrome-glazed cut tiles | Islamic Art | `true` | [449537](https://www.metmuseum.org/art/collection/search/449537) |
| `islam/lustre_calligraphy.webp` | 447281 | Partial Niche-Form Tile | second half 13th century | Iran | Stonepaste; luster-painted on opaque white glaze | Islamic Art | `true` | [447281](https://www.metmuseum.org/art/collection/search/447281) |
| `islam/lustre_floral.webp` | 447281 | *(lower field crop of the same tile)* | second half 13th century | Iran | Stonepaste; luster-painted on opaque white glaze | Islamic Art | `true` | [447281](https://www.metmuseum.org/art/collection/search/447281) |
| `islam/rug_border.webp` | 458739 | Prayer Rug with Niche Design | late 18th–early 19th century | Turkey | Wool and cotton; symmetrically knotted pile | Islamic Art | `true` | [458739](https://www.metmuseum.org/art/collection/search/458739) |
| `islam/rug_band.webp` | 458739 | *(wide border crop of the same rug)* | late 18th–early 19th century | Turkey | Wool and cotton; symmetrically knotted pile | Islamic Art | `true` | [458739](https://www.metmuseum.org/art/collection/search/458739) |
| `islam/bowl_rays.webp` | 449544 | Bowl | 9th–10th century | present-day Uzbekistan | Earthenware; white slip with polychrome slip decoration | Islamic Art | `true` | [449544](https://www.metmuseum.org/art/collection/search/449544) |

## Hindu

| Asset | Object | Title | Date | Culture | Medium | Dept | `isPublicDomain` | Source |
|---|---|---|---|---|---|---|---|---|
| `hindu/tent_panel_band.webp` | 453054 | Floral Tent Panel | ca. 1635 | India | Silk, gold; cut velvet, painted | Islamic Art | `true` | [453054](https://www.metmuseum.org/art/collection/search/453054) |
| `hindu/floral_arch.webp` | 453054 | *(single-arch crop of the same panel)* | ca. 1635 | India | Silk, gold; cut velvet, painted | Islamic Art | `true` | [453054](https://www.metmuseum.org/art/collection/search/453054) |
| `hindu/shawl_paisley_band.webp` | 359318 | Motif from Kashmir Shawl: Pheerozee (Turquoise Color), No. 23 | ca. 1822–23 | *(not stated; Kashmir shawl design)* | Gouache on paper, varnished | Drawings and Prints | `true` | [359318](https://www.metmuseum.org/art/collection/search/359318) |
| `hindu/jali_lattice.webp` | 453344 | Pierced Window Screen (Jali) | second half 16th century | India | Red sandstone; pierced, carved | Islamic Art | `true` | [453344](https://www.metmuseum.org/art/collection/search/453344) |
| `hindu/patola_ikat.webp` | 308007 | Indian Trade Cloth (Patola) | 19th century or earlier | India, Gujarat region | Silk | The Michael C. Rockefeller Wing | `true` | [308007](https://www.metmuseum.org/art/collection/search/308007) |
| `hindu/sari_border.webp` | 127540 | Sari | 19th century | India | Silk, metal thread | Asian Art | `true` | [127540](https://www.metmuseum.org/art/collection/search/127540) |
| `hindu/marble_jali.webp` | 453241 | Pierced Window Screen (Jali) | early 17th century | India | Marble | Islamic Art | `true` | [453241](https://www.metmuseum.org/art/collection/search/453241) |
| `hindu/marble_jali_band.webp` | 453241 | *(wide crop of the same screen)* | early 17th century | India | Marble | Islamic Art | `true` | [453241](https://www.metmuseum.org/art/collection/search/453241) |
| `hindu/carpet_field.webp` | 446646 | Carpet with Scrolling Vines and Blossoms | ca. 1650 | Northern India or Pakistan | Silk and pashmina wool pile | Islamic Art | `true` | [446646](https://www.metmuseum.org/art/collection/search/446646) |
| `hindu/carpet_border.webp` | 446646 | *(border crop of the same carpet)* | ca. 1650 | Northern India or Pakistan | Silk and pashmina wool pile | Islamic Art | `true` | [446646](https://www.metmuseum.org/art/collection/search/446646) |
| `hindu/carpet_band.webp` | 446646 | *(wide field crop of the same carpet)* | ca. 1650 | Northern India or Pakistan | Silk and pashmina wool pile | Islamic Art | `true` | [446646](https://www.metmuseum.org/art/collection/search/446646) |
| `hindu/carpet_medallion.webp` | 446646 | *(medallion crop of the same carpet)* | ca. 1650 | Northern India or Pakistan | Silk and pashmina wool pile | Islamic Art | `true` | [446646](https://www.metmuseum.org/art/collection/search/446646) |

### Slot assignment

Resolution lives in `lib/core/art/artwork.dart` as a single pure switch over
`(FaithId, ArtSlot)`. Slots are positional, not per-feature, so the same code
path serves Dhikr under Islam and Japa under Hindu.

| Slot | Islam | Hindu |
|---|---|---|
| `practiceHero` | `illumination_band` | `tent_panel_band` |
| `practiceTile1` | `star_tile` | `marble_jali` |
| `practiceTile2` | `lustre_calligraphy` | `sari_border` |
| `practiceTile3` | `lamp_enamel` | `jali_lattice` |
| `practiceTile4` | `bowl_rays` | `carpet_border` |
| `narrativeHeader` | `rug_band` | `shawl_paisley_band` |
| `scriptureHeader` | `mihrab_field_band` | `carpet_band` |
| `todayGoal` | `mihrab_lattice` | `carpet_field` |
| `emptyBookmarks` | `illumination_corner` | `floral_arch` |
| `emptyFavorites` | `tile_interlace` | `carpet_medallion` |
| `emptyHistory` | `lustre_floral` | `patola_ikat` |
| `emptySearch` | `mihrab_hood` | `marble_jali_band` |
| `emptyCollection` | `rug_border` | `carpet_border` |
| `emptyDormant` | `lamp_band` | `marble_jali` |

**No object appears twice on one screen.** The Practice tab renders its
masthead, every grid tile and its closing panel simultaneously, so those six
slots resolve to six different museum objects under each faith. A test
(`artwork_test.dart`, group `variety`) enforces this rather than leaving it to
care, because a remapped slot would otherwise reintroduce the repetition
silently.

Under Islam all fourteen slots resolve to fourteen distinct files. Under Hindu
there are two deliberate reuses — `carpet_border` serves `practiceTile4` and
`emptyCollection`, and `marble_jali` serves `practiceTile1` and
`emptyDormant`. Neither pair can co-occur: the Hindu Practice grid has only
three tiles, so `practiceTile4` is never rendered at all, and an empty state
never shares a screen with the Practice grid.

**Colour ground was chosen for contrast, not just availability.** The original
twelve were overwhelmingly lapis-and-gold. The set now spans turquoise and
cobalt tile mosaic (449537), olive and cream lustre (447281), deep red and
indigo wool (458739), cream, ochre and black slipware (449544), white marble
(453241) and crimson with teal (446646).

---

## Judgment calls worth knowing about

**Two Hindu-slot objects are filed by the Met under *Islamic Art*. This was
raised, considered, and deliberately kept — it is not an oversight.**

`453054` (Floral Tent Panel) and `453344` (Pierced Window Screen) are both
made in India, in the Mughal period. The Met catalogues them by patronage
rather than by geography, which is a **curatorial filing convention, not a
statement about the objects themselves**. A department name describes how a
museum organises its storerooms; it does not make a stone screen carved in
sixteenth-century India into a religious statement about anyone who looks at
it.

The motifs carry no religious marking in either direction: a gold floral
arcade and a geometric pierced lattice. A stone jali behind a Temples card is
apt regardless of which department catalogued it — jali screens are a
feature of Indian architecture across traditions, and the geometry is the
point.

The alternative was to restrict the Hindu set to objects the Met files under
Asian Art with Hindu provenance. In practice that means figurative sculpture
and painting — deities, saints, human figures — which is exactly the content
the rule at the top of this file forbids. Choosing the departmental label
over the content rule would have meant breaking the rule that actually
matters in order to satisfy one that does not.

Recorded here so the next reader sees a decision rather than an accident.

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
| 446166 — Tile from a Frieze (mina'i) | **Title and medium give no hint.** The molded turquoise relief resolves at full size into two facing stylized quadrupeds with legs and bodies. Figurative; rejected on sight. |
| 948753 — Maharana Raj Singh II receiving courtiers | Figurative, and a named historical ruler. |
| 452310 — Fragment of an Animal Carpet | Animals. |
| 450322 — Tile Fragment | Eroded to bare clay across most of its surface; almost no decoration survives. Rejected on quality. |
| 449562, 450362 | Both `primaryImage` files are **monochrome archival photographs**, not colour. Same flaw as 455054 — rejected on quality, not content. |
| 452912 — Textile Fragment | Photographed through glass; glare streaks and the mount board are visible across the piece. Rejected on quality. |
| 24306, 24298, 31681, 449568 (and other arms) | Weapons, and a carved steatite penbox too plain to read at tile size. |
| 457791 — Ka'ba Tile | **Non-figurative, and still rejected.** It depicts the Ka'ba. The rule is not merely "no human figures" — it is that nothing may read as a religious *representation*, and a building that is itself an object of orientation in prayer plainly does. Decoration drawn from a sanctuary is fine; a picture of the sanctuary is not. |
| 450358 — Luster Star-Shaped Tile | Innocuous title, but the record is tagged Birds / Kings / Women. |
| 781487 — Portuguese Goa Carpet | Tagged tigers. |
| 447583 — Garden Carpet | Passed every tag filter, but Persian garden carpets routinely carry fish and birds in the water channels — not worth the per-crop risk when alternatives exist. |
| 453587 — Coptic Manuscript | Non-figurative, but a Christian liturgical text has no business in either faith's slot. |
| AIC 180287 — "Patolu" | Metadata and title read as pure geometry; at zoom the field is densely figurative (elephants with riders, human figures, tigers). Caught only by looking. |

### A partially zoomorphic source, used for its abstract region only

`449544` (Bowl, 9th–10th c.) was the single best piece in the set for colour —
cream, ochre, black and coral, exactly the warm contrast the lapis-heavy
original set lacked. Its **centre is not usable**: the interlace knot at the
bowl's base resolves into almond eyes and stylized bird heads, which is a
creature form and fails the rule.

The shipped crop (`bowl_rays.webp`) is taken from the rim and the radiating
band **above** the centre, and stops well short of it — the bowl is 1570×1536
with the knot filling roughly a 500px circle around (785, 768), and the crop
ends at y=510. The result is purely abstract: dotted rim, radiating bars, no
figure.

This is the same principle as taking an illuminated border from a manuscript
whose painted scenes are figurative: **the rule applies to what ships, not to
what the object contains**. Anyone re-cropping this source must re-check it,
because moving the frame down by a couple of hundred pixels breaks the rule.

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
