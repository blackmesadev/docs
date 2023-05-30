# Strike

Issue a strike to [`target`](../../../reference/object-types.md#user)s (for [`time`](../../../reference/object-types.md#duration) if specified) for `reason`.

## Syntax

`strike <target:user[]> [time:duration] [reason:string...]`

If [`time`](../../../reference/object-types.md#duration) is not specified, the strike will default to the [`duration`](../../../reference/object-types.md#duration) at config value `moderation.defaultStrikeDuration`.

## Required Permission

`moderation.strike`

## Example

- `!strike 96269247411400704 Did something stupid`
- `!strike 96269247411400704 206309860038410240 5d Did something stupid`
