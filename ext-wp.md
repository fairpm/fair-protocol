# FAIR for WordPress Packages

FAIR for WordPress Packages is an extension to the [FAIR Core specification](./specification) for the WordPress Content Management System (CMS).


## Package Types

This specification provides the following package types and associated semantic meanings:

| Type        | Description                                                  |
| ----------- | ------------------------------------------------------------ |
| `wp-core`   | The WordPress CMS itself, or alternative distributions of it |
| `wp-plugin` | Plugins for the WordPress CMS                                |
| `wp-theme`  | Themes for the WordPress CMS                                 |


## Common

For each of the `wp-core`, `wp-plugin`, and `wp-theme` package types, several definitions are common.

### Metadata Document

#### sections

All common section types specified in FAIR Core and in this specification MAY use HTML formatting. Clients SHOULD perform sanitization on section content to ensure only safe HTML is rendered.


### Release Document

The following are extensions to the Release Document specified in FAIR Core.

#### requires and suggests

The `requires` and `suggests` properties (collectively, dependencies) MAY contain further values specified here.

Dependencies MAY require a certain version of the PHP software, specified as `env:php`.

Dependencies MAY require PHP extensions, specified with a `env:php-` prefix.

Dependencies MAY require the WordPress CMS, specified as `env:wp`.


## Core Package Type

The `wp-core` package type indicates packages containing the WordPress CMS, or alternative distributions of it.


### Release Document

The following are extensions to the Release Document specified in FAIR Core.

#### artifacts

The following artifact types are defined for the `wp-core` type.

##### package

The common `package` type is used for the artifact containing the installable PHP application.

This artifact SHOULD be a zip or tarball archive containing a single directory. Clients SHOULD treat the single directory within the archive as representing the installable PHP application, and MUST NOT rely on this directory having a fixed name.

Repositories SHOULD publish at least one `package` artifact using the `application/zip` MIME type.


## Plugin Package Type

The `wp-plugin` package type indicates plugins compatible with the WordPress CMS.


### Metadata Document

The following are extensions to the Metadata Document specified in FAIR Core.


#### sections

The following keys are specified in addition to the common sections.

The following keys and their semantic meaning are specified:

* `installation` - Instructions to the user on how to install the package.
* `faq` - Frequently asked questions about the package.
* `other_notes` - Miscellaneous additional notes.
* `screenshots` - Preview images of the package's UI.

Additionally, the following are recognised as aliases:

* `change_log` - Alias for `changelog`.
* `frequently_asked_questions` - Alias for `faq`.
* `screenshot` - Alias for `screenshots`.

All section content MAY contain HTML


### Release Document

#### artifacts

The following artifact types are defined for the `wp-plugin` type.


##### package

The common `package` type is used for the artifact containing the installable PHP plugin.

Repositories SHOULD publish at least one `package` artifact using the `application/zip` MIME type. Clients may fail to install packages without a zip archive artifact.


##### icon

The `icon` artifact type is used for an icon representing the package.

Icons SHOULD be a square image, with dimensions 128x128 or 256x256. The `height` and `width` properties SHOULD be specified as numbers for raster images, indicating the dimensions of the image.

Icons SHOULD specify the `content-type` property, with an image MIME type matching `image/png`, `image/jpeg`, `image/svg`, or `image/gif` types. Clients MAY ignore unknown types or non-image types.

Icons MAY specify a `lang` property, which is a string containing an [RFC4646][]-compliant ("IETF") language specifier. Clients MAY conditionally show icons based on the user's language.

Icons SHOULD NOT require authentication.

[rfc4646]: https://datatracker.ietf.org/doc/html/rfc4646


##### banner

The `banner` artifact type is used for header banners to display on plugin listing pages.

Banners SHOULD specify the `height` and `width` properties as numbers for raster images, indicating the dimensions of the image. Banners SHOULD NOT exceed 4MB.

The sizes 772x250 and 1544x500 are commonly used by clients. Clients MAY ignore banners which do not match a usable size.

Banners SHOULD specify the `content-type` property, with an image MIME type matching `image/png`, `image/jpeg`, `image/svg`, or `image/gif` types. Clients MAY ignore unknown types or non-image types.

Banners MAY specify a `lang` property, which is a string containing an [RFC4646][]-compliant ("IETF") language specifier. Clients MAY conditionally show icons based on the user's language.

Banners SHOULD NOT require authentication.


##### screenshot

The `screenshot` artifact type is used for screenshots of the plugin's UI.

Screenshots SHOULD specify the `height` and `width` properties as numbers for raster images, indicating the dimensions of the image. Linked artifacts SHOULD NOT exceed 10MB.

Screenshots SHOULD specify the `content-type` property, with an image MIME type matching `image/png`, `image/jpeg`, `image/svg`, or `image/gif` types. Clients MAY ignore unknown types or non-image types.

Screenshots MAY specify a `lang` property, which is a string containing an [RFC4646][]-compliant ("IETF") language specifier. Clients MAY conditionally show icons based on the user's language.

Screenshots SHOULD NOT require authentication.



#### requires

The `requires` property SHOULD only contain valid package IDs for other `wp-plugin`-type packages, or PHP environment requirements as specified in [Common](#common).

Clients MAY treat the package as invalid if other package types are required.


## Theme Package Type

*to be specified*
