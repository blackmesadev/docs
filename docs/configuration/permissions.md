# Permissions

Black Mesa has its own permissions system, similar to Bukkit. Each command has a permission node
(e.g. `moderation.ban`) which is granted to a specific level. If the user (or the group the user is
in) is below this level, they do not have the permission and as such has no access to the feature
the permission locks.
