+++
title = "Commands"
weight = 1
+++

This reference reflects the command router in `black-mesa/src/commands/router.rs`.

> **Module flags**: moderation commands require `moderation_enabled = true` and music commands
> require `music_enabled = true` in the guild config. Both default to `false`. Enable them via
> the dashboard or `POST /api/config/{id}`.

## Utility

These commands are always available regardless of module flags.

| Command | Syntax | Permission |
| --- | --- | --- |
| `ping` | `ping` | `UTILITY_PING` |
| `botinfo` | `botinfo` | `UTILITY_INFO` |
| `userinfo` | `userinfo [target:user\|id]` | `UTILITY_USERINFO` (own info: `UTILITY_SELFLOOKUP`) |
| `help` | `help` | `UTILITY_HELP` |

**Examples:**

```
ping
botinfo
userinfo @Tyler
userinfo 123456789012345678
help
```

## Configuration

| Command | Syntax | Permission |
| --- | --- | --- |
| `resetconfig` | `resetconfig` | `CONFIG_EDIT` |
| `setprefix` | `setprefix <prefix:text>` | `CONFIG_EDIT` |
| `setconfig` | `setconfig <key:text> <value:text>` | `CONFIG_EDIT` |
| `addalias` | `addalias <alias:command> <command:command>` | `CONFIG_EDIT` |
| `removealias` | `removealias <alias:command>` | `CONFIG_EDIT` |
| `aliases` | `aliases` | `CONFIG_VIEW` |
| `group` | `group <subcommand> ...` | `CONFIG_EDIT` |

**Examples:**

```
setprefix .
setprefix !!
setconfig log_channel 998877665544332211
setconfig mute_role 111111111111111111
setconfig default_warn_duration 30d
setconfig prefer_embeds true
setconfig alert_on_infraction false
addalias w warn
addalias b ban
removealias w
aliases
```

### `setconfig` keys

| Key | Accepted value |
| --- | --- |
| `prefix` | Any text string |
| `mute_role` | Discord snowflake ID |
| `default_warn_duration` | Duration string (e.g. `7d`, `30d`, `48h`) |
| `log_channel` | Discord channel snowflake ID |
| `prefer_embeds` | `true` / `false` |
| `inherit_discord_perms` | `true` / `false` |
| `alert_on_infraction` | `true` / `false` |
| `send_permission_denied` | `true` / `false` |

> Module flags (`moderation_enabled`, `music_enabled`, `automod_enabled`) cannot be set with
> `setconfig`. Use the dashboard or the API instead.

### `group` subcommands

| Command | Syntax | Notes |
| --- | --- | --- |
| `group create` | `group create <group:text>` | Creates a new empty group. |
| `group delete` | `group delete <group:text>` | Removes the group and all its members. |
| `group list` | `group list [group:text]` | Lists all groups, or details for a specific group. |
| `group add` | `group add <group:text> <target:user\|id[]>` | Adds users to the group. |
| `group remove` | `group remove <group:text> <target:user\|id[]>` | Removes users from the group. |
| `group users` | `group users <group:text>` | Lists users in the group. |
| `group roles` | `group roles <group:text>` | Lists roles bound to the group. |
| `group grant` | `group grant <group:text> <permission:flag...>` | Grants one or more permission flags. See [Permissions](@/bot/permissions.md). |
| `group revoke` | `group revoke <group:text> <permission:flag...>` | Revokes one or more permission flags. |

Permission flags are **case-insensitive** and **underscore-separated** (e.g. `MODERATION_KICK` or
`moderation_kick`). Composite flags like `MODERATION` grant all child permissions at once.

**Examples:**

```
# Create a tiered staff structure
group create moderators
group create admins
group create dj

# Bind Discord roles
group add moderators @Moderator
group add admins @Admin 123456789012345678
group add dj @DJ-Role

# Grant composite flags
group grant moderators MODERATION
group grant admins MODERATION CONFIG_VIEW CONFIG_EDIT
group grant dj MUSIC

# Grant/revoke individual flags
group grant moderators MODERATION_KICK MODERATION_BAN
group revoke moderators MODERATION_PURGE

# Inspect a group
group list
group list moderators
group users moderators
group roles moderators

# Add a single user override (not a role)
group add admins 987654321098765432

group delete temp-role
```

Requires `moderation_enabled = true`.

| Command | Syntax | Permission |
| --- | --- | --- |
| `kick` | `kick <target:user\|id[]> [reason:text...]` | `MODERATION_KICK` |
| `ban` | `ban <target:user\|id[]> [time:duration] [reason:text...]` | `MODERATION_BAN` |
| `unban` | `unban <target:user\|id[]> [reason:text...]` | `MODERATION_UNBAN` |
| `mute` | `mute <target:user\|id[]> [time:duration] [reason:text...]` | `MODERATION_MUTE` |
| `unmute` | `unmute <target:user\|id[]> [reason:text...]` | `MODERATION_UNMUTE` |
| `warn` | `warn <target:user\|id[]> [time:duration] [reason:text...]` | `MODERATION_WARN` |
| `pardon` | `pardon <target:uuid[]>` | `MODERATION_PARDON` |
| `lookup` | `lookup [target:user\|id]` | `MODERATION_LOOKUP` or `UTILITY_SELFLOOKUP` (own records) |

**Notes:**

- `mute` requires `mute_role` to be set in the guild config before it will function.
- `ban` and `mute` accept an optional duration (e.g. `7d`, `24h`). Omitting duration creates a
  permanent action. `warn` falls back to `default_warn_duration` when no duration is given.
- Multi-target: all commands accept multiple space-separated user IDs or mentions in one call.
- `pardon` takes one or more infraction UUIDs (as returned by `lookup` or the API).
- `lookup` without an argument looks up the caller's own records (requires `UTILITY_SELFLOOKUP`).

**Examples:**

```
# Single target with reason
kick @BadUser Spamming in #general

# Multi-target kick (all processed concurrently)
kick @User1 @User2 123456789012345678 Raid

# Timed ban
ban @User 7d Repeated rule violations
ban @User 24h Cooldown

# Permanent ban
ban @User No reason required for permanent ban

# Mute with duration
mute @User 1h Heated argument
mute @User 30m

# Warn - uses default_warn_duration if no time given
warn @User First offense
warn @User 30d Continued behaviour after warning

# Multi-target warn
warn @User1 @User2 Off-topic spam

# Unban and unmute (multi-target, sends confirmation)
unban 123456789012345678
unban @User1 @User2
unmute @User

# Pardon an infraction by UUID
pardon a1b2c3d4-e5f6-7890-abcd-ef1234567890

# Lookup a user's infraction history
lookup @User
lookup 123456789012345678

# Lookup your own records
lookup
```

Requires `music_enabled = true` and a connected Mesastream instance.

The bot automatically joins the caller's current voice channel when it needs to create a player.
If already in a voice channel, `[player_id:channel_id]` can be omitted and the active player is
resolved from guild voice state.

### Playback controls

| Command | Syntax | Permission |
| --- | --- | --- |
| `play` | `play [url:text] [player_id:channel_id]` | `MUSIC_PLAY` |
| `pause` | `pause [player_id:channel_id]` | `MUSIC_PAUSE` |
| `resume` | `resume [player_id:channel_id]` | `MUSIC_RESUME` |
| `skip` | `skip [player_id:channel_id]` | `MUSIC_SKIP` |
| `stop` | `stop [player_id:channel_id]` | `MUSIC_STOP` |
| `seek` | `seek <position_ms:number> [player_id:channel_id]` | `MUSIC_PLAY` |
| `volume` | `volume <volume:0.0-2.0> [player_id:channel_id]` | `MUSIC_VOLUME` |
| `current` | `current [player_id:channel_id]` | `MUSIC_PLAY` |

### Queue and playlist

| Command | Syntax | Permission |
| --- | --- | --- |
| `enqueue` | `enqueue <url:text> [player_id:channel_id]` | `MUSIC_PLAY` |
| `queue` | `queue [player_id:channel_id]` | `MUSIC_PLAY` |
| `clearqueue` | `clearqueue [player_id:channel_id]` | `MUSIC_CLEAR` |
| `playlistsave` | `playlistsave <name:text> [player_id:channel_id]` | `MUSIC_PLAY` |
| `playlistenqueue` | `playlistenqueue <name:text> [player_id:channel_id]` | `MUSIC_PLAY` |

**Notes:**

- `volume` accepts a float multiplier in `[0.0, 2.0]` where `1.0` is unity gain.
- `play` will auto-join the caller's voice channel and create a Mesastream player if needed. If the
  bot was disconnected from voice since the last `play`, it re-joins and refreshes the connection.
- Stale Discord voice sessions (expired token or session rotation) are automatically retried once.
- Queue and playlist state persist across player restarts via Redis (guild-scoped).

**Examples:**

```
# Play from URL (auto-joins voice)
play https://www.youtube.com/watch?v=dQw4w9WgXcQ

# Add to queue
enqueue https://soundcloud.com/artist/track
enqueue https://www.youtube.com/watch?v=dQw4w9WgXcQ

# View queue
queue

# Playback controls
pause
resume
stop
skip

# Seek to 1m30s (in milliseconds)
seek 90000

# Set volume to 80%
volume 0.8

# What's currently playing
current

# Clear the queue
clearqueue

# Save queue as a named playlist and re-enqueue it later
playlistsave friday-jams
playlistenqueue friday-jams

# Target a specific player by voice channel ID
stop 987654321098765432
queue 987654321098765432
```

## Privileged owner-only commands

These are only executed when the caller's user ID matches the hardcoded owner (`GOAT_ID`):

| Command | Notes |
| --- | --- |
| `clearcache` | Clears internal caches. |
| `permissions` | Inspects effective permissions for a user or role. |
| `shutdown` | Initiates a controlled shutdown. |
