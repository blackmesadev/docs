# Reason

Set the reason of an infraction.

## Syntax

`duration [uuid:uuid] <reason:string>`

If [`uuid`](../../../reference/object-types.md#uuid) is not specified, the reason will be applied to the most recent infraction made by the command author.

## Permission

`admin.update`

OR

`moderation.updateself` if [`uuid`](../../../reference/object-types.md#uuid) is not specified and the infraction was made by the command author.

## Example

- `!reason Being very naughty`
- `!reason c488c9ec-423a-437c-817c-41d0d4141e58 Extremely Naughty`
