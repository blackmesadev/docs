+++
title = "Logging"
weight = 5
+++

The logging system sends customizable messages to designated channels when events occur in your server. Each event can be individually configured with its own destination channel, display mode (embed or plain text), and template content using placeholder variables.

## Enabling logging

Set `logging_enabled` to `true` in your guild config:

```
PATCH /api/config/{guild_id}
{ "logging_enabled": true }
```

You also need at least one **log config** entry to tell the bot which events to log and where.

> **Fallback**: If `logging_enabled` is `false` or no log config exists for an event, legacy behaviour applies - moderation actions and automod triggers still post to `log_channel` (if set) using the built-in format.

## Log configs

A log config is a per-event, per-guild record stored in the `log_configs` table.

| Field | Type | Description |
| --- | --- | --- |
| `event` | `string` | Event key (see tables below). |
| `enabled` | `bool` | Whether this config is active. |
| `channel_id` | `snowflake?` | Override channel. Falls back to `log_channel` in the guild config when `null`. |
| `embed` | `bool` | `true` = rich embed, `false` = plain text. |
| `text_content` | `string?` | Template for plain-text mode. |
| `embed_title` | `string?` | Template for the embed title. |
| `embed_body` | `string?` | Template for the embed description. |
| `embed_color` | `integer?` | Embed sidebar colour as a decimal RGB value (e.g. `16711680` for red). |
| `embed_footer` | `string?` | Template for the embed footer. |

### Template syntax

Templates use double-brace placeholders:

```
User {{username}} ({{user_id}}) was banned by <@{{moderator_id}}>
Reason: {{reason}}
```

Any placeholder that does not have a value at render time is left as-is (the literal `{{key}}` text remains).

## Event types

Events are divided into two sources: **Discord** gateway events and **Mesa** internal events.

### Discord events

| Key | Label | Placeholders |
| --- | --- | --- |
| `message_delete` | MessageDelete | `channel_id`, `message_id`, `guild_id` |
| `message_update` | MessageUpdate | `channel_id`, `message_id`, `user_id`, `content`, `guild_id` |
| `message_create` | MessageCreate | `channel_id`, `message_id`, `user_id`, `content`, `guild_id` |
| `guild_member_add` | GuildMemberAdd | `user_id`, `username`, `guild_id` |
| `guild_member_remove` | GuildMemberRemove | `user_id`, `username`, `guild_id` |
| `guild_member_update` | GuildMemberUpdate | `user_id`, `username`, `guild_id`, `roles` |
| `guild_update` | GuildUpdate | `guild_id`, `guild_name` |
| `voice_state_update` | VoiceStateUpdate | `user_id`, `channel_id`, `guild_id` |
| `channel_create` | ChannelCreate | `channel_id`, `channel_name`, `guild_id` |
| `channel_update` | ChannelUpdate | `channel_id`, `channel_name`, `guild_id` |
| `channel_delete` | ChannelDelete | `channel_id`, `channel_name`, `guild_id` |
| `role_create` | RoleCreate | `role_id`, `role_name`, `guild_id` |
| `role_update` | RoleUpdate | `role_id`, `role_name`, `guild_id` |
| `role_delete` | RoleDelete | `role_id`, `role_name`, `guild_id` |
| `guild_ban_add` | GuildBanAdd | `user_id`, `username`, `guild_id` |
| `guild_ban_remove` | GuildBanRemove | `user_id`, `username`, `guild_id` |
| `invite_create` | InviteCreate | `channel_id`, `inviter_id`, `code`, `guild_id` |
| `invite_delete` | InviteDelete | `channel_id`, `code`, `guild_id` |

### Mesa events

| Key | Label | Placeholders |
| --- | --- | --- |
| `mesa_automod_censor` | AutomodCensor | `user_id`, `username`, `channel_id`, `guild_id`, `reason`, `filter_type`, `offending_content` |
| `mesa_automod_spam` | AutomodSpam | `user_id`, `username`, `channel_id`, `guild_id`, `reason`, `spam_type`, `count`, `interval` |
| `mesa_moderation_warn` | ModerationWarn | `user_id`, `username`, `moderator_id`, `guild_id`, `reason`, `duration`, `infraction_id` |
| `mesa_moderation_mute` | ModerationMute | `user_id`, `username`, `moderator_id`, `guild_id`, `reason`, `duration`, `infraction_id` |
| `mesa_moderation_kick` | ModerationKick | `user_id`, `username`, `moderator_id`, `guild_id`, `reason`, `infraction_id` |
| `mesa_moderation_ban` | ModerationBan | `user_id`, `username`, `moderator_id`, `guild_id`, `reason`, `duration`, `infraction_id` |
| `mesa_moderation_unmute` | ModerationUnmute | `user_id`, `username`, `moderator_id`, `guild_id`, `reason` |
| `mesa_moderation_unban` | ModerationUnban | `user_id`, `username`, `moderator_id`, `guild_id`, `reason` |
| `mesa_moderation_pardon` | ModerationPardon | `user_id`, `username`, `moderator_id`, `guild_id`, `reason`, `infraction_id` |

## API endpoints

All endpoints require a valid JWT and appropriate guild permissions.

### List available events

```
GET /api/logging/events
```

Returns all supported event types with their labels, source, and available placeholders. No authentication required.

### Get log configs for a guild

```
GET /api/logging/{guild_id}
```

Returns all `LogConfig` entries for the guild. Requires `CONFIG_VIEW` permission.

### Upsert a single log config

```
POST /api/logging/{guild_id}
Content-Type: application/json

{
  "event": "guild_ban_add",
  "enabled": true,
  "channel_id": "123456789012345678",
  "embed": true,
  "embed_title": "User Banned",
  "embed_body": "{{username}} ({{user_id}}) was banned.",
  "embed_color": 16711680,
  "embed_footer": null,
  "text_content": null
}
```

Creates or updates the config for the given event in that guild. Requires `CONFIG_EDIT` permission.

### Bulk upsert log configs

```
POST /api/logging/{guild_id}/bulk
Content-Type: application/json

[
  { "event": "guild_ban_add", "enabled": true, "embed": true, ... },
  { "event": "guild_ban_remove", "enabled": true, "embed": false, "text_content": "Unbanned {{username}}" }
]
```

Upserts multiple log configs at once. Requires `CONFIG_EDIT` permission.

### Delete a log config

```
DELETE /api/logging/{guild_id}/{event}
```

Removes the log config for the specified event. Requires `CONFIG_EDIT` permission.

## Dashboard

The **Logging** tab in the dashboard provides a visual editor for all log configs in a guild. Events are grouped by source (Discord / Mesa) in an accordion layout. Each event card lets you:

- Toggle the event on or off
- Override the destination channel (or leave blank to use the guild `log_channel`)
- Switch between embed mode and plain-text mode
- Set embed colour, title, body, and footer templates
- Insert placeholder variables with one click

Click **Save All** to bulk-upsert all modified configs.

## Channel resolution

When an event fires, the bot resolves the destination channel in this order:

1. `log_config.channel_id` for that specific event (if set and non-null)
2. `config.log_channel` (the guild-wide default log channel)
3. If neither is set, the event is silently dropped.
