DECLARE SUB LetterBoard ()
DECLARE SUB LoadWords (filename$)
DECLARE FUNCTION CheckWord% (guess$, j%)

SCREEN 13: CLS : COLOR 15
'14 = yellow, 2 = green, 15 = white
PLAY "T120O4L16"

PRINT "DOSsle - "; DATE$

CONST WordLength = 5
DIM word AS STRING
DIM WordCount AS INTEGER
DIM seed AS INTEGER
DIM WordList(4999) AS STRING * WordLength  'maximum 5000 words
DIM GuessColors(25) AS INTEGER 'guessed letters and colors
FOR i% = 0 TO 25
    GuessColors(i%) = 15 'white
NEXT i%

seed = VAL(LEFT$(DATE$, 2)) * 100 + VAL(MID$(DATE$, 4, 2)) * 1200 + VAL(RIGHT$(DATE$, 2)) - 20000

CALL LoadWords("words5.txt")
UseWord = INT(RND(seed) * WordCount)

'PRINT "Word selected."


FOR j% = 0 TO 5
    CALL LetterBoard
    guess$ = ""
    WHILE LEN(guess$) <> 5
        COLOR 15
        LOCATE 3 + (j% * 2), 8
        INPUT "", guess$
        LOCATE 3 + (j% * 2), 1: PRINT "              "
    WEND
   
    'Check if the word was guessed
    IF CheckWord(guess$, j%) = 1 THEN
        EXIT FOR
    END IF
NEXT j%
CALL LetterBoard
LOCATE 15, 8
COLOR 5
SELECT CASE j%
    CASE 0
        PRINT "Genius"
    CASE 1
        PRINT "Magnificent"
    CASE 2
        PRINT "Impressive"
    CASE 3
        PRINT "Splendid"
    CASE 4
        PRINT "Great"
    CASE 5
        PRINT "Phew"
    CASE ELSE
        COLOR 4
        LOCATE 15, 4
        PRINT "The word is: "; UCASE$(WordList(UseWord))
END SELECT
COLOR 15
END

FUNCTION CheckWord% (guess$, j%)
    SHARED WordList() AS STRING * WordLength
    SHARED UseWord
    SHARED GuessColors() AS INTEGER
    'Count letters in word, reset at each guess
    DIM Letters(25) AS INTEGER
    FOR i% = 0 TO 25
        Letters(i%) = 0
    NEXT i%
    TheWord$ = UCASE$(WordList(UseWord))
    FOR i% = 1 TO WordLength
        lo% = ASC(MID$(TheWord$, i%, 1)) - 65
        Letters(lo%) = Letters(lo%) + 1
    NEXT i%
    DIM WPrint(WordLength - 1) AS STRING
    DIM WColor(WordLength - 1) AS INTEGER

    guess$ = UCASE$(guess$)
    wd$ = UCASE$(WordList(UseWord))

    'First fill array
    FOR i% = 0 TO WordLength - 1
        T$ = MID$(guess$, i% + 1, 1)'guess letter
        lo% = ASC(T$) - 65       '^ to 0-25 for alpha position
        WPrint(i%) = T$
        WColor(i%) = 7 'gray
        IF GuessColors(lo%) = 15 THEN 'not guessed before
            GuessColors(lo%) = 8
        END IF
    NEXT i%
 
    'Exact matches next
    FOR i% = 1 TO WordLength
        T$ = MID$(guess$, i%, 1) 'guess letter
        lo% = ASC(T$) - 65       '^ to 0-25 for alpha position
        IF T$ = MID$(wd$, i%, 1) THEN
            WColor(i% - 1) = 2 'green
            GuessColors(lo%) = 2
            Letters(lo%) = Letters(lo%) - 1 'letter found
        END IF
    NEXT i%

    'Letters existing elsewhere
    FOR i% = 1 TO WordLength
        T$ = MID$(guess$, i%, 1) 'guess letter
        lo% = ASC(T$) - 65       '^ to 0-25 for alpha position
        IF T$ <> MID$(wd$, i%, 1) AND Letters(lo%) > 0 THEN
            'any remaining letters are elsewhere
            WColor(i% - 1) = 14'yellow
            IF GuessColors(lo%) <> 2 THEN 'not confirmed exact
                GuessColors(lo%) = 14
            END IF
            Letters(lo%) = Letters(lo%) - 1 'don't count dupes
        END IF
    NEXT i%
      
    'Now print it
    FOR i% = 0 TO WordLength - 1
        PLAY "EP8"
        LOCATE 3 + (j% * 2), 8 + (i% * 2)
        COLOR WColor(i%)
        PRINT WPrint(i%)
        
    NEXT i%

    IF wd$ = guess$ THEN
        CheckWord% = 1
    ELSE
        CheckWord% = 0
    END IF
END FUNCTION

SUB LetterBoard
SHARED GuessColors() AS INTEGER
Keyboard$ = "QWERTYUIOPASDFGHJKLZXCVBNM"
FOR i% = 1 TO 26
    ltr% = ASC(MID$(Keyboard$, i%, 1)) - 65
    IF i% <= 10 THEN
        LOCATE 18, (i% * 2) + 2
    ELSEIF i% <= 19 THEN
        LOCATE 20, (i% * 2) - 17
    ELSE
        LOCATE 22, (i% * 2) - 34
    END IF
    COLOR GuessColors(ltr%)
    PRINT CHR$(ltr% + 65)
NEXT i%

END SUB

SUB LoadWords (filename$)
    SHARED WordList() AS STRING * WordLength
    SHARED WordCount AS INTEGER

    WordCount = 0
    OPEN filename$ FOR INPUT AS #1
    DO UNTIL EOF(1)
        LINE INPUT #1, WordIn$
        WordList(WordCount) = WordIn$
        WordCount = WordCount + 1
    LOOP
    CLOSE #1
    'PRINT : PRINT "Loaded"; WordCount; "words"
END SUB

