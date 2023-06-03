# Deep Search

Deep Search the infractions from a [`target`](../../../reference/object-types.md#user). This shows all infractions, including those that have expired.

## Syntax

`deepsearch [target:user]`

If [`target`](../../../reference/object-types.md#user) is not specified, the command author is used.

## Required Permission

`admin.deepsearch` & `moderation.search`

OR

`guild.searchself` if [`target`](../../../reference/object-types.md#user) is the command author, the user has implied access to their expired infractions.

## Example

- `!deepsearch 96269247411400704`
