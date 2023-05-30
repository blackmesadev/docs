# Remove

Remove an infraction from a user.

## Syntax

`remove <uuid:uuid>`

Unlike the update commands, [`uuid`](../../../reference/object-types.md#uuid) is required in remove.

## Permission

`admin.remove`

OR

`moderation.removeself` if [`uuid`](../../../reference/object-types.md#uuid) the infraction was made by the command author.

## Example

- `!remove c488c9ec-423a-437c-817c-41d0d4141e58`
