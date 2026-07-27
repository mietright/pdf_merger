## [Unreleased]

## [2.1.0] - 2026-07-21

### Added

- `merge` now accepts an optional `rotations:` array (clockwise degrees, aligned by index with `file_urls`).
  When provided, it is forwarded to the pdfserve `/merge` endpoint as repeated `rotations` query params.
  Omitting it preserves the previous behaviour exactly.

## [1.0.0] - 2024-05-29

### Added

- Changing the way we initialize the gem

  We require the endpoint and token in the initializer and the method `merge` is receiving the array of urls and the output path as params.


## [0.1.0] - 2024-05-23

- Initial release

