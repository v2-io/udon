# Props: stones and inkwells

Cut from `source-stones-and-inkwells.jpg` (Gemini, 2026-10-29) for the UDON specimen pages. Each PNG keeps the object at full opacity and its shadow as black at partial alpha, so the shadow darkens whatever ground the object is placed on.

## How they're made

The work is done one object at a time, because no single rule finds the true edge of every object in the photo:

1. `split.py source-stones-and-inkwells.jpg <dir>` cuts each whole object into its own file, with a margin for its shadow. Beside each crop it writes a `.json` with the object's box inside the crop and any settings for that object alone. Objects cut off by the photo's edge are skipped. The grey stone is skipped too: its body is too close in value to its own shadow.
2. `cutone.py <crop.png> <out.png>` processes one crop, following Joseph's recipe (2026-10-29):
   - **A hard mask of the object, not feathered.** The silhouette is traced (for inkwells, an ellipse fitted to it, since they're round from above), smoothed, and set 2 px inside the photo's blended rim. Supersampling gives each edge pixel its true coverage.
   - **The background's leftovers clamped.** Just outside the mask, rim pixels are replaced with the paper or shadow beyond them.
   - **The background made transparent by its white level.** Shadows stay as black at partial alpha, and each fades out before reaching its neighbors in the photo.
   - **For dark stones, one edge model all round the outline.** The photo's white paper lit the stones' rims: a glow from the sides and above, and bounce light from below, which a stone lit from above can't have.
     - All round, the edge starts at 60% of the stone's local body tone and eases up to that tone over 16 px. A pebble seen from above darkens toward its silhouette, where its surface faces sideways.
     - Underneath, the edge tone blends smoothly by angle into the underside's own tone, never below its darkest. Only the outermost pixel or two dip to that darkest tone.
     - Every correction multiplies the existing pixels by a factor that varies smoothly with the local average, so the grain survives. It reaches every pixel the stone covers at all.
   - **For inkwells, an inset shadow along the inner edge,** about 5 px deep, which also takes out the photo's white rim light.
   - **Last, for stones, a soft drop shadow** (offset 5 px down, blurred 6 px, 38%), merged with the photo's own shadow, so they sit on the ground rather than hovering.

   Because the photo is lit from above, place these cutouts upright or turned only a few degrees. Rotate a dark stone much and its lit top swings round to the side.

   The filename says whether the object is `dark` or `pale`, and the two are segmented differently. The paper level comes from the crop's own border.
3. `review.sh <out.png> <review.png>` shows the result whole on slate and on paper, plus its four edges at 3× on slate. Check each one before using it.
4. `profile.py <out.png>` prints, for a dark stone composited on slate, its darkest body tone and the values along seven lines into its edge, from top round to the right (from 8 px outside to 24 px in). These are the numbers to calibrate the edge against. Calibrated 2026-10-29 against Joseph's colorimeter readings of the page: the round stone's darkest tone, 26–28.

Settings for single objects live in `split.py`'s list. For example, `stone-dark-flat` gets a lower dark cut (`T: 95`), because its contact shadow is darker than the cut the stone would set for itself. For every stone, the dark cut applies only below its middle: the light in the photo comes from above, so shadows fall below, and a stone's lit top edge meets clean paper.
