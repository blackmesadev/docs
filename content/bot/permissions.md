+++
title = "Permissions"
weight = 3
+++

Permission nodes are defined as a bitfield in `lib/src/model/permissions.rs`.
Each named flag corresponds to a specific power of two in a `u64` value.

## Permission name format

When granting/revoking permissions via Discord commands, flags are **case-insensitive** and
**underscore-separated**, for example:

```
group grant moderators MODERATION_KICK MODERATION_BAN
group grant staff moderation
group grant dj music
```

When stored or returned by the API, `permissions` is a plain **`u64` integer** (the bit field).

## Flag reference

### Category composites (grant all child permissions at once)

| Flag name | Description |
| --- | --- |
| `ALL` | Every permission. |
| `MODERATION` | All moderation actions. |
| `MUSIC` | All music playback actions. |
| `CONFIG` | Config view + edit. |
| `INFRACTION` | Infraction view + edit. |
| `UTILITY` | All utility commands. |

### Moderation permissions

| Flag name | Bit | Grants |
| --- | --- | --- |
| `MODERATION_KICK` | `1 << 0` | `kick` command |
| `MODERATION_BAN` | `1 << 1` | `ban` command |
| `MODERATION_UNBAN` | `1 << 2` | `unban` command |
| `MODERATION_MUTE` | `1 << 3` | `mute` command |
| `MODERATION_UNMUTE` | `1 << 4` | `unmute` command |
| `MODERATION_WARN` | `1 << 5` | `warn` command |
| `MODERATION_PARDON` | `1 << 6` | `pardon` command |
| `MODERATION_PURGE` | `1 << 7` | `purge` command |
| `MODERATION_LOOKUP` | `1 << 8` | `lookup` command (full moderator access) |

### Music permissions

| Flag name | Bit | Grants |
| --- | --- | --- |
| `MUSIC_PLAY` | `1 << 9` | `play`, `enqueue`, `queue`, `seek`, `current` |
| `MUSIC_SKIP` | `1 << 10` | `skip` command |
| `MUSIC_STOP` | `1 << 11` | `stop` command |
| `MUSIC_PAUSE` | `1 << 12` | `pause` command |
| `MUSIC_RESUME` | `1 << 13` | `resume` command |
| `MUSIC_CLEAR` | `1 << 14` | `clearqueue` command |
| `MUSIC_VOLUME` | `1 << 15` | `volume` command |
| `MUSIC_SHUFFLE` | `1 << 16` | `shuffle` command (reserved) |

### Config permissions

| Flag name | Bit | Grants |
| --- | --- | --- |
| `CONFIG_VIEW` | `1 << 17` | Read guild config via API; `aliases` command |
| `CONFIG_EDIT` | `1 << 18` | Modify guild config; all `group`, `setconfig`, `setprefix`, `addalias`, `removealias`, `resetconfig` commands |

### Infraction permissions

| Flag name | Bit | Grants |
| --- | --- | --- |
| `INFRACTION_VIEW` | `1 << 19` | Read infractions via API (`GET /api/infractions/{guild_id}`) |
| `INFRACTION_EDIT` | `1 << 20` | Create and deactivate infractions via API |

### Utility permissions

| Flag name | Bit | Grants |
| --- | --- | --- |
| `UTILITY_INFO` | `1 << 21` | `botinfo` command |
| `UTILITY_USERINFO` | `1 << 22` | `userinfo` on others |
| `UTILITY_SERVERINFO` | `1 << 23` | Server info commands |
| `UTILITY_HELP` | `1 << 24` | `help` command |
| `UTILITY_PING` | `1 << 25` | `ping` command |
| `UTILITY_INVITE` | `1 << 26` | `invite` command |
| `UTILITY_SELFLOOKUP` | `1 << 27` | `lookup` of self only |

## How permission checks work

For every command invocation the following sources are evaluated in order, and access is granted if
**any** source satisfies the required flag:

1. **Guild owner** - always bypasses all permission checks.
2. **Discord role permissions** (only when `inherit_discord_perms = true`) - Discord permissions
   such as `KICK_MEMBERS` or `BAN_MEMBERS` are mapped to equivalent Black Mesa flags automatically.
   `ADMINISTRATOR` maps to `ALL`.
3. **Permission groups** - the caller's user ID is compared against the `users` set of every
   `PermissionGroup`. If a matching group holds the required flag bit the check passes.

> Role-based group membership (`group.roles`) is checked when the API calls
> `check_permission` with access to guild member data. In Discord commands, only the `users`
> set is checked directly; Discord role inheritance covers the role path.

## Discord permission mapping

When `inherit_discord_perms = true` (the default), the following Discord role permissions
imply Black Mesa permission flags:

| Discord permission | Black Mesa flags granted |
| --- | --- |
| `ADMINISTRATOR` | `ALL` |
| `KICK_MEMBERS` | `MODERATION_KICK` |
| `BAN_MEMBERS` | `MODERATION_BAN`, `MODERATION_UNBAN` |
| `MUTE_MEMBERS` | `MODERATION_MUTE`, `MODERATION_UNMUTE` |
| `MANAGE_MESSAGES` | `MODERATION_WARN`, `MODERATION_PARDON`, `MODERATION_PURGE`, `MODERATION_LOOKUP` |
| `MANAGE_GUILD` | `CONFIG_VIEW`, `CONFIG_EDIT` |
| `VIEW_AUDIT_LOG` | `INFRACTION_VIEW` |

**Example:** A Discord role with `KICK_MEMBERS` and `MANAGE_MESSAGES` will automatically gain
`MODERATION_KICK`, `MODERATION_WARN`, `MODERATION_PARDON`, `MODERATION_PURGE`, and
`MODERATION_LOOKUP` - no `group grant` needed. Use `inherit_discord_perms = false` to opt out
and manage all access through groups exclusively.

## Group-based access model

Groups are the primary way to grant granular permissions beyond what Discord role mapping provides.

**Recommended setup pattern:**

1. Create a group for each staff tier (`mods`, `admins`, `music-dj`).
2. Bind the corresponding Discord roles using `group add @RoleName` or by listing role IDs.
3. Grant the appropriate composite flag: `group grant mods MODERATION` (all mod actions) or
   individual leaf flags: `group grant mods MODERATION_KICK MODERATION_BAN`.
4. Reserve `CONFIG_EDIT` for trusted admins only.
5. Add individual users to groups only for special-case overrides.

**Composite flag example** - grant all music permissions at once:
```
group create dj
group add dj @DJ-Role
group grant dj MUSIC
```

**Full tiered staff example:**

```
# Tier 1 - junior moderators: kick, warn, lookup only
group create junior-mods
group add junior-mods @Junior-Mod
group grant junior-mods MODERATION_KICK MODERATION_WARN MODERATION_LOOKUP

# Tier 2 - moderators: all moderation actions
group create moderators
group add moderators @Moderator
group grant moderators MODERATION

# Tier 3 - admins: moderation + full config access
group create admins
group add admins @Admin
group grant admins MODERATION CONFIG

# Music team: music permissions only
group create dj
group add dj @DJ-Role
group grant dj MUSIC

# Staff who need to read infractions via the API
group create staff-api
group add staff-api @Staff
group grant staff-api INFRACTION_VIEW

# Single-user override - add a specific user to a group without a role
group add admins 987654321098765432
```

**Revoking a specific flag from a composite grant:**

```
# Grant all moderation, then remove purge access
group grant moderators MODERATION
group revoke moderators MODERATION_PURGE
```
