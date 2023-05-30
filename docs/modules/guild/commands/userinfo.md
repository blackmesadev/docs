# User Info

Get a [`target`](../../../reference/object-types.md#user)'s user info.

## Syntax

`userinfo [target:user]`

If [`target`](../../../reference/object-types.md#user) is not specified, the command author is used.

## Required Permission

`guild.userinfo`

OR

`guild.userinfoself` if `target` is the command author.

## Example

- `!userinfo 96269247411400704`
