+++
title = "Privacy Policy"
weight = 10
+++

**Last updated:** April 4, 2026

Black Mesa ("the Bot", "we", "our") is committed to protecting your privacy. This Privacy Policy explains what data we collect, why we collect it, how long we retain it, and your rights regarding your data.

## 1. Data Controller

Black Mesa is ran by Tyler Thompson. For privacy-related inquiries, contact us at the [support server](https://discord.gg/ZezqXEXBDJ).

## 1.1 Important: How Black Mesa Processes Your Data

Black Mesa is a **guild-level bot** invited by server administrators. This means:

- **Guild administrators** invite the bot and control its configuration (they have a service relationship with us)
- **Guild members** are processed automatically when the bot is present in their server (they have NOT individually consented)
- **Dashboard users** explicitly consent via Discord OAuth when logging in

**If you are a guild member** (not an admin), your Discord ID and related data are processed based on **legitimate interest** (see Section 3.1). You did not individually consent to this processing - the guild administrator made that decision by inviting the bot. Your primary method of opting out is to leave the guild or ask the administrator to remove the bot.

## 2. What Data We Collect

### 2.1 Discord Data

When you use Black Mesa or authenticate with our dashboard, we process the following Discord-provided data:

- **Discord IDs**: User IDs, guild (server) IDs, channel IDs, role IDs, and message IDs
- **Guild Information**: Guild name, channel list, role list, member list
- **User Information**: Username, discriminator (if applicable), avatar URL
- **Member Information**: Guild-specific roles, join dates, nicknames
- **OAuth Tokens**: Discord access tokens and refresh tokens (stored encrypted in session JWTs)

### 2.2 Configuration Data

For each guild where Black Mesa is installed, we store:

- Guild configuration settings (prefix, enabled modules, logging preferences)
- Permission groups with associated role and user IDs
- Automod rules (filter lists, spam thresholds, bypass permissions)
- Command aliases
- Logging configuration (event types, channel overrides, message templates)

### 2.3 Moderation Records

When moderation actions are performed, we store:

- **Infraction Type**: Warn, mute, kick, ban
- **Timestamps**: Creation time, expiration time (if applicable), last edited time
- **Associated IDs**: Target user ID, moderator user ID, guild ID
- **Metadata**: Reason (if provided), mute role ID (for mutes), automod offense details
- **Status**: Whether the infraction is active or expired

### 2.4 Music Playback Data

Mesastream (our music service) processes:

- **Voice Channel Data**: Guild ID, channel ID, user ID of the requester
- **Media Metadata**: Track titles, URLs, duration (not stored persistently - only cached temporarily)
- **Playback State**: Current track, queue, volume (cached in Redis)

### 2.5 Cache Data

We cache the following in Redis for performance optimization:

- Guild configurations (TTL: varies)
- Discord API responses (guilds, channels, members, roles, users)
- Voice channel connection state
- Music queue and playback state
- OAuth session data

**Retention:** Cache entries expire automatically after their TTL (typically 5-15 minutes for Discord API data, session-based for voice/music).

### 2.6 Observability & Telemetry

We use **OpenTelemetry** to collect traces, logs, and metrics for debugging and performance monitoring. Telemetry data may include:

- **Span Context**: Operation names, timestamps, duration, error status
- **Attributes**: Guild IDs, user IDs, channel IDs, command names, HTTP status codes
- **Logs**: Error messages, warnings, informational messages with contextual IDs
- **Metrics**: Request counts, latency distributions, cache hit rates

**What we DO NOT collect in telemetry:**
- Message content (except in error cases where automod is triggered)
- Voice audio data
- Private user information beyond Discord IDs

**Retention:** Telemetry data is retained in OpenObserve for **30 days**, after which it is automatically purged.

## 3. Legal Basis for Processing (GDPR)

For users in the European Economic Area, we process your data under the following legal bases:

### 3.1 Legitimate Interest (Art. 6(1)(f) GDPR)

**Applies to:** Guild members whose data is processed automatically by the bot

When a guild administrator invites Black Mesa to their server, we process guild members' Discord IDs and related data based on **legitimate interest**:

- **Our legitimate interest**: Providing moderation tools, maintaining server safety, enabling guild-specific features (permissions, automod, logging)
- **Guild admin's legitimate interest**: Managing their community, enforcing rules, maintaining moderation records
- **Balancing test**: We process only Discord-provided identifiers (not personal messages or sensitive data), cache data temporarily, and allow users to exercise their rights (see Section 7)

**Your right to object:** You may object to this processing by leaving the guild or asking the guild administrator to remove the bot. Individual guild members cannot opt out while remaining in a guild with the bot active.

### 3.2 Consent (Art. 6(1)(a) GDPR)

**Applies to:** Users who voluntarily log into the dashboard via Discord OAuth

When you click "Authorize" on Discord's OAuth screen to access the dashboard, you explicitly consent to our processing of your OAuth tokens and user information for authentication purposes. You may withdraw consent at any time by logging out and revoking the application in Discord's "Authorized Apps" settings.

### 3.3 Contractual Necessity (Art. 6(1)(b) GDPR)

**Applies to:** Guild administrators who invite the bot

When a guild administrator invites Black Mesa, an implicit service agreement is formed. Processing guild data (configuration, permission groups, moderation records) is necessary to fulfill this agreement and provide the requested bot functionality.

## 4. How We Use Your Data

We use collected data to:

- Provide bot functionality (moderation, permissions, music, automod, logging)
- Enforce guild-specific configurations and permission rules
- Maintain moderation history for guild administrators
- Cache frequently accessed data to reduce latency
- Monitor service health, debug errors, and optimize performance
- Prevent abuse and enforce Discord's Terms of Service

## 5. Data Sharing

We **do not sell, rent, or share** your data with third parties, except as follows:

### 5.1 Discord

We interact with Discord's API to:
- Retrieve guild and user information
- Perform moderation actions (ban, kick, mute)
- Send messages and embeds
- Authenticate dashboard users via OAuth

Discord's [Privacy Policy](https://discord.com/privacy) governs their handling of data.

### 5.2 Service Providers

- **Hosting & Infrastructure**: We self-host Black Mesa services. No third-party hosting providers receive your data.
- **Observability**: If you deploy Black Mesa yourself, telemetry is stored in your own OpenObserve instance (see deployment documentation).

### 5.3 Legal Obligations

We may disclose data if required by law, court order, or to protect our legal rights.

## 6. Data Retention

| Data Type | Retention Period | Rationale |
| --- | --- | --- |
| **Guild Configurations** | Until the bot is removed from the guild | Necessary for bot operation |
| **Permission Groups** | Until deleted by guild admin or bot removal | Guild-specific access control |
| **Infractions** | Indefinitely (unless deleted by admin) | Moderation history for guild admins |
| **Cache (Redis)** | 5-60 minutes (varies by data type) | Performance optimization |
| **Telemetry (OpenObserve)** | 30 days | Debugging and monitoring |
| **OAuth Tokens (JWT)** | Session-based (typically 7 days) | Dashboard authentication |
| **Music Metadata** | Session-based (cleared on disconnect) | Temporary playback state |

## 7. Your Rights (GDPR & CCPA)

You have the following rights regarding your data. **Note:** Because Black Mesa operates at the guild level (invited by server admins), individual guild members have limited control over data processing. Guild administrators control most guild-specific data.

### 7.1 Access

**Dashboard users:** Export your data via the API or contact us.
**Guild members:** Request a copy of infractions or cached data about you by contacting me on the support server.

### 7.2 Rectification

**Guild administrators** can update configurations, permission groups, and infraction records via the dashboard or bot commands.
**Individual members:** If you believe an infraction record is inaccurate, contact the guild administrator or request a review via our support server.

### 7.3 Erasure ("Right to Be Forgotten")

**Limitations:** Because moderation records are maintained for accountability and guild safety, we balance erasure requests against the legitimate interest of guild administrators.

You may request deletion of:
- **Your user ID from permission groups** (contact guild admin or us)
- **Cached data** (automatically purged after TTL)
- **Inactive/expired infractions** (contact guild admin)

**We cannot delete:**
- Active moderation records (bans, mutes) while they are in effect
- Historical infractions if the guild admin determines they are necessary for accountability
- Discord IDs from logs required for compliance or legal purposes

**Full removal:** To completely opt out of data processing, leave the guild or ask the guild administrator to remove the bot.

### 7.4 Data Portability

**Guild administrators:** Export your guild's configuration and infraction data via the API:
- `GET /api/config/{guild_id}`
- `GET /api/infractions/{guild_id}`

**Individual members:** Request a machine-readable copy of your infractions by contacting me.

### 7.5 Objection & Restriction

**Guild members:** You may object to data processing under legitimate interest by:
1. Leaving the guild (stops future processing)
2. Requesting the guild administrator remove the bot
3. Contacting us to discuss specific objections (we will balance your rights against the guild's legitimate interest)

**Dashboard users:** Revoke OAuth consent by logging out and removing the app from Discord's "Authorized Apps" settings.

## 8. Data Security

We implement the following security measures:

- **Encryption in Transit**: All API requests use HTTPS/TLS
- **Encryption at Rest**: Database credentials and sensitive secrets are stored in environment variables, not hardcoded
- **Access Control**: Database and Redis are bound to `127.0.0.1` (localhost) and require authentication
- **JWT Security**: Session tokens use HMAC-SHA256 signing with a secret key
- **Input Validation**: All user inputs are validated and parameterized queries prevent SQL injection
- **Minimal Logging**: We do not log message content, user passwords, or sensitive credentials

**Self-Hosting Security Note:** If you deploy Black Mesa yourself, you are responsible for securing your infrastructure, setting strong passwords, and configuring firewalls.

## 9. Children's Privacy

Black Mesa does not knowingly collect data from users under 13 years of age. Discord's Terms of Service prohibit users under 13. If we become aware that we have collected data from a child under 13, we will delete it promptly.

## 10. International Data Transfers

Black Mesa is hosted in [your region - update as needed]. If you access the bot from outside this region, your data may be transferred across borders. We ensure that such transfers comply with applicable data protection laws.

## 11. Cookie Policy

Our **dashboard** may use cookies for:
- Session management (authentication state)
- Analytics (if enabled - currently not implemented)

You can disable cookies in your browser, but this may affect dashboard functionality.

## 12. Changes to This Policy

We may update this Privacy Policy from time to time. The "Last updated" date at the top indicates the most recent revision.

- **Dashboard users:** Continued use after changes constitutes acceptance.
- **Guild admins:** We may notify you via the support server or bot announcements for material changes.
- **Guild members:** Because processing is based on legitimate interest (not consent), policy changes do not require your acceptance. However, you may object to changes by leaving the guild or requesting the admin remove the bot.

## 13. Contact Us

For privacy-related questions, data requests, or concerns:

- **Support Server**: [https://discord.gg/ZezqXEXBDJ](https://discord.gg/ZezqXEXBDJ)
- **GitHub Issues**: [https://github.com/blackmesadev/black-mesa/issues](https://github.com/blackmesadev/black-mesa/issues)

---

**Summary in Plain English:**
- **Guild members:** Your Discord IDs and moderation records are processed based on **legitimate interest** when a server admin invites the bot - you have not individually consented. To opt out, leave the guild or ask the admin to remove the bot.
- **Guild admins:** You control most data via the dashboard/commands. By inviting the bot, you enter a service relationship with us.
- **Dashboard users:** You explicitly consent via Discord OAuth when logging in.
- We collect Discord IDs, guild configs, moderation logs, and performance data to run the bot.
- We cache data in Redis and log telemetry to OpenObserve for debugging (auto-purged after 30 days).
- We don't sell your data or share it with third parties (except Discord for OAuth).
- You can request data export or deletion by contacting us, but guild admins may decline erasure of moderation records for accountability.
- We use encryption and access controls to protect your data.
