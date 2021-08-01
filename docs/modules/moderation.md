# Moderation

Moderation is your bog standard set of moderation tools that you would expect. All commands you will
ever need will be in this module.

## Commands

| Command Name                                                    | Description                                                                | Permission           |
| --------------------------------------------------------------- | -------------------------------------------------------------------------- | -------------------- |
| `!ban <target:user[]> [time:duration] <reason:string...>`       | Ban `target`s (for `time` if specified) from the server for `reason`.      | `moderation.ban`     |
| `!softban <target:user[]> <reason:string...>`                   | Softban (ban then unban) `target`s from the server for `reason`.           | `moderation.softban` |
| `!kick <target:user[]> <reason:string...>`                      | Kick `target`s from the server for `reason`.                               | `moderation.kick`    |
| `!strike <target:user[]> [amount:number(1)] <reason:string...>` | Issue a `amount` strikes to `target`s for `reason`.                        | `moderation.strike`  |
| `!strikes <target:user>`                                        | Get `target`'s strikes.                                                    | `moderation.strikes` |
| `!purge <messages:int> [type:string] [filter:string...]`        | Purge `messages` messages from the channel that match `type` and `filter`. | `moderation.purge`   |
