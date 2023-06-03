# Ban

Ban [`target`](../../../reference/object-types.md#user) for [`time`](../../../reference/object-types.md#duration) if specified from the server for `reason`.

## Syntax

`ban <target:user[]> [time:duration] [reason:string...]`

If [`time`](../../../reference/object-types.md#duration) is not specified, the ban will be permanent.

## Required Permission

`moderation.ban`

## Example

- `ban 96269247411400704 Did something stupid`
- `ban 96269247411400704 206309860038410240 5d Did something stupid`
