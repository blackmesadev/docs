# Black Mesa REST API

## Introduction

The Black Mesa API is a RESTful API that allows you to interact with the bot. It is used by the web dashboard and can be used by other applications.

The API uses [semver](https://semver.org/), so you can expect breaking changes to be introduced in new versions.

## Authentication

The Black Mesa API uses [OAuth2](https://oauth.net/2/) for authentication. You can find more information about the OAuth2 flow [here](https://discord.com/developers/docs/topics/oauth2).

### Headers
 - `Authorization` is the OAuth2 access token.


## API Reference

All API requests are made to `https://api.blackmesa.bot/v1/`.

