# Softban

Softban (ban then unban) [`target`](../../../reference/object-types.md#user) from the server for `reason`.

## Syntax

`softban <target:user[]> [delete:duration] [reason:string...]`

If [`delete`](../../../reference/object-types.md#duration) is not specified, it will default to 1 day. You may specify a MAXIMUM of 7 days.

## Required Permission

`moderation.softban`

## Example

- `!softban 96269247411400704 3d Did something stupid`