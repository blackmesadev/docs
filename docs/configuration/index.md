# Configuration

| Key | Type | Description | Default Value | Optional |
| --- | --- | --- | --- | --- |
| `prefix` | `string` | The prefix for the bot. | `!` | ❌ |
| `permissions` | HashMap<permission, level> | A map where the index is the permission node and the key is the level. | `{}` | ❌ |
| `levels` | HashMap<snowflake, level> | A map where the index is the snowflake and the key is the level. This works with user IDs and role IDs | `{}` | ❌ |
| `modules` | [`Modules`](#modules) | A struct of modules and their configurations. | N/A | ❌ |

### `Modules`

| Key | Type | Description | Default Value | Optional |
| --- | --- | --- | --- | --- |
| `automod` | [`Automod`](./modules/automod.md#automod) | The automod module. | N/A | ❌ |
| `Logging` | [`Logging`](./modules/logging.md#logging) | The logging module. | N/A | ❌ |
| `moderation` | [`Moderation`](./modules/moderation.md#moderation) | The moderation module. | N/A | ❌ |