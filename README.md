# DOSsle
*Yet another Wordle clone*

This application requires QBasic to run. Here are a few notes about it:

* The seed is based on the current date, so a new puzzle will be generated each day.
* There is no dictionary of valid words that you can enter to conserve memory.
* Alternative dictionaries and word lengths are allowed, but keep in mind that QBasic has a memory limit of 64 KB.
  * I may rewrite it to only load today's word into memory due to the lack of a dictionary otherwise. This is in the `LoadWords` subroutine.
