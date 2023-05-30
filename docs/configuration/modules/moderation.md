# Moderation

Moderation is a module that allows you to moderate your server with ease.

## Configuration

| Key | Type | Description | Default Value | Optional |
| --- | --- | --- | --- | --- |
| `censor_searches` | `boolean` | Censor searches. Deep search bypasses this. | `false` | ❌ |
| `default_strike_duration` | `duration` | Default amount of time for a strike to last. | `30d` | ✅ |
| `display_no_permission` | `boolean` | Display no a permission message upon an insufficient permission error is reached. | `true` | ❌ |
| `mute_role` | [`role`](../../reference/object-types.md#role)> | The role ID of the muted role. | `""` | ❌ |
| `notify_actions` | `boolean` | Notify the user via DM when an infraction is made against them. | `true` | ❌ |
| `show_moderator_on_notify` | `boolean` | If `notify_actions` is enabled, the message sent will reveal the staff member who made the infraction. | `true` | ❌ |
| `strike_escalation` | HashMap<`amount`, [`Escalation`](#escalation)> |  | [`[3, {mute, "3h"}]`, `[5, {mute, "12h"}]`] | ❌ |
| `update_higher_level_action` | `boolean` | Allow for users to update an action of that from a higher permission level than their own. | `false` | ❌ |

### `Escalation`

| Key | Type | Description | Default Value | Optional |
| --- | --- | --- | --- | --- |
| `type` | [`punishment`](../../reference/object-types.md#punishment) | The action to take when the strike threshold is reached. | `mute` | ❌ |
| `duration` | [`duration`](../../reference/object-types.md#duration)  | The duration of the punishment. | `30m` | ✅ |