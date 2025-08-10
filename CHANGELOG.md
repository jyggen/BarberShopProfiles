# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.4] - 2025-08-10
### Changed
- Bump TOC version to `110200`.

### Fixed
- Adapt to breaking changes in 11.2.0.
- The selected profile would not be retained when switching body types.
- Dialogues would not react to keyboard events as expected.

## [1.2.3] - 2025-03-02
### Changed
- Bump TOC version to `110100`.

### Fixed
- Use `CustomizationFrameWithTooltipTemplate` instead of `CharCustomizeFrameWithTooltipTemplate`.

## [1.2.2] - 2025-01-07
### Changed
- Bump TOC version to `110007`.

## [1.2.1] - 2024-01-17
### Changed
- Bump TOC version to `100205`.

### Fixed
- Creating a new profile will now populate the dropdown properly if there are no other profiles.

## [1.2.0] - 2023-12-16
### Added
- The list of profiles will now be paginated when it contains over 25 profiles.

## [1.1.1] - 2023-12-15
### Changed
- Bump TOC version to `100200`.

## [1.1.0] - 2023-03-12
### Added
- A flag indicating if the profile is for the race's alternate form or not will
  now be stored when saving a profile. This will ensure that a profile for e.g. the
  Dracthyr's dragon form won't show up when customizing its visage form and vice
  versa. Please note that profiles saved with an earlier version of the addon will
  have to be saved again in order to make use of this feature.

### Changed
- Bump TOC version to `100007`.

## [1.0.8] - 2022-10-26
### Changed
- Bump TOC version to `100000`.

## Fixed
- The icons of the buttons should no longer fill the entire screen.
- The addon should now load 3rd-party libraries in correct order.

## [1.0.7] - 2022-03-01
### Changed
- Bump TOC version to `90200`.

## [1.0.6] - 2021-11-04
### Changed
- Bump TOC version to `90105`.

## [1.0.5] - 2021-06-30
### Changed
- Bump TOC version to `90100`.

## [1.0.4] - 2021-03-10
### Changed
- Bump TOC version to `90005`.

## [1.0.3] - 2020-12-17
### Changed
- Bump TOC version to `90002`.

## [1.0.2] - 2020-11-22
### Changed
- A version without libraries is once again published on CurseForge.

## [1.0.1] - 2020-11-22
### Fixed
- CallbackHandler-1.0 should now be embedded properly.

## [1.0.0] - 2020-11-22
### Added
- The character's sex will now be stored when saving a profile and changed automatically
  whenever the profile is loaded. Please note that profiles saved with an earlier version
  of the addon will have to be saved again in order to make use of this feature.

### Changed
- A version without libraries is no longer published on CurseForge.

## [0.2.0] - 2020-11-12
### Added
- A dialog asking for the user's confirmation when overwriting an existing profile.
- Tooltips to all buttons to make it more clear what they do.

### Changed
- The delete dialog will now display the name of the profile being deleted.

## [0.1.0] - 2020-11-11
### Added
- Initial release.

[Unreleased]: https://github.com/jyggen/BarberShopProfiles/compare/1.2.4...HEAD
[1.2.4]: https://github.com/jyggen/BarberShopProfiles/compare/1.2.3...1.2.4
[1.2.3]: https://github.com/jyggen/BarberShopProfiles/compare/1.2.2...1.2.3
[1.2.2]: https://github.com/jyggen/BarberShopProfiles/compare/1.2.1...1.2.2
[1.2.1]: https://github.com/jyggen/BarberShopProfiles/compare/1.2.0...1.2.1
[1.2.0]: https://github.com/jyggen/BarberShopProfiles/compare/1.1.1...1.2.0
[1.1.1]: https://github.com/jyggen/BarberShopProfiles/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/jyggen/BarberShopProfiles/compare/1.0.8...1.1.0
[1.0.8]: https://github.com/jyggen/BarberShopProfiles/compare/1.0.7...1.0.8
[1.0.7]: https://github.com/jyggen/BarberShopProfiles/compare/1.0.6...1.0.7
[1.0.6]: https://github.com/jyggen/BarberShopProfiles/compare/1.0.5...1.0.6
[1.0.5]: https://github.com/jyggen/BarberShopProfiles/compare/1.0.4...1.0.5
[1.0.4]: https://github.com/jyggen/BarberShopProfiles/compare/1.0.3...1.0.4
[1.0.3]: https://github.com/jyggen/BarberShopProfiles/compare/1.0.2...1.0.3
[1.0.2]: https://github.com/jyggen/BarberShopProfiles/compare/1.0.1...1.0.2
[1.0.1]: https://github.com/jyggen/BarberShopProfiles/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/jyggen/BarberShopProfiles/compare/0.2.0...1.0.0
[0.2.0]: https://github.com/jyggen/BarberShopProfiles/compare/0.1.0...0.2.0
[0.1.0]: https://github.com/jyggen/BarberShopProfiles/releases/tag/0.1.0
