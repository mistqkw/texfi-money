# Bank logos

By default TexFi m0ney draws its **own abstract mark** for each bank (a ring,
arc, shield, bars…) in that bank's brand colour. No bank's real logo or
trademark ships with this repository — redistributing third-party trademarks
in an open-source project isn't something the project can grant itself
permission to do.

## Using real logos

If you want a real logo for a bank you actually use, drop a PNG here named
after the bank's id from `lib/core/constants/banks.dart`:

```
assets/banks/sber.png
assets/banks/monobank.png
assets/banks/chase.png
```

The app picks it up automatically — `BankMark` tries the asset first and
silently falls back to the drawn mark when the file isn't there. Nothing to
register, no code to change.

**Recommended:** square PNG, 128×128 or larger, transparent background.

## A note on trademarks

Bank logos are trademarks of their respective owners. Using one to label
*your own* account inside a personal, offline app is generally fine. Shipping
those logos inside a public app or repository you distribute to others is a
different question — check the bank's brand guidelines first. That's exactly
why this folder is empty by default.
