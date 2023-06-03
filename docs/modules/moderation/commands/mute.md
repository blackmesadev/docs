# Mute

Mute [`target`](../../../reference/object-types.md#user) for [`time`](../../../reference/object-types.md#duration) if specified for `reason`.

## Syntax

`mute <target:user[]> [time:duration] [reason:string...]`

If [`time`](../../../reference/object-types.md#duration)is not specified, the mute will be permanent.

## Required Permission

`moderation.mute`

## Example

- `!mute 96269247411400704 Did something stupid`
- `!mute 96269247411400704 206309860038410240 5d Did something stupid`
