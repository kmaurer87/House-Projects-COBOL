      ******************************************************************
      * Author:
      * Date:
      * Purpose:
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. YOUR-PROGRAM-NAME.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT HOUSEWORK ASSIGN TO "bin/housework2.csv"
           ORGANIZATION IS LINE SEQUENTIAL.

           SELECT WITHOUTCOMMAS ASSIGN TO "BIN/HOUSEPROJECTS.NEW"
           ORGANIZATION IS LINE SEQUENTIAL.

           SELECT FILEFORTABLE ASSIGN TO "BIN/HOUSEPROJECTScopy.TXT"
           ORGANIZATION IS LINE SEQUENTIAL.


       DATA DIVISION.
       FILE SECTION.

       FD HOUSEWORK.
       01 FILEDETAILS.
           88 ENDOFFILE VALUE HIGH-VALUES.
           02 DETAILS     PIC X(130).

       FD WITHOUTCOMMAS.
       01 PRINTLINE.
           02 FILLER      PIC X(175).


       FD FILEFORTABLE.
       01 TABLEDETAILS.
           88 ENDOFFILE2 VALUE HIGH-VALUES.
           05 PROJECT-NUM  PIC 99.
           05 PROJECT-NICKNAME PIC X(15).
           05 PROJECT-SIZE     PIC X(9).
           05 PROJECT-LOCATION PIC X(15).
           05 PROJECT-COST     PIC X(7).
           05 PROJECT-STATUS   PIC X.



       WORKING-STORAGE SECTION.


       01 WORKING-STORAGE-SECTION.
           05 FILLER               PIC X(110) VALUE SPACES.
           05 ITERATOR             PIC 99 VALUE ZEROES.

           05 SEARCH-KEY           PIC X(10).
           05 SEARCH-MESSAGE       PIC X(10).
           05 SEARCH-MESSAGE2       PIC X(10).
           05 SEARCH-MESSAGE3       PIC X(10).
           05 SEARCH-MESSAGE4       PIC X.
           05 PROJECTINFO OCCURS 11 TIMES
           ASCENDING KEY IS TABLE-SIZE
            INDEXED BY TABLE-INDEX.
               10 TABLE-NUM        PIC 99.
               10 TABLE-NICKNAME   PIC X(15).

               10 TABLE-SIZE       PIC X(9).
               10 TABLE-LOCATION   PIC X(15).
               10 TABLE-COST       PIC X(7).
               10 TABLE-STATUS     PIC X.


       01 NEW-ENTRY.
           05 NEW-PROJECT-NUM PIC 99.
           05 NEW-NAME PIC X(18).
           05 NEW-SIZE PIC X(10).
           05 NEW-LOCATION PIC X(15).
           05 NEW-COST PIC X(7).
           05 NEW-STATUS PIC X.


       01 WS-PROJECT-INFO.
           05 WS-PROJECT-NUM       PIC 99.
           05 WS-PROJECT-NICKNAME  PIC X(15).
           05 WS-PROJECT-SIZE      PIC X(9).
           05 WS-LOCATION-IN-HOUSE PIC X(15).
           05 WS-ESTIMATED-COST    PIC X(7).
           05 WS-COMPLETION-STATUS PIC X.

           05 STRINGEND          PIC 99.

       01 WS-DISPLAY-HOUSEWORK.

           05 WS-DISPLAY-NUM       PIC 99.
           05 FILLER               PIC X VALUE SPACES.
           05 WS-DISPLAY-NAME      PIC X(18).
           05 WS-DISPLAY-SIZE      PIC X(10).
           05 WS-DISPLAY-LOCATION  PIC X(15).
           05 FILLER               PIC X(4) VALUE SPACES.
           05 WS-DISPLAY-COST      PIC X(7).
           05 FILLER               PIC X(10) VALUE SPACES.
           05 WS-DISPLAY-STATUS    PIC X.

       01 WS-DISPLAY-HOUSEWORK-TABLE.


           05 WS-DISPLAY-NUM-TABLE      PIC 99.
           05 FILLER                     PIC X VALUE SPACES.
           05 WS-DISPLAY-NAME-TABLE     PIC X(18).
           05 WS-DISPLAY-SIZE-TABLE    PIC X(10).
           05 FILLER                   PIC XX VALUE SPACES.
           05 WS-DISPLAY-LOCATION-TABLE PIC X(15).
           05 FILLER                    PIC X(4) VALUE SPACES.
           05 WS-DISPLAY-COST-TABLE     PIC X(7).
           05 FILLER                    PIC X(10) VALUE SPACES.
           05 WS-DISPLAY-STATUS-TABLE    PIC X.


       01 WS-HEADING-INFO.
           05 FILLER   PIC X(27) VALUE SPACES.
           05 WS-TITLE PIC X(19) VALUE "YOUR HOUSE PROJECTS".
           05 FILLER   PIC X(35) VALUE SPACES.
           05 FILLER   PIC X(3) VALUE SPACES.
           05 FILLER   PIC X(8) VALUE "NICKNAME".
           05 FILLER   PIC X(11) VALUE SPACES.
           05 FILLER   PIC X(4) VALUE "SIZE".
           05 FILLER   PIC X(7) VALUE SPACES.
           05 FILLER   PIC X(8)  VALUE "LOCATION".
           05 FILLER   PIC X(4)  VALUE SPACES.
           05 FILLER   PIC X(14) VALUE "ESTIMATED COST".
           05 FILLER   PIC X(4)  VALUE SPACES.
           05 FILLER   PIC X(10) VALUE "COMPLETED?".

       01 WS-USER-INPUT.

           05 USER-INITIAL-INPUT        PIC 9.
           05 USER-SIZE-INPUT           PIC X(9).
           05 USER-CHANGES-INPUT       PIC 9.
           05 USER-ADD-NAME            PIC X(18).
           05 USER-ADD-SIZE            PIC X(10).
           05 USER-ADD-LOCATION        PIC X(10).
           05 USER-ADD-COST            PIC X(7).
           05 USER-ADD-STATUS          PIC X.

       01 WS-PROJECT-NUMS.

           05 WS-NUM-OF-PROJECT        PIC 9.



       PROCEDURE DIVISION.
       1000-MAIN-PROCEDURE.
       DISPLAY "TO SEE A LIST OF YOUR PROJECTS, TYPE 1. "
           "TO SEARCH FOR A PROJECT BY SIZE, TYPE 2."
           "TO EDIT A PROJECT, TYPE 3."

       ACCEPT USER-INITIAL-INPUT.
           IF USER-INITIAL-INPUT = 1 THEN
               PERFORM 2010-OPEN-FILE
           ELSE IF USER-INITIAL-INPUT = 2 THEN
            PERFORM 4020-GET-READY-FOR-TABLE
         *>  ELSE IF USER-INITIAL-INPUT = 3 THEN
          *>  PERFORM 3010-GET-READY-FOR-CHANGES

           ELSE
               DISPLAY "ENTER A VALID NUMBER."
               PERFORM 1000-MAIN-PROCEDURE
           END-IF.


       2010-OPEN-FILE.
           OPEN INPUT HOUSEWORK.
           READ HOUSEWORK
               AT END SET ENDOFFILE TO TRUE
           END-READ.
           OPEN OUTPUT WITHOUTCOMMAS.

           WRITE PRINTLINE FROM WS-HEADING-INFO.

           DISPLAY WS-HEADING-INFO.

           PERFORM 4000-UNSTRING-DATA UNTIL ENDOFFILE.

           CLOSE HOUSEWORK.
           CLOSE WITHOUTCOMMAS.

           PERFORM 9000-END-PROGRAM.
       4000-UNSTRING-DATA.

           PERFORM VARYING STRINGEND FROM 50 BY -1
             UNTIL DETAILS(STRINGEND:1)NOT = SPACE
           END-PERFORM.

           UNSTRING DETAILS(1:STRINGEND) DELIMITED BY ","
             INTO WS-PROJECT-NUM
                  WS-PROJECT-NICKNAME
                  WS-PROJECT-SIZE
                  WS-LOCATION-IN-HOUSE
                  WS-ESTIMATED-COST
                  WS-COMPLETION-STATUS

           END-UNSTRING.

           MOVE WS-PROJECT-NUM TO WS-DISPLAY-NUM.
           MOVE WS-PROJECT-NICKNAME TO WS-DISPLAY-NAME.
           MOVE WS-PROJECT-SIZE TO WS-DISPLAY-SIZE.
           MOVE WS-LOCATION-IN-HOUSE TO WS-DISPLAY-LOCATION.
           MOVE WS-ESTIMATED-COST TO WS-DISPLAY-COST.
           MOVE WS-COMPLETION-STATUS TO WS-DISPLAY-STATUS.
           DISPLAY WS-DISPLAY-HOUSEWORK.

           WRITE PRINTLINE FROM WS-DISPLAY-HOUSEWORK.


           READ HOUSEWORK
               AT END SET ENDOFFILE TO TRUE
           END-READ.

       4020-GET-READY-FOR-TABLE.
           OPEN INPUT FILEFORTABLE
           READ FILEFORTABLE
           AT END SET ENDOFFILE2 TO TRUE
           END-READ.
          *> DISPLAY WS-HEADING-INFO.
           COMPUTE ITERATOR = 1.
           PERFORM 4010-DISPLAY-AS-TABLE UNTIL ENDOFFILE2.

          *> PERFORM 4030-DISPLAY-TABLE.
           DISPLAY "PLEASE ENTER A PROJECT SIZE"
           "(full day+, full day, half day, 1-3 hrs)".
           ACCEPT SEARCH-KEY.


           PERFORM  VARYING ITERATOR FROM 1 BY 1
             UNTIL ITERATOR > 11
                 IF TABLE-SIZE(ITERATOR) = SEARCH-KEY

                 SET SEARCH-MESSAGE TO TABLE-NICKNAME(ITERATOR)
                 SET SEARCH-MESSAGE2 TO TABLE-LOCATION(ITERATOR)
                 SET SEARCH-MESSAGE3 TO TABLE-COST(ITERATOR)
                 SET SEARCH-MESSAGE4 TO TABLE-STATUS(ITERATOR)

             DISPLAY 'SEARCH RESULTS:', TABLE-NICKNAME(ITERATOR), ' ',
             TABLE-LOCATION(ITERATOR), ' ', TABLE-COST(ITERATOR), ' ',
             TABLE-STATUS(ITERATOR)
           END-IF
           END-PERFORM.
           PERFORM 9000-END-PROGRAM.
           *>SEARCH ALL PROJECTINFO
              *> AT END
                *>   MOVE 'UNKNOWN' TO SEARCH-MESSAGE
              *> WHEN TABLE-SIZE (TABLE-INDEX) = SEARCH-KEY
                 *>  MOVE TABLE-NICKNAME (TABLE-INDEX)
                 *>      TO SEARCH-MESSAGE
           *>END-SEARCH.


      *PERFORM 4030-DISPLAY-TABLE.

       4010-DISPLAY-AS-TABLE.


           MOVE PROJECT-NUM TO TABLE-NUM(ITERATOR)
           MOVE PROJECT-NICKNAME TO TABLE-NICKNAME(ITERATOR)
           MOVE PROJECT-SIZE TO TABLE-SIZE(ITERATOR)
           MOVE PROJECT-LOCATION TO TABLE-LOCATION (ITERATOR)
           MOVE PROJECT-COST TO TABLE-COST(ITERATOR)
           MOVE PROJECT-STATUS TO TABLE-STATUS(ITERATOR)

           COMPUTE ITERATOR = ITERATOR + 1.
           READ FILEFORTABLE
           AT END SET ENDOFFILE2 TO TRUE
           END-READ.



       4030-DISPLAY-TABLE.

           PERFORM VARYING ITERATOR FROM 1 BY 1
             UNTIL ITERATOR > 11

             MOVE TABLE-NUM(ITERATOR) TO WS-DISPLAY-NUM-TABLE

             MOVE TABLE-NICKNAME(ITERATOR) TO WS-DISPLAY-NAME-TABLE
             MOVE TABLE-SIZE(ITERATOR) TO WS-DISPLAY-SIZE-TABLE
             MOVE TABLE-LOCATION(ITERATOR) TO WS-DISPLAY-LOCATION-TABLE
             MOVE TABLE-COST(ITERATOR) TO WS-DISPLAY-COST-TABLE

             MOVE TABLE-STATUS(ITERATOR) TO WS-DISPLAY-STATUS-TABLE

           *>DISPLAY WS-DISPLAY-HOUSEWORK-TABLE

           END-PERFORM.


           PERFORM 9000-END-PROGRAM.




      *>  3010-GET-READY-FOR-CHANGES.


       PERFORM 3050-MAKE-CHANGES.


       3050-MAKE-CHANGES.

       *>MOVE
       *>MOVE NEW-SIZE TO TABLE-SIZE(ITERATOR).


      *>  EVALUATE NUMBER-OF-OCCURS

      *>   WHEN NUMBER-OF-OCCURS < LENGTH OF PROJECTINFO
      *>      ADD +1 TO NUMBER-OF-OCCURS
      *>   WHEN NUMBER-OF-OCCURS > LENGTH OF PROJECTINFO
       *>    SET NEW-PROJECT-NUM TO NUMBER-OF-OCCURS

      *>  END-EVALUATE.

       DISPLAY 'ENTER NEW NICKNAME'


       *>MOVE NEW-ENTRY TO PROJECTINFO(ITERATOR)
       DISPLAY WS-DISPLAY-NAME-TABLE.














           STOP-RUN.








      *> MOVE USER-CHANGES-INPUT TO WS-NUM-OF-PROJECT.


      *>EVALUATE TRUE
      *>WHEN (WS-NUM-OF-PROJECT=WS-PROJECT-NUM).


      *> NEED TO FINISH SEARCH SECTION FIRST SO IT CAN JUST SHOW THAT
      *>SINGLE PROJECT.







       3000-SEARCH-BY-SIZE.
           DISPLAY "PLEASE ENTER A PROJECT SIZE"
           "(FULL DAY+, FULL DAY, HALF DAY, 1-3 HRS)".
           ACCEPT USER-SIZE-INPUT.

       9000-END-PROGRAM.


           CLOSE FILEFORTABLE.
           STOP RUN.
       END PROGRAM YOUR-PROGRAM-NAME.
