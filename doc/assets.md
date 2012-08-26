# Chromotype asset terminology

## What's an "asset"?

An asset embodies an image (or later, a movie or other types of files).

An "asset" has a caption, a description, and tags.

## What's an "asset URI"?

An asset URI[^1] is a path to an asset. An asset has one or more asset URIs.

It can be a local `file://` URI, or something non-local.

If an asset is first found non-locally, the asset will be cached
locally and will ALSO have a `file://` Asset URI.

If duplicate files are found, those `file://` URIs will point to the same asset.

If an iPhoto library is imported, for example, the "original" or "master" version,
as well as a "modified" or "preview" version of a photo will point to the same asset.

## What's a "content fingerprint"?

It's a hash of an aspect of a file, like:
* the SHA of the asset's contents or
* the SHA of a select set of EXIF header contents

# Use cases

## What happens when assets with the same byte contents are found in two different directories?

* Their SHA content fingerprint will match, and both Asset URIs will point to the same Asset.

## What happens when assets are modified in iPhoto?

* Their SHA content fingerprint will not match, but their EXIF content fingerprint will.

## What happens when a file is edited in place

If the SHA content fingerprint and the EXIF header don't match, we tombstone the Asset URI,
and if that's the last Asset URI pointing to an Asset, we mark the asset as tombstoned.

## What if the user wants to see the original and the edited version as different assets?

We set "only_exact_matches" on both assets to true.

# Asset library

Chromotype's library defaults to `~/Pictures/Chromotype` (on Mac and Linux)
or `~/My Pictures/Chromotype` (on Windows).

The Chromotype library holds

## Assets

When `Settings.move_to_library` is enabled, assets are moved into the following path:

`#{library_directory}/Assets/YYYY/MM/DD/#{original filename}`

If the same filename with the same taken-at date is found, the file will be moved to:

`#{library_directory}/Assets/YYYY/MM/DD/#{content SHA}-#{original filename}`

## Resized images

* `#{library_directory}/Resized/YYYY/MM/DD/#{sha}-#{width}.jpg` which holds variously-size thumbnails

# WAT?

## [^1]: URI? Why not URL?

Yeah, you know I googled "URI versus URL".

No, I won't store URNs.

## SHA-1 versus SHA-256 or SHA-512?

We're using SHA-1 for file content comparisons, not for integrity.

Although collisions have been found, it is extremely unlikely (1e-80) that different file contents
will have the same SHA-1 value. A number of systems (including git) use SHA-1 as a unique description
for a stream of bytes. If it's good enough for git, it's good enough for me.
