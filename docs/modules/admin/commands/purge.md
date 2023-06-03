# Purge

Purge `messages` messages from the current channel that match `type` and `filter`.

## Syntax

`purge [type:string] [filter:string...] [messages:number]`

## Permission

`admin.purge`

## Filter types

- `bots` - Only messages from bots
- `string` - Only messages that contain the specified string at `filter`
- `users` - Only messages from users
- `all` - All messages

## Assumptions / Shortcuts

- If `type` is not specified, `all` is assumed.

- If `type` is specified as an ID, the bot will assume its type based on what the ID is for. (For example, if the ID is for a user, the bot will assume `users` and the ID will be added to `filter`.)

- If `messages` looks like a user ID, the bot will assume it is a user and add it to `filter`.

- If `messages` is not specified, `100` is assumed.

## Example

- `!purge 20` - Purge 20 messages from the current channel.
- `!purge bots 20` - Purge 20 messages from the current channel that are from bots.
- `!purge string naughty 20` - Purge 50 messages from the current channel that contain the word `naughty`.
