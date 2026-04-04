+++
title = "Configuration"
weight = 2
+++

Guild configuration is stored as `Config` (defined in `lib/src/model/config.rs` and backed by the
`configs` and `permissions` PostgreSQL tables).

## Config shape

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `id` | `snowflake` | _required_ | Guild ID. |
| `prefix` | `string` | `!` | Command prefix character(s). |
| `mute_role` | `snowflake?` | `null` | Role applied by the `mute` command. Must be set before `mute` will work. |
| `default_warn_duration` | `integer?` | `null` | Default warn expiry in **seconds**. Used by `warn` when no duration argument is given. |
| `log_channel` | `snowflake?` | `null` | Channel where moderation action log messages are posted. |
| `prefer_embeds` | `bool` | `false` | Use embed-style responses instead of plain text where supported. |
| `inherit_discord_perms` | `bool` | `true` | Map Discord role permissions (KICK_MEMBERS, BAN_MEMBERS, etc.) into Black Mesa permission nodes automatically. |
| `alert_on_infraction` | `bool` | `true` | Send a DM to the target user when an infraction is issued. |
| `send_permission_denied` | `bool` | `true` | Reply with a permission-denied message when a user lacks access to a command. |
| `moderation_enabled` | `bool` | `false` | Enable moderation commands (`kick`, `ban`, `mute`, `warn`, etc.). |
| `music_enabled` | `bool` | `false` | Enable music/audio playback commands. Requires a running Mesastream instance. |
| `automod_enabled` | `bool` | `false` | Enable the automod engine (censor and spam filters). |
| `logging_enabled` | `bool` | `false` | Enable the per-event logging system. See [Logging](@/bot/logging.md). |
| `permission_groups` | `Group[]?` | `null` | Named permission groups with bound users, roles, and permission bits. |
| `automod` | `Automod?` | `null` | Automod settings. Only evaluated when `automod_enabled` is `true`. |
| `command_aliases` | `map<string,string>?` | `null` | Alias → command mapping (e.g. `{"w": "warn"}`). |

## Group shape

Permission groups bind Discord users and/or roles to a set of permission bits.

| Key | Type | Description |
| --- | --- | --- |
| `name` | `string` | Unique group name within the guild. |
| `roles` | `snowflake[]` | Discord role IDs that inherit this group's permissions. |
| `users` | `snowflake[]` | User IDs explicitly added to this group. |
| `permissions` | `integer` | Permission bit field (u64). See [Permissions](@/bot/permissions.md) for bit values and flag names. |

> **Permission format in the API**: `permissions` is serialized as a plain 64-bit integer in JSON.
> Use `group grant` / `group revoke` in Discord to modify permissions interactively using flag names.

## Automod settings

Automod operates at two levels: a `global` setting applied to all channels, and per-channel overrides.

### Automod shape

| Key | Type | Description |
| --- | --- | --- |
| `global` | `AutomodSettings?` | Applies to all channels not listed in `channels`. |
| `channels` | `map<snowflake, AutomodSettings>` | Per-channel overrides keyed by channel ID. |

### AutomodSettings shape

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `string` | - | Human label for this settings block. |
| `enabled` | `bool` | `false` | Whether this settings block is active. |
| `censors` | `map<CensorType, Censor>?` | `null` | Censor filters. Keys: `word`, `link`, `invite`. |
| `spam` | `SpamFilter?` | `null` | Spam detection settings. |
| `bypass` | `PermissionOverride?` | `null` | Groups/roles/users exempt from all automod in this scope. |

### Censor shape

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `enabled` | `bool` | - | Whether this censor is active. |
| `whitelist` | `bool` | `false` | If `true`, only messages that do **not** match the filters are blocked (whitelist mode). |
| `filters` | `string[]` | - | List of patterns to match. `word` supports `*` (wildcard) and `...` (requires content between start/end). `link` uses exact domain names. `invite` uses exact Discord invite codes. |
| `ignore_whitespace` | `bool` | `false` | Strip whitespace from message content before matching. |
| `bypass` | `PermissionOverride?` | `null` | Groups/roles/users exempt from this specific censor. |
| `action` | `CensorAction` | - | Action to take on match. |

### CensorAction shape

| Key | Type | Description |
| --- | --- | --- |
| `action` | `InfractionType` | `warn`, `mute`, `kick`, or `ban`. |
| `duration` | `integer` | Duration in **milliseconds** for timed infractions. |

### SpamFilter shape

| Key | Type | Description |
| --- | --- | --- |
| `enabled` | `bool` | Whether spam detection is active. |
| `filters` | `map<SpamType, SpamInterval>` | Spam type → detection window. Keys: `message`, `newline`. |
| `bypass` | `PermissionOverride?` | Groups/roles/users exempt from spam detection. |
| `action` | `SpamAction[]` | Escalating actions triggered at different violation thresholds. |

### SpamInterval shape

| Key | Type | Description |
| --- | --- | --- |
| `interval` | `integer` | Sliding window width in **milliseconds**. `0` matches all messages regardless of time. |
| `count` | `integer` | Number of matching events within the window required to count as a spam hit. |

### SpamAction shape

| Key | Type | Description |
| --- | --- | --- |
| `action` | `InfractionType` | Action to take. |
| `duration` | `integer` | Duration in milliseconds for timed infractions. |
| `threshold` | `integer` | Minimum cumulative violation count to trigger this action. Multiple actions can stack by threshold. |

### PermissionOverride shape

Used in `bypass` fields on both automod and individual censors/spam filters.

| Key | Type | Description |
| --- | --- | --- |
| `groups` | `string[]` | Names of permission groups that bypass this rule. |
| `roles` | `snowflake[]` | Discord role IDs that bypass this rule. |
| `users` | `snowflake[]` | User IDs that bypass this rule. |

## Full config example

```json
{
  "id": "123456789012345678",
  "prefix": "!",
  "mute_role": "987654321098765432",
  "default_warn_duration": 2592000,
  "log_channel": "998877665544332211",
  "prefer_embeds": true,
  "inherit_discord_perms": true,
  "alert_on_infraction": true,
  "send_permission_denied": true,
  "moderation_enabled": true,
  "music_enabled": false,
  "automod_enabled": true,
  "permission_groups": [
    {
      "name": "moderators",
      "roles": ["111111111111111111"],
      "users": [],
      "permissions": 33792
    }
  ],
  "command_aliases": {
    "w": "warn",
    "u": "unmute"
  },
  "automod": {
    "global": {
      "name": "global",
      "enabled": true,
      "censors": {
        "word": {
          "enabled": true,
          "whitelist": false,
          "filters": ["badword", "worse*"],
          "ignore_whitespace": false,
          "action": { "action": "warn", "duration": 86400000 }
        },
        "invite": {
          "enabled": true,
          "whitelist": false,
          "filters": ["externalinvite"],
          "ignore_whitespace": false,
          "action": { "action": "kick", "duration": 0 }
        }
      },
      "spam": {
        "enabled": true,
        "filters": {
          "message": { "interval": 5000, "count": 5 }
        },
        "action": [
          { "action": "warn", "duration": 3600000, "threshold": 1 },
          { "action": "mute", "duration": 86400000, "threshold": 3 }
        ]
      }
    },
    "channels": {}
  }
}
```

> The `permissions` value `33792` in the example equals `MODERATION (511) | CONFIG_VIEW (1 << 17) | CONFIG_EDIT (1 << 18)`.
> Use `group grant mods MODERATION CONFIG_VIEW CONFIG_EDIT` to set equivalent permissions interactively.

## Runtime editing

Most configuration can be changed from Discord directly:

| Task | Command |
| --- | --- |
| Change prefix | `setprefix <prefix>` |
| Set a config key | `setconfig <key> <value>` |
| Enable/disable modules | `setconfig moderation_enabled true` (not supported - use API) |
| Manage groups | `group create/delete/add/remove/grant/revoke ...` |
| Manage aliases | `addalias <alias> <command>` / `removealias <alias>` |

Module flags (`moderation_enabled`, `music_enabled`, `automod_enabled`) and `automod` settings
cannot be changed via `setconfig` - use `POST /api/config/{id}` or the dashboard.

**Examples:**

```
# Change the command prefix
setprefix >
setprefix !!

# Set the channel where mod actions are logged
setconfig log_channel 998877665544332211

# Assign the mute role
setconfig mute_role 111111111111111111

# Set a default warn expiry of 30 days
setconfig default_warn_duration 30d

# Enable embed-style responses
setconfig prefer_embeds true

# Stop alerting users when they are warned
setconfig alert_on_infraction false

# Map Discord role permissions into Black Mesa permission nodes
setconfig inherit_discord_perms true
```

### Duration string format

Duration arguments (used in `setconfig default_warn_duration`, `ban`, `mute`, `warn`) accept
a number followed by a unit suffix:

| Suffix | Unit |
| --- | --- |
| `s` | Seconds |
| `m` | Minutes |
| `h` | Hours |
| `d` | Days |
| `w` | Weeks |

**Examples:** `30s`, `15m`, `2h`, `7d`, `2w`, `30d`

### Valid `setconfig` keys

| Key | Accepted value format |
| --- | --- |
| `prefix` | Any text string |
| `mute_role` | Discord role snowflake ID |
| `default_warn_duration` | Duration string (e.g. `7d`, `30d`) |
| `log_channel` | Discord channel snowflake ID |
| `prefer_embeds` | `true` or `false` |
| `inherit_discord_perms` | `true` or `false` |
| `alert_on_infraction` | `true` or `false` |
| `send_permission_denied` | `true` or `false` |
