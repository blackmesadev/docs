# Moderation

Moderation is your bog standard set of moderation tools that you would expect. All commands you
will ever need will be in this module.

## Commands

| Command Name                                                 | Description                                                      | Permission           |
| ------------------------------------------------------------ | ---------------------------------------------------------------- | -------------------- |
| `!ban <target:user[]> [time:duration] <reason:string...>`    | Ban a user or set of users (temporarily) from the server.        | `moderation.ban`     |
| `!softban <target:user[]> <reason:string...>`                | Softban (ban then unban) a user or set of users from the server. | `moderation.softban` |
| `!kick <target:user[]> <reason:string...>`                   | Kick a user or set of users from the server.                     | `moderation.kick`    |
| `!strike <target:user[]> [amount:number] <reason:string...>` | Issue a certain amount of strikes to a user or a set of users.   | `moderation.strike`  |
| `!strikes <target:user>`                                     | Get a user's strikes.                                            | `moderation.strikes` |
