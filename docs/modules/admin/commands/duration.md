# Duration

Set the [`duration`](../../../reference/object-types.md#duration) of an infraction from the point the update is made.

## Syntax

`duration [uuid:uuid] <time:duration>`

If [`uuid`](../../../reference/object-types.md#uuid) is not specified, the duration will be applied to the most recent infraction made by the command author.

## Permission

`admin.update`

OR

`moderation.updateself` if [`uuid`](../../../reference/object-types.md#uuid) is not specified and the infraction was made by the command author.

## Example

- `!duration 20m`
- `!duration c488c9ec-423a-437c-817c-41d0d4141e58 1d`
