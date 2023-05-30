# Permissions

Black Mesa has its own permissions system based on nodes. Each command has a permission node
(e.g. `moderation.ban`) which is granted to a specific level. If the user (or the group the user is
in) is below this level, they do not have the permission and as such has no access to the feature
the permission locks.

# Permission Nodes
Permission nodes are fairly simple, each node is a string separated by a `.`. Each subnode holds
a higher priority than the previous node. For example, `moderation.ban` has a higher priority than
`moderation`. As an example, if you were to set `moderation` to 50 and `moderation.ban` to 100, a
user with permission level 50 would have access to all moderation commands, apart from ban.

## Permission Groups

Permission groups are a way to group permissions together to make it easier to manage permissions.
Groups have the lowest permission priority.

The following permission groups are available:

| Group | Default Level |
| ----- | ------------- |
| [`moderation`](#moderation) | 50 |
| [`admin`](#admin) | 100 |
| [`guild`](#guild) | 0 |
| [`roles`](#roles) | 100 |
| [`music`](#music) | 10 |


**Please note when you see a `*` in a default level, this means that the default level is not set and therefore inherits the level of the parent group.**

## Permission nodes by group

### `moderation`


| Node | Description | Default Level |
| ---- | ----------- | ------------- |
| `moderation.ban` | Allows the user to ban users. | * |
| `moderation.kick` | Allows the user to kick users. | * |
| `moderation.mute` | Allows the user to mute users. | * |
| `moderation.removeself` | Allows the user to remove an infraction that they have made. | * |
| `moderation.expireself` | Allows the user to expire an infraction that they have made. | * |
| `moderation.search` | Allows the user to search infraction logs of other users. | * |
| `moderation.softban` | Allows the user to softban users. | * |
| `moderation.strike` | Allows the user to strike users. | * |
| `moderation.unban` | Allows the user to unban users. | * |
| `moderation.unmute` | Allows the user to unmute users. | * |
| `moderation.updateself` | Allows the user to update an infraction that they have made. | * |

### `admin`
| Node | Description | Default Level |
| ---- | ----------- | ------------- |
| `admin.makemute` | Allow the user to make a muted role. | 101 |
| `admin.setup` | Allow the user to reset Black Mesa and run setup again. | 101 |
| `admin.remove` | Allow the user to remove infractions from anyone. | * |
| `admin.expire` | Allow the user to expire infractions from anyone. | * |
| `admin.update` | Allow the user to update infractions from anyone. | * |
| `admin.purge` | Allow the user to purge messages from a channel. | * |

### `guild`
| Node | Description | Default Level |
| ---- | ----------- | ------------- |
| `guild.viewcommandlevel` | Allow the user to view the permission level of a command by node. | 100 |
| `guild.viewuserlevel` | Allow the user to view the permission level of a user. | 100 |
| `guild.userinfo` | Allow the user to view the general user information of a user. | * |
| `guild.guildinfo` | Allow the user to view the general guild information. | * |
| `guild.searchself` | Allow the user to view their own infractions. | * |

### `roles`
| Node | Description | Default Level |
| ---- | ----------- | ------------- |
| `roles.add` | Allow the user to add roles to users. | * |
| `roles.remove` | Allow the user to remove roles from users. | * |
| `roles.create` | Allow the user to create roles. | * |
| `roles.rmrole` | Allow the user to delete roles. | * |
| `roles.update` | Allow the user to update roles. | * |
| `roles.list` | Allow the user to list roles. | * |

### `music`
| Node | Description | Default Level |
| ---- | ----------- | ------------- |
| `music.play` | Allow the user to play music. | 0 |
| `music.stop` | Allow the user to stop music. | * |
| `music.skip` | Allow the user to skip music. | * |
| `music.remove` | Allow the user to remove music from the queue. | * |
| `music.dc` | Allow the user to disconnect the bot from the channel. | 50 |
| `music.seek` | Allow the user to seek the currently playing song. | * |
| `music.volume` | Allow the user to adjust the volume of the currently playing song. | 50 |