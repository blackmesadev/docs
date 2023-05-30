# Automod

Automod is a module that allows you to automatically moderate your server.

## Configuration

| Key | Type | Description | Default Value | Optional |
| --- | --- | --- | --- | --- |
| `enabled` | `boolean` | Enable or disable automod. | `false` | ❌ |
| `guild_options` | [`GuildOptions`](#guildoptions) | Guild automod settings. | `None` | ✅ |
| `censor_levels` | HashMap<`level`, [`Censor`](#censor)> | A hashmap where the index is the permission level and the value is the Censor config. | `None` | ✅ |
| `censor_channels` | HashMap<`channel`, [`Censor`](#censor)> | A hashmap where the index is a channel ID and the value is the Censor config. | `None` | ✅ |
| `spam_levels` | HashMap<`level`, [`Spam`](#spam)> | A hashmap where the index is the permission level and the value is the Spam config. | `None` | ✅ |
| `spam_channels` | HashMap<`channel`, [`Spam`](#spam)> | A hashmap where the index is a channel ID and the value is the Spam config. | `None` | ✅ |


### `GuildOptions`
| Key | Type | Description | Default Value | Optional |
| --- | --- | --- | --- | --- |
| `minimum_account_age` | `duration` | Minimum account age | `""` | ❌ |

### `Censor`
| Key | Type | Description | Default Value | Optional |
| --- | --- | --- | --- | --- |
| `filer_zalgo` | `boolean` | Enable or disable the zalgo filter. | `false` | ✅ |
| `filter_invites` | `boolean` | Enable or disable the invite whitelist filter. | `false` | ✅ |
| `filter_domains` | `boolean` | Enable or disable the domains filter. | `false` | ✅ |
| `filter_strings` | `boolean` | Enable or disable the word/strings filter. | `false` | ✅ |
| `filter_ips` | `boolean` | Enable or disable the IP filter. | `false` | ✅ |
| `invites_whitelist` | `List<Invites>` | Whitelist for invites, only active when `filter_invites` is enabled. | `[]` | ✅ |
| `invites_blacklist` | `List<Invites>` | Blacklist for invites, always active. | `[]` | ✅ |
| `domains_whitelist` | `List<Domains>` | Whitelist for domains, only active when `filter_domains` is enabled. | `[]` | ✅ |
| `domains_blacklist` | `List<Domains>` | Blacklist for domains, always active. | `[]` | ✅ |
| `blocked_substrings` | `List<Strings>` | Blocked substrings, this will match no matter the spacing or characters around the substring. | `[]` | ✅ |
| `blocked_strings` | `List<Strings>` | Blocked string, this will check each word split by spaces. | `[]` | ✅ |

### `Spam`
| Key | Type | Description | Default Value | Optional |
| --- | --- | --- | --- | --- |
| `interval` | `number` | Number of seconds to track a user for spam after sending a message. | 3 | ✅ |
| `max_messages` | `number` | Maximum number of messages a user can send in the interval before being flagged as spam. | 5 | ✅ |
| `max_mentions` | `number` | Maximum number of mentions a user can send in the interval before being flagged as spam. | 5 | ✅ |
| `max_links` | `number` | Maximum number of links a user can send in the interval before being flagged as spam. | None | ✅ |
| `max_attachments` | `number` | Maximum number of attachments a user can send in the interval before being flagged as spam. | 5 | ✅ |
| `max_emojis` | `number` | Maximum number of emojis a user can send in the interval before being flagged as spam. | None | ✅ |
| `max_newlines` | `number` | Maximum number of newlines a user can send in the interval before being flagged as spam. | None | ✅ |
| `max_characters` | `number` | Maximum number of characters a user can send in the interval before being flagged as spam. | None | ✅ |
| `max_uppercase_percent` | `number` | Maximum number of duplicate messages a user can send in the interval before being flagged as spam. | None | ✅ |