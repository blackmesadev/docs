# Logging

Logging is a module that allows you to log events to a channel.

## Configuration

| Key | Type | Description | Default Value | Optional |
| --- | --- | --- | --- | --- |
| `enabled` | `boolean` | Enable or disable logging. | `false` | ❌ |
| `channel_id` | [`channel`](../../reference/object-types.md#channel) | The channel ID to send the logs to. | `None` | ✅ |
| `include_actions` | List<[`event`](#event)> | A list of events to log. | `[ALL]` | ✅ |
| `ignored_users` | List<[`user`](../../reference/object-types.md#user)> | A list of users to be exempt from the logs. | `[]` | ✅ |
| `ignored_channels` | List<[`channel`](../../reference/object-types.md#channel)> | A list of channels to be exempt from the logs. | `[]` | ✅ |



### `Event`
Note, all values here are usable, they work as groups, just without nodes. So both `AuditLog` and `AutomodCensor` are valid.
I recommend just using `ALL` if you want to log everything.

    - ALL
      - AUDIT_LOG
          - REMOVE_ACTION
          - UPDATE_ACTION
          - CHANNEL_DELETE
          - CHANNEL_EDIT
          - CHANNEL_CREATE

      - AUTOMOD_LOG
          - AUTOMOD_CENSOR
          - AUTOMOD_SPAM

      - MOD_LOG
          - STRIKE
          - MUTE
          - UNMUTE
          - KICK
          - BAN
          - UNBAN

      - MESSAGE_LOG
          - MESSAGE_DELETE
          - MESSAGE_EDIT
