# Command Quick Reference

## [Moderation]()

All commands in this module require the `moderation` permission node.
Subsequent commands will require the `moderation.<command>` permission node.

### [:octicons-command-palette-16: `ban <target:user[]> [time:duration] [reason:string...]`](../modules/moderation/commands/ban.md)
Ban [`target`](./object-types.md#user) for [`time`](./object-types.md#duration) if specified from the server for `reason`.

If [`time`](./object-types.md#duration) is not specified, the ban will be permanent.

#### Example

- `!ban 96269247411400704 Did something stupid`
- `!ban 96269247411400704 206309860038410240 5d Did something stupid`

---
### [:octicons-command-palette-16: `kick <target:user[]> [reason:string...]`](../modules/moderation/commands/kick.md)
Kick [`target`](./object-types.md#user) from the server for `reason`.

#### Example

- `!kick 96269247411400704 Did something stupid`

---
### [:octicons-command-palette-16: `mute <target:user[]> [time:duration] [reason:string...]`](../modules/moderation/commands/mute.md)
Mute [`target`](./object-types.md#user) for [`time`](./object-types.md#duration) if specified for `reason`.

If [`time`](./object-types.md#duration) is not specified, the mute will be permanent.

#### Example

- `!mute 96269247411400704 Did something stupid`
- `!mute 96269247411400704 206309860038410240 5d Did something stupid`

---
### [:octicons-command-palette-16: `search [target:user]`](../modules/moderation/commands/search.md)
Search the infractions from a [`target`](./object-types.md#user).

If [`target`](./object-types.md#user) is not specified, the command author is used (see [`guild.searchself`](../configuration/permissions.md#guild)).

#### Example

- `!search 96269247411400704`

---
### [:octicons-command-palette-16: `softban <target:user[]> [reason:string...]`](../modules/moderation/commands/softban.md)
Softban (ban then unban) [`target`](./object-types.md#user) from the server for `reason`.

If [`delete`](./object-types.md#duration) is not specified, it will default to 1 day.

#### Example

- `!softban 96269247411400704 3d Did something stupid`

---
### [:octicons-command-palette-16: `unban <target:user[]> [reason:string...]`](../modules/moderation/commands/unban.md)
Unban [`target`](./object-types.md#user) from the server for `reason`.

#### Example

- `!unban 96269247411400704 206309860038410240 All is forgiven`

---
### [:octicons-command-palette-16: `unmute <target:user[]> [reason:string...]`](../modules/moderation/commands/unmute.md)
Unmute [`target`](./object-types.md#user) from the server for `reason`.

#### Example

- `!unmute 96269247411400704 206309860038410240 All is forgiven`

---


## [Administration]()

All commands in this module require the `admin` permission node.
Subsequent commands will require the `admin.<command>` permission node.

### [:octicons-command-palette-16: `purge [type:string] [filter:string...] [messages:number]`](../modules/admin/commands/purge.md)
Purge `messages` messages from the current channel that match `type` and `filter`.


#### Filter types

- `bots` - Only messages from bots
- `string` - Only messages that contain the specified string at `filter`
- `users` - Only messages from users
- `all` - All messages

#### Assumptions / Shortcuts

- If `type` is not specified, `all` is assumed.

- If `type` is specified as an ID, the bot will assume its type based on what the ID is for. (For example, if the ID is for a user, the bot will assume `users` and the ID will be added to `filter`.)

- If `messages` looks like a user ID, the bot will assume it is a user and add it to `filter`.

- If `messages` is not specified, `100` is assumed.

#### Example

- `!purge 20` - Purge 20 messages from the current channel.
- `!purge bots 20` - Purge 20 messages from the current channel that are from bots.
- `!purge string naughty 20` - Purge 50 messages from the current channel that contain the word `naughty`.


---
### [:octicons-command-palette-16: `deepsearch [target:user]`](../modules/admin/commands/deepsearch.md)
Deep Search the infractions from a [`target`](./object-types.md#user). This shows all infractions, including those that have expired.
If [`target`](./object-types.md#user) is not specified, the command author is used.

Note: `guild.searchself` will grant if [`target`](./object-types.md#user) is the command author, the user has implied access to their expired infractions.

#### Example

- `!deepsearch 96269247411400704`


---
### [:octicons-command-palette-16: `duration [uuid:uuid] [duration:duration]`](../modules/admin/commands/duration.md)
Set the [`duration`](./object-types.md#duration) of an infraction from the point the update is made.
If [`uuid`](./object-types.md#uuid) is not specified, the duration will be applied to the most recent infraction made by the command author.

Note: `moderation.updateself` will grant if [`uuid`](./object-types.md#uuid) is not specified or the specified infraction was made by the command author.

#### Example

- `!duration 20m`
- `!duration c488c9ec-423a-437c-817c-41d0d4141e58 1d`

---
### [:octicons-command-palette-16: `expire [uuid:uuid] [duration:duration]`](../modules/admin/commands/expire.md)
Expire an infraction early.
If [`uuid`](./object-types.md#uuid) is not specified, the duration will be applied to the most recent infraction made by the command author.

Note: `moderation.updateself` will grant if [`uuid`](./object-types.md#uuid) is not specified or the specified infraction was made by the command author.

#### Example

- `!expire c488c9ec-423a-437c-817c-41d0d4141e58`

---
### [:octicons-command-palette-16: `reason [uuid:uuid] [reason:string...]`](../modules/admin/commands/reason.md)
Set the reason of an infraction.
If [`uuid`](./object-types.md#uuid) is not specified, the reason will be applied to the most recent infraction made by the command author.
Note: `moderation.updateself` will grant if [`uuid`](./object-types.md#uuid) is not specified or the specified infraction was made by the command author.

---
### [:octicons-command-palette-16: `remove <uuid:uuid>`](../modules/admin/commands/remove.md)
Remove an infraction from the database.
Unlike the update commands, [`uuid`](./object-types.md#uuid) is required in remove.
Note: `moderation.removeself` will grant if the specified infraction was made by the command author.

#### Example

- `!remove c488c9ec-423a-437c-817c-41d0d4141e58`


---


## [Guild]()

All commands in this module require the `guild` permission node.
Subsequent commands will require the `guild.<command>` permission node.

The commands in this module are typically safe to expose to your users.

### [:octicons-command-palette-16: `guildinfo`](../modules/guild/commands/guildinfo.md)
Get information about the current server.

#### Example

- `!guildinfo`


---
### [:octicons-command-palette-16: `userinfo [target:user]`](../modules/guild/commands/userinfo.md)
Get the user information of a given [`target`](./object-types.md#user).
If [`target`](./object-types.md#user) is not specified, the command author is used.
Note: `guild.userinfoself` will grant if [`target`](./object-types.md#target) is the command author.

#### Example

- `!userinfo 96269247411400704`


---
### [:octicons-command-palette-16: `botinfo`](../modules/guild/commands/botinfo.md)
Get information about the bot.

#### Example

- `!botinfo`