# Search

Search the infractions from a [`target`](../../../reference/object-types.md#user).

## Syntax

`search [target:user]`

If [`target`](../../../reference/object-types.md#user) is not specified, the command author is used.

## Required Permission

`moderation.search`

OR

`guild.searchself` if `target` is the command author.

## Example

- `!search 96269247411400704`
