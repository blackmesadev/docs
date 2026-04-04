+++
title = "Getting Started"
weight = 1
+++

This page walks you through the quickest path from invite to first usable setup.

## Add the bot to your server

Use the invite link from the home page, then choose the server you want to manage.

After inviting:

- Confirm the bot appears in your member list.
- Confirm the bot can read and send messages in your admin/setup channel.
- Run `ping` to verify the bot is online.

## Open the dashboard

Once the bot is in your server, go to the dashboard to manage settings and moderation data.

- Dashboard: https://dashboard.blackmesa.bot/
- API auth is handled through Discord OAuth login.

If you prefer chat-first setup, you can configure directly in Discord:

```
setprefix !
setconfig log_channel <channel_id>
setconfig mute_role <role_id>
group create moderators
group add moderators @Moderator-Role
group grant moderators MODERATION
```

## First-time setup checklist

1. **Enable modules** - moderation and music are disabled by default. Enable them in the dashboard
   under Config, or via `POST /api/config/{id}` with `"moderation_enabled": true`.
2. **Set your prefix** - default is `!`. Change with `setprefix <prefix>`.
3. **Set `log_channel`** - channel where moderation actions are logged.
4. **Set `mute_role`** - required before the `mute` command will work.
5. **Create groups** - create role-aligned groups and grant the appropriate permission flags.
   See [Permissions](@/bot/permissions.md) for flag names.
6. **Test** - try a moderation command in a private staff channel to verify everything works.

## Navigate these docs by task

| Task | Doc |
| --- | --- |
| Command syntax | [Commands](@/bot/commands.md) |
| Config keys and automod | [Configuration](@/bot/configuration.md) |
| Permission flags and groups | [Permissions](@/bot/permissions.md) |
| API integration | [API](api/) |

## Need help?

- Support server: https://discord.gg/ZezqXEXBDJ
- Project repository: https://github.com/blackmesadev/black-mesa
