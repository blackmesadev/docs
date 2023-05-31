# Groups

Groups are a way to group permissions together. They are used to make it easier to manage permissions for users.
You can assign a group to a user or role and then assign permissions to that group.

Groups have the lowest permission priority, any permissions set on a user or role will override the group permissions.

## Default Groups

The following groups are available by default:

| Group | Default Permissions | Inherits From |
| ----- | ------------------- | ------------- |
| `default` | [`guild`](#guild) | `-` |
| `dj` | [`music`](#music) | `default` |
| `moderator` | [`moderation`](#moderation) | `dj` |
| `admin` | [`admin`](#admin) | `moderator` |

**NOTE:** You can not remove the default group, but you can change the permissions. Black Mesa will always use the default group if no other group is set.