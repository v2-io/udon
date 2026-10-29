# Before the options: what would you write, and what would you expect?

*Answer these from `BASICS.md` and your own instincts, before opening `OPTIONS.md`. What you write untaught is the one thing the trial can't recover once you've seen the options.*

## Write

For each, write the UDON you'd naturally write, with no attempt to guess what anyone wants. If you'd hesitate or want a rule you don't have, say what you'd want.

1. A sample measured at a mass of 3.2 kilograms and a temperature of 21.5 °C.
2. An event on 1 October 2026, lasting 90 minutes, starting at 14:30 in Denver.
3. A validation rule whose pattern is the regular expression `^\d{3}-\d{4}$`, and a Windows path `C:\Users\me`.
4. A server: host `localhost`, port 8080, debug turned off, retries 3, an owner that is explicitly nothing (null).
5. A paragraph in which someone says "Hello," and then the sentence continues: she said.
6. A list of three holiday dates.
7. A part whose version is 1.10 (a version string, not a number) and whose zip code is 01234.
8. An HTML-ish link whose target is `https://example.com` and whose text is "Click here".

## Read

For each line, say what you'd expect it to mean (a sketch of the tree, or plain words), and how sure you are.

```udon
|p "Hello," she said.
|sample :mass.kg 3.2
|sample :mass(kg) 3.2
|ev :on date(2026-10-01)
|ev :on ~date 2026-10-01
|h3 date(format)
|config :server.port 8080
|server :host: localhost
|li printf(x) prints x
```
