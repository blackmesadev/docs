# User Info

Get the user information of a given [`target`](../../../reference/object-types.md#user).

## Syntax

`userinfo [target:user]`

If [`target`](../../../reference/object-types.md#user) is not specified, the command author is used.

## Required Permission

`guild.userinfo`

OR

`guild.userinfoself` if `target` is the command author.

## Example

- `!userinfo 96269247411400704`
