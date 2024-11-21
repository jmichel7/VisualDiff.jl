







                                                   TM
                                             DMRpro


                   Users Guide and Reference Manual


                                                    Version 1.10




                                   Environmental Software Systems, Inc.





        Information in this document is subject to change without notice and does not represent a commitment on the
        part of Environmental Software Systems, Inc. The software described in this document is furnished under a
        license agreement or nondisclosure agreement. The software may be used or copied only in accordance with the
        terms of the agreement. It is against the law to copy the software on any medium except as specifically
        allowed in the license or nondisclosure agreement. No part of this manual may be reproduced or transmitted
        in any form or by any means, electronic or mechanical, including photocopying and recording, for any purpose
        without the express written permission of Environmental Software Systems, Inc.

                       (c) Copyright Environmental Software Systems, Inc., 1990.
                                  All rights reserved.






        DMRpro is a trademark of Environmental Software Systems, Inc.

        BTRIEVE is a registered trademark of Novell, Inc.

        DESQview and QEMM-386 are trademarks of Quarterdeck Office Systems.

        FX-100 is a trademark and EPSON is a registered trademark of Epson America, Inc.

        IBM is a registered trademark of International Business Machines Corporation.

        LOTUS is a registered trademark of Lotus Development Corporation.

        Windows is a trademark and MS-DOS is a registered trademark of Microsoft Corporation.


        DMRpro Users Guide and Reference Manual


        Contents

        Introduction..............................................1

        Customer Support..........................................2

        Chapter  1  Getting Started...............................3

           1.1  Basic System Requirements.........................3

              1.1.1  RAM MEMORY...................................3

              1.1.2  CONFIG.SYS...................................3

              1.1.3  AUTOEXEC.BAT.................................4

              1.1.4  Disk Space Requirements......................4

           1.2  Backing Up the Distribution Disk(s)...............5

           1.3  The README.TXT File...............................5

           1.4  Disk Contents.....................................5

           1.5  Preparing Your Hard Disk Directories..............6

           1.6  Installing the DMRpro System Files................7

        Chapter  2  Installing System Parameters..................9

           2.1  About the DMRINST Program.........................9

              2.1.1  DMRINST.EXE..................................9

           2.2  About BTRIEVE.....................................9

              2.2.1  BTRIEVE.EXE..................................10

              2.2.2  DMR.BAT......................................10

              2.2.3  BSTOP.EXE....................................10

              2.2.4  PRE-IMAGE DATA Files.........................10

              2.2.5  BTRIEVE PARAMETERS...........................11

        Chapter  3  Using DMRpro..................................13

           3.1  Starting DMRpro...................................13

           3.2  The Introduction Screen...........................13

           3.3  Working With the MENUS............................15



                                                                      iii


        DMRpro Users Guide and Reference Manual


           3.4  Common Key Functions..............................16

           3.5  Using the Help Screens............................18

        Chapter  4  Customizing DMRpro............................19

           4.1  Single or Multiple Company Application............19

           4.2  Company Master Screen.............................19

              4.2.1  Your Company Number..........................19

              4.2.2  Your Company Name............................20

              4.2.3  The DATA Path................................20

              4.2.4  Printer Defaults.............................20

              4.2.5  Printer SETUP Strings........................21

           4.3  Initializing Your DATA Files......................23

           4.4  Changing the Screen Colors........................24

        Chapter  5  Establishing Your DATA Base...................27

           5.1  Customer Master Screen............................27

           5.2  Customer Discharge Screen.........................30

           5.3  Customer Parameter Screen.........................33

              5.3.1  PARAMETER KEYS...............................34

              5.3.2  QUANTITY OR LOADING..........................36

              5.3.3  QUALITY OR CONCENTRATION.....................38

              5.3.4  SAMPLE DATA..................................39

              5.3.5  LINKAGE DATA.................................41

           5.4  STORET Table Screen...............................42

           5.5  Resetting Discharge Comments......................44

           5.6  Resetting The Test Results File...................45

           5.7  Data Entry Error Messages.........................46

        Chapter  6  Entering Test Results Data....................47

           6.1  Decimal Precision.................................47



        iv


        DMRpro Users Guide and Reference Manual


           6.2  Special Symbols...................................47

           6.3  Test Results Screen...............................48

        Chapter  7  Producing File Listings.......................51

           7.1  Common Listing Parameters.........................51

           7.2  Company Master Listing............................53

           7.3  Customer Master Listing...........................53

           7.4  Customer Mailing Labels...........................54

           7.5  Customer Discharge Listing........................55

           7.6  Customer Parameter Listing........................55

           7.7  Test Results Listing..............................56

        Chapter  8  Producing the EPA Reports.....................57

           8.1  Program Limits....................................57

           8.2  Temporary Work Files..............................57

           8.3  Common Report Parameters..........................57

           8.4  The EPA Edit Report...............................60

           8.5  The EPA Worksheet Report..........................60

           8.6  The EPA 3320 Report Form..........................60

        Chapter  9  The DOS Shell.................................61

        Chapter 10  Multi-User Applications.......................63

          10.1  DOS Networks......................................63

          10.2  Multi-Tasking Environments........................64

        Chapter 11  Miscellaneous...................................65

          11.1  Making Backups....................................65

          11.2  Ordering Forms....................................65

        Appendix (A) Sample Reports................................67

        Index.....................................................77





                                                                        v


        DMRpro Users Guide and Reference Manual


        Figures

        Figure 1.1    Disk Space Requirements Table...............4
        Figure 3.2    Introduction Screen.........................13
        Figure 3.3.1  MAIN Menu Screen............................15
        Figure 3.3.2  SUB Menu Screen.............................15
        Figure 3.5    HELP Screen Example.........................18
        Figure 4.2    Company Master Screen.......................19
        Figure 4.3    File Initializations Screen.................23
        Figure 4.4    Customized Colors Screen....................24
        Figure 5.1    Customer Master Screen......................27
        Figure 5.2    Customer Discharge Screen...................30
        Figure 5.3    Customer Parameter Screen I.................34
        Figure 5.3.3  Customer Parameter Screen II................39
        Figure 5.4    STORET Table Screen.........................42
        Figure 5.5    Reset Discharge Comments Screen.............44
        Figure 6.3    Test Results Screen.........................48
        Figure 7.2    Company Listing Screen......................53
        Figure 7.3    Customer Listing Screen.....................53
        Figure 7.4    Customer Mailing Labels Screen..............54
        Figure 7.5    Discharge Listing Screen....................55
        Figure 7.6    Parameter Listing Screen....................56
        Figure 7.7    Test Results Listing Screen.................56
        Figure 8.3    EPA Worksheet Screen........................58


        Appendix (A) Sample Reports

        A.1   Company Master Listing..............................67
        A.2   Customer Master Listing.............................68
        A.3   Customer Mailing Labels.............................69
        A.4   Customer Discharges Listing.........................70
        A.5   Customer Parameters Listing.........................71
        A.6   STORET Table Listing................................72
        A.7   Test Results Data Listing...........................73
        A.8   EPA Edit Report.....................................74
        A.9   EPA 3320 Worksheet Report...........................75
        A.10  EPA 3320 Forms Report...............................76


















        vi


        DMRpro Users Guide and Reference Manual


























































                                                                        v


                                                              Introduction


        Introduction

             The DMRpro System was designed to provide an alternative to
        the time consuming and error prone manual method of preparing
        your NPDES DMR reports. It utilizes state of the art computer
        software technology to deliver fast, accurate, COMPLETED reports
        at an affordable price.

             All critical data entered into the System is first validated
        against tables and formats developed from reproductions of the
        tables used by the EPA's own computerized tracking system - PCS
        (Permit Compliance System).

             The STORET Parameter Table supplied with DMRpro contains
        more than 1800 EPA Test Parameter Descriptions, coded and format-
        ted as they appear on the EPA 3320 Pre-Print Forms.

             Context sensitive online HELP is available at the press of a
        key from any of the menus, fields or prompts.

             The number of Companies, Customers, Discharges, Parameters,
        and Test Results which can be maintained by the DMRpro System are
        limited only by the size of your disk system, or 4 billion bytes
        per file, which ever is the smaller.

             Individual Reporting Parameters can have up to 9000 associ-
        ated Test Results included in the calculations.

             Calculations to be performed are automatically selected by
        using the Statistical Base Codes provided by the EPA and shown on
        your EPA 3320 Pre-Print Forms.

             Those calculations performed include Arithmetic and Geomet-
        ric Means (averages), Minimums, Maximums, Medians, nTH Percen-
        tiles, and Totals. 7 Day Averages can be calculated continuously,
        or by using weekly distribution, starting the first day of the
        month, or starting with any day of the week.

             Percent Removals, Minimum Percent Removals, and Conversions
        from concentration amounts in MG/L to quantity amounts in LBS/DAY
        are also handled automatically.

             The DMRpro System only requires 460K RAM memory to run, and
        has been tested with some of the more popular "TSR" (terminate
        and stay resident) programs running in the background.

             A separate license agreement for running the DMRpro System
        on a DOS Network is available if you require that more than one
        person have access to the System at the same time.







                                                                        1


        DMRpro Users Guide and Reference Manual


        Customer Support

             If you need technical assistance with this product our
        Customer Support staff is available at 1-800-338-2815 from 8:00
        AM to 5:00 PM Central Time.

             You may also request assistance by sending us a FAX at
        1-615-370-4339, 24 hours a day, or write to:

                                Customer Support
                           Resource Consultants, Inc.
                                 P. O. Box 1848
                              Brentwood, TN  37024

             Please have the following information at hand before calling
        Customer Support, and include them with any FAX or written commu-
        nications.

        Product Name and Version Number

        Product Serial Number

        Computer Make and Model

        MS-DOS Supplier and Version Number

        Names of any other Memory Resident Programs (TSR's) in use

        A description of the problem



























        2


                                                              Introduction


























































                                                                        3


        DMRpro Users Guide and Reference Manual


        1.1  Basic System Requirements

        The basic hardware requirements for the DMRpro System are as fol-
        lows:

        One hard disk drive
        One 360K 5.25", or one 720K 3.5" floppy disk drive
        DOS level 3.10 - 4.01
        IBM MDPA, CGA, EGA, VGA or compatible display adapter
        One Wide Carriage Impact Printer
             This is only necessary if you wish to print the EPA-3320
             forms. They may also be filled out by hand using the Work-
             sheet Report Option.


        1.1.1  RAM MEMORY

             The DMRpro System requires approximately 460K available RAM
        memory. It may be necessary for you to unload some your TSR pro-
        grams to obtain the required memory.

             Before running DMRpro you may also find it necessary to
        adjust some of the MS-DOS system parameters set in your
        CONFIG.SYS file. (see your DOS manual for information on how to
        create and/or update these system files.)


        1.1.2  CONFIG.SYS

        FILES=15

             In order to operate efficiently, it is recommended that a
        minimum of 15 DOS file handles be available when using DMRpro.

        BUFFERS=30

             Up to a point, the more buffers that you specify with the
        BUFFERS= parameter, the faster your system will be able to access
        your data files. Setting the BUFFERS= parameter to between 20 and
        30 buffers will usually provide the best performance.

             NOTE: If you are running a disk caching program or have a
        hardware disk cache installed, you will want to refer to that
        vendor's recommendations concerning the use of the BUFFERS=
        parameter.











        4


                                                 Chapter 1  Getting Started


        1.1.3  AUTOEXEC.BAT

             You may want to add the C:\DMR (or user defined) directory
        to any existing PATH= statement in this file. This will allow you
        to start the DMRpro System from any directory instead of having
        to change to the DMR directory before beginning work with DMRpro.
        You should also see the section about the DMRINST.EXE program if
        you plan to use this method of starting DMRpro.

             Also, in order to use the DMRpro DOS Shell menu option, the
        default environment should have a PATH set to your COMMAND.COM
        file. (see your DOS manual for information on how to use the DOS
        PATH command to set the default environment PATH.)

             The DOS Shell menu option requires that at least 19 bytes of
        the DOS Environment Area be available. Additional RAM memory may
        be required to use this option depending on what programs you
        will be executing while in the DOS Shell.


        1.1.4  Disk Space Requirements

             The amount of disk space required for the DMRpro System
        depends on how many Companies are being monitored and the re-
        quirements of each of those Companies. The System Files and a
        minimal set of DATA files should use less than 1MB of disk space.
        The following table should help you in determining the Space
        Requirements for your installation.


                             Disk Space Requirements
                         File Size by Number of Records

        DATA File          1        10       100      1000       10,000
        ---------------------------------------------------------------
        Company        1,536     6,656    53,760   539,136    5,389,824
        Customer       1,536     6,656    54,784   550,400    5,499,392
        Discharge      1,536     6,656    55,808   558,592    5,585,408
        Parameter      1,536     4,096    32,256   320,000    3,200,512
        Test Results   1,536     2,048    13,312   131,584    1,318,912

                   Figure 1.1    Disk Space Requirements Table

        Example 1:

             A small installation monitoring it's own discharges might
        have 25 Discharge Points with 10 Parameters each. If Test Results
        for each Parameter were required daily, and 90 days of Test
        Results were to remain active on the System before being removed,
        the Disk Space Required would be approximately 3.5MB.






                                                                        5


        DMRpro Users Guide and Reference Manual


        Example 2:

             A large consulting operation might monitor discharges for
        100 Customers, each having 25 Discharge Points with 10 Parameters
        each. If Test Results for each Parameter were required daily, and
        90 days of Test Results were to remain active on the System
        before being removed, the Disk Space Required would be more than
        300MB. (The DMRpro System can be modified to allow any DATA File
        to span more than one disk volume if necessary. For more informa-
        tion, call Customer Support.)


        1.2  Backing Up the Distribution Disk

             Before you install the DMRpro System on your hard disk it is
        recommended that you make a backup copy of the Distribution
        Disk(s). (Refer to your DOS manual about how to make a diskette
        backup.)


        1.3  The README.TXT File

             The README.TXT file is an ASCII text file containing infor-
        mation regarding any recent updates to the System which are not
        reflected in the current User's Guide and Reference Manual,
        and/or corrections to it.

             To obtain a hard copy of the README.TXT file you can use the
        DOS "COPY" command:

             >COPY README.TXT PRN

             To view the README.TXT file on your screen you can use any
        ASCII text editor, or the DOS "TYPE" command:

             >TYPE README.TXT


        1.4  Disk Contents

             NOTE: For distribution on 5.25" diskettes, the DMRpro System
        is delivered on two 360K diskettes. For 3.50" diskettes there
        will only be one 720K diskette containing all the files.

        Distribution Disk #1

        README.TXT    This is an ASCII text file containing information
                      about any recent updates to the DMRpro System.

        DMR.BAT       Batch Program to run the DMRpro System. It will
                      automatically load the BTRIEVE Record Management
                      program, start the DMRpro System Program, and then
                      remove the BTRIEVE Record Management program from
                      memory on exiting.


        6


                                                 Chapter 1  Getting Started


        DMRPRO.EXE    DMRpro System Program.

        BSTOP.EXE     Utility Program to remove the BTRIEVE Record Man-
                      agement program from memory.

        DMRINST.EXE   Utility Program to set an internal DATA PATH if you
                      wish to use a separate directory and/or disk drive
                      for your DATA Files.

        DMRCLR.CFG    Color Configuration File containing the DMRpro
                      Screen Colors.


        Distribution Disk # 2 (360K media only)

        DMR.HLP       DMRpro Online Help Screens.

        DMRBTRV.ERR   DMRpro/BTRIEVE Error Messages.

        DMRCO.DAT     Default Company Information DATA file.

        DMRTM.DAT     EPA STORET Codes and their Descriptions.

        BTRIEVE.EXE   BTRIEVE Record Management Program.


        1.5  Preparing Your Hard Disk Directories

             Create a subdirectory called DMR (or whatever you choose)
        off your root directory. This directory will be used to contain
        the DMRpro System Files. Assuming that your hard disk is desig-
        nated as drive C:, use the following DOS commands:

             >C:
             >CD C:\
             >MD DMR

             Instead of creating any DATA directories at this time, you
        should proceed with the next section on Installing the DMRpro
        System Files, and the section on Starting DMRpro.

             Once you have Installed the System Files and know how to
        start the DMRpro System, you can use the Disk Space Requirements
        Table before deciding where and how many DATA directories you may
        need to create.











                                                                        7


        DMRpro Users Guide and Reference Manual


        1.6  Installing the DMRpro System Files

             1. Make the DMRpro System directory the "current" directory:

             >CD DMR

             NOTE: If your diskette drive is designated as B:, substitute
             B: for A: in the following instructions.

             2. Place the Distribution Disk #1 into drive A:.

             3. Copy the DMRpro System Files from Distribution Disk # 1
                to the DMR subdirectory:

             >COPY A:*.*

             4. If you received the System on 5.25" diskettes, repeat
                steps 2 and 3 for Distribution Disk # 2.






































        8


                                                 Chapter 1  Getting Started


























































                                                                        9


        DMRpro Users Guide and Reference Manual


        2.1  About the DMRINST Program

             If you will always be starting the DMRpro System from the
        subdirectory where the DMRpro System Files are located, you can
        skip this section.

             The DMRpro System as delivered expects to find it's control
        files in the same subdirectory from which processing is initiat-
        ed. However, if you wish to be able to start and run the DMRpro
        System from another subdirectory, you can alter this default by
        running the DMRINST.EXE program.

             In addition to running the DMRINST.EXE program you must
        provide the DOS operating system with a method of locating the
        DMR.BAT batch file, the BTRIEVE.EXE Record Management program,
        and the BSTOP.EXE program. While there are several ways to accom-
        plish this, the easiest method is to add the C:\DMR (or user
        defined) directory to the DOS PATH= environment variable. The
        PATH= environment variable is probably already included in your
        existing AUTOEXEC.BAT file. (see your DOS manual for information
        on how to set and or modify this parameter.)


        2.1.1  DMRINST.EXE

             When you run the DMRINST program you will be asked to enter
        the FULL path name for the DMRpro System subdirectory. The pro-
        gram will then locate the DMRPRO.EXE program and install your new
        path as the default path to its control files.

             NOTE: If at some later date you move the DMRpro System Files
        to a different subdirectory, you will have to run the DMRINST
        program again to change the default setting to your new subdirec-
        tory.

             NOTE: Because the DMRINST program modifies the DMRPRO.EXE
        file by inserting your new default path, it could cause some
        virus detection programs to assume that the file has been "con-
        taminated". If this occurs after running the DMRINST program, you
        should consult your virus detection program's manual about how to
        re-install an updated or new version of an application program.


        2.2  About BTRIEVE

             BTRIEVE is a memory resident Record Management System imple-
        mented for MS-DOS based personal computers as a "TSR" (terminate
        and stay resident) program. The DMRpro System uses BTRIEVE data
        files for all its primary files' disk input and output functions.







        10


                                    Chapter 2  Installing System Parameters


        2.2.1  BTRIEVE.EXE

             This is the BTRIEVE program. DOS loads the BTRIEVE program
        into memory and starts its execution. BTRIEVE initializes itself,
        and takes over the DOS 7B interrupt vector. The program then
        terminates but leaves itself in memory, ready for use.


        2.2.2  DMR.BAT

             The DMR.BAT batch command file which is supplied with the
        DMRpro System automates the process of starting the BTRIEVE
        Record Management Program with the proper parameters, running the
        DMRpro System Program, and restoring your system to its previous
        condition when you have finished using DMRpro. While the parame-
        ters supplied for BTRIEVE should be sufficient for most installa-
        tions, they can be changed (within limits) by editing the DMR.BAT
        file using any ASCII text editor.


        2.2.3  BSTOP.EXE

             This program shuts down the BTRIEVE Record Management System
        and removes it from memory. It is run automatically from the
        DMR.BAT batch command file when you have finished working with
        the DMRpro System.

             It can also be executed as a standalone program if the
        DMRpro System "crashes" due to a program problem from which it
        cannot recover. BSTOP will release all BTRIEVE resources for the
        workstation allowing you to restart the DMRpro program.

             NOTE: The DMRpro message "Abnormal Termination" indicates
        that an error condition has been encountered, and that the DMRpro
        System has been able to properly handle the condition. It is NOT
        necessary to run the BSTOP.EXE program for this type of error.


        2.2.4  PRE-IMAGE DATA Files

             BTRIEVE creates a temporary pre-image file for each DATA
        File which it updates. The pre-image file name is the same as
        that of the DATA file being updated but with an extension of
        "PRE". For example, the pre-image file for the Customer Master
        File (DMRCM.DAT) would be "DMRCM.PRE".

             If processing is interrupted, BTRIEVE uses this pre-image
        file to automatically restore the damaged file. You should NOT
        delete these files. They will be deleted automatically after the
        damaged file has been restored.

             NOTE: This does not eliminate the need to maintain timely
        and frequent back up files. Disk damage can occur regardless of
        how many safeguards are built into a software product.


                                                                        11


        DMRpro Users Guide and Reference Manual


        2.2.5  BTRIEVE PARAMETERS

             BTRIEVE with the parameters and values supplied will use
        approximately 57K RAM memory. This is included in the 460K DMRpro
        memory requirements. Should you change the default parameters
        and/or values, your memory requirements may be more, or less,
        than the specified 460K.

        /M:21

             Sets the number of kilobyte (K) units to use for the BTRIEVE
        cache buffers. Valid entries may be from 14K to 64K inclusive.

        /P:1024

             Sets the maximum page size in bytes to be used for the
        BTRIEVE page buffers. Valid entries must be in even multiples of
        512 bytes, and not more than 4096 bytes. For the DMRpro System
        the minimum page size must be at least 1024 bytes.

        /B:2

             Sets the total memory in kilobyte units (K) to be used for
        the pre-image buffers.

        /E:

             Sets the expanded memory option OFF. This means that BTRIEVE
        will NOT use expanded memory for its data buffers.

             SPECIAL NOTE TO BTRIEVE USERS: If you already have the
        Novell BTRIEVE product (DOS Network version 5.10 or later) in-
        stalled on your system, you should insure that the parameters
        which are used to start BTRIEVE are at least as large as the pre-
        defined parameters contained in the DMR.BAT batch file.





















        12


                                    Chapter 2  Installing System Parameters


























































                                                                        13


                                                 Chapter 3  Using DMRpro


        3.1  Starting DMRpro

             Make the DMR subdirectory the "current" subdirectory:

             >C:
             >CD C:\
             >CD DMR

             Start the DMRpro System by typing "DMR" followed by at least
        one space, and the Default Company Number of 0 (zero). After your
        System has been installed and initialized, the Company Number
        which you use will determine which Company's DATA will be ac-
        cessed. If you do not enter the Company Number on the Command
        Line, the program will prompt you for one:

             >DMR 0

             -or-

             >DMR
             >Enter Active Company? 9999
             >0

             NOTE: If you have a problem reading the display (as with
        some LCD displays), you can tell the DMRpro System to use BLACK &
        WHITE display colors by using a "B" parameter on the DOS command
        line when starting DMRpro.

             >DMR 0 B

        3.2  The Introduction Screen

             The Introduction or Sign On Screen displays information
        about your version of the DMRpro System.



















                        Figure 3.2    Introduction Screen


                                                                        15


        DMRpro Users Guide and Reference Manual



             The Active Company Number and Company Name are based on the
        Company Number used to start the System.

             The DMRpro Version Number displayed may be needed by Custom-
        er Support to answer any questions you have about the System.

             The Serial number displayed is registered in your Company's
        name and may be required if you need assistance from Customer
        Support.

             The Copyright and Trademark notices are there to remind you
        and your Company that the DMRpro System is a licensed product
        which can only be used within the limits provided for in the
        formal license agreement.









































        16


                                                 Chapter 3  Using DMRpro


        3.3  Working With the MENUS



















                         Figure 3.3.1  MAIN Menu Screen



















                          Figure 3.3.2  SUB Menu Screen

             You may select a choice from the DMRpro MENU boxes in one of
        two different ways:

             1. You can scroll through the choices by using the UP and
        DOWN arrow keys and then pressing the <ENTER> key when your
        choice is highlighted.

             2. You can also make selections from the MENU boxes by
        entering the highlighted number or letter of the process which
        you want to be performed. This method is particularly useful when
        returning to the MAIN MENU from one of the SUB MENUS, or to DOS
        from the MAIN MENU.


                                                                        17


        DMRpro Users Guide and Reference Manual


        3.4  Common Key Functions

             Once you have started the DMRpro System and are ready to
        enter data, you will use the following editing keys to enter and
        change individual data fields.

             Most KEY fields such as Customer Number, Discharge Number,
        etc., allow either the direct entry of the number (leading zeros
        are added automatically if necessary), or a SEARCH key to find
        existing data. Valid SEARCH keys are shown on the HELP screen
        associated with a particular field as below:

             --------------------- Search Mode ---------------------
             'F' = Find (F)irst Match    'N' = Find (N)ext Match
             'L' = Find (L)ast Match     'P' = Find (P)revious Match

             Entering either 'e' or 'E' in the first field on a screen
        will end that program function and return you to the MENU or SUB-
        MENU where you started.

        BLANK FIELDS

             If you want a field to be blank, DO NOT enter blanks or
        spaces into the field. Instead, just press the <ENTER> key.
        Should you inadvertently enter spaces into a field which is being
        edited for either a valid entry or a NULL field, it will not be
        accepted and you will here a BEEP after pressing the <ENTER> key,
        signaling an error. To CLEAR the field, press <CTRL-Y> and then
        press <ENTER>.

             All fields which allow entry of text (as opposed to numeric
        only) will accept both upper and lower case characters.

             Fields which only require a one character response are, in
        most cases, ENTERed for you automatically. (You do not need to
        press the <ENTER> key).

             The following keys are common to most DMRpro screens and can
        be used to move from one field to another, pop-up the online HELP
        information, and to enter and/or edit information in a field.

        ESC           Entering <ESC> will, in most circumstances, CANCEL
                      any Data which has been entered and return you to
                      the first field on the current screen. From there
                      you can either continue data entry, or exit to the
                      MENU by entering 'E'.

             For Data Entry Fields

             The <ESC> key cancels the current operation and positions
        the cursor at the preceding level of operation. For a data entry
        screen this will normally be the first DATA Field on the screen.




        18


                                                 Chapter 3  Using DMRpro


             For System Prompts

             For system prompts that display several levels of questions,
        each requiring a response, the <ESC> key cancels the current
        question and redisplays the previous question. You may repeat
        this process as many times as necessary to ESCape out of a series
        of questions.

        F1            Displays the online HELP information for the field
                      in which the cursor is located.

        F2            Toggles between one Data component of a Display
                      Screen to another. (Only available on the Customer
                      Parameter Screen)

        INSERT        Toggles between Insert/Overstrike Mode. (default =
                      Overstrike).

        RIGHT ARROW   Moves the cursor one character position to the
                      right.

        LEFT ARROW    Moves the cursor one character position to the
                      left.

        HOME          Moves the cursor to the beginning of the current
                      field.

        END           Moves the cursor to the end of the current field.

        BACKSPACE     Deletes the character to the left of the current
                      cursor position.

        DEL           Deletes the character at the current cursor posi-
                      tion.

        CTRL-Y        Clears the current data field and places the cursor
                      at the beginning of the field.

        ENTER         Accepts the data entered or edited as being com-
                      plete and proceeds to the next data field.

        TAB           Performs the same function as the <ENTER> key.

        DOWN ARROW    Performs the same function as the <ENTER> key.

        SHIFT-TAB     Moves backward to the beginning of the previous
                      data field.

        UP ARROW      Performs the same function as the <SHIFT-TAB> key
                      combination.






                                                                        19


        DMRpro Users Guide and Reference Manual


        3.5  Using the Help Screens



















                        Figure 3.5    HELP Screen Example

             Once you have selected a process from the DMRpro Menu each
        DATA field has an online HELP screen associated with it, as do
        most of the System Prompts (i.e. question and answer dialogues).
        In fact, most of the information contained in this manual, as it
        relates to DATA, is built into the online HELP.

             Pressing the F1 key will "pop-up" information pertaining to
        the current DATA field in a separate "Window" on your screen. If
        there is more information than will fit into the "Window", you
        can use the PgUp and PgDn keys to browse UP and DOWN through the
        HELP information.

             When you have finished with the HELP screen, press the ESC
        key and you will be returned to where you were before.




















        20


                                                 Chapter 3  Using DMRpro


























































                                                                        21


                                           Chapter 4  Customizing DMRpro


        4.1  Single or Multiple Company Application

             DMRpro provides the option of maintaining and reporting data
        for more than one Company. If your business involves producing
        EPA reports for more than one Company, each having it's own set
        of clients (Customers), you may wish to implement this option.

             NOTE: This feature can also be useful if your Company oper-
        ates separate branch offices or does consulting work for several
        clients and you wish to maintain a separate Customer base for
        each branch or client.


        4.2  Company Master Screen



















                       Figure 4.2    Company Master Screen


        4.2.1  Your Company Number

             DMRpro comes with a pre-defined Company File with the de-
        fault Company Number of "0" (zero). If you will only be operating
        the System for one Company you will probably want to use this as
        YOUR Company Number.

             If you are implementing the Multi-Company option of DMRpro,
        you can enter a different Company Number for each Company which
        you wish to maintain.

             Each Company Record that you create by entering a new Compa-
        ny Number will be initialized with default data values and main-
        tained separately.






                                                                        19


        DMRpro Users Guide and Reference Manual


             Each time that you start the DMRpro System you are required
        to enter an Active Company Number. The information maintained in
        the Company Record for that Company Number will be in effect for
        the entire session.


        4.2.2  Your Company Name

             The Name of the Company should be entered here. The Company
        Name will be printed with the headings of all reports generated
        while using the corresponding Company Number as the Active Compa-
        ny. The Active Company is established when the DMRpro System is
        started.


        4.2.3  The DATA Path

             DMRpro is supplied without a specific DATA path installed.
        This prompts the DMRpro software to use and display the current
        directory as the DATA path. For Single Company implementations
        you can use this default DATA path, provided that you always use
        one of the following:

              1. You start the DMRpro System from the same directory in
        which the DMRpro System Software is located, and you want your
        DATA Files kept in this same directory.

              2. You use the DMRINST program to install the PATH for the
        System Files, and you start the DMRpro System from the directory
        where your DATA Files are located.

             If you enter a DATA path, it should consist of the entire
        DOS path specification to the directory where your DATA Files are
        located.

             For Multi-Company implementations, you should ALWAYS enter
        the DATA path to the directory where that particular Company's
        DATA Files are located.


        4.2.4  Printer Defaults

        Default Printer

        Format: 1 character (1 = LPT1:, 2 = LPT2:)

             The Default Printer will be the device used for all reports
        directed to the printer rather than to a disk file.








        20


                                           Chapter 4  Customizing DMRpro


        Default Print Mode

        Format: 1 character

             1 = Normal 10 characters/inch 15 7/8" x 11" computer paper
             2 = Condensed 17 characters/inch 8 1/2" x 11" computer paper

             The Default Print Mode will be used when printing all re-
        ports except for the Customer Mailing Labels and the EPA-3320
        Forms. Both of these functions will use Normal 10 cpi print mode
        regardless of the Default Print Mode setting.

        Left Print Margin

        Format: 1 character (0-9)

             The Left Print Margin sets the number of spaces that all
        lines printed will be shifted to the right. This can be helpful
        if you use forms which have different carrier widths or varying
        left margins.

             NOTE: Using a Left Print Margin greater than 4 with Normal
        Print Mode can cause what appears to be double spaced printing on
        some printers. This is called a "Buffer-full print", and occurs
        when the hardware print buffer becomes full. The problem can be
        corrected by using a smaller value for the Left Print Margin and
        adjusting the left print position on the printer, or by using
        Condensed Print Mode.


        4.2.5  Printer SETUP Strings

             You should refer to the printer manual that came with your
        printer to determine the proper command sequences to enter for
        the Printer SETUP Strings.

             NOTE: Entering the '\' (backslash) character in a Printer
        SETUP String implies that the next 3 characters are numeric
        digits of a non-printable control code. They will be translated
        into a 1 character command code to be sent to the printer or disk
        file. (These are sometimes called "LOTUS style" SETUP strings.)

        Initialize Printer

        Format: 32 characters (EPSON FX-series supplied)

             The setup string to Initialize Printer may vary from one
        manufacturer to another. Enter the proper command sequence here
        for your printer.







                                                                        21


        DMRpro Users Guide and Reference Manual


        Set Condensed Print Mode

        Format: 32 characters (EPSON FX-series supplied)

             Condensed print mode is usually 17.5 characters per inch.
        This will allow a standard 132 column printout to be printed on
        letter size paper.

             The setup string to Set Condensed Print Mode may vary from
        one manufacturer to another. Enter the proper command sequence
        here for your printer.

        Cancel Condensed Print Mode

        Format: 32 characters (EPSON FX-series supplied)

             The setup string to Cancel Condensed Print Mode may vary
        from one manufacturer to another. Enter the proper command se-
        quence here for your printer.

             NOTE: When Condensed Print Mode is canceled, the DMRpro
        System assumes that Normal Print Mode is the mode being returned
        to. Normal Print Mode is usually 10 characters per inch. If you
        printer does not start in Normal Print Mode when initialized, you
        may have to change the logical meaning of the "Cancel Condensed
        Print Mode" to "Set Normal Print Mode" and enter the appropriate
        command sequence.





























        22


                                           Chapter 4  Customizing DMRpro


        4.3  Initializing Your DATA Files



















                    Figure 4.3    File Initializations Screen

             The Company Number entered here must already have been
        created with the Company Setup/Defaults option of the Setup MENU.
        This should be the Company for which you wish to create new DATA
        Files.

             The DATA Path is displayed for verification purposes only
        and cannot be changed from this Screen. It should be the same as
        that for the Company Number being initialized.

             Files which already exist on the given DATA Path cannot be
        initialized and will generate a warning message.























                                                                        23


        DMRpro Users Guide and Reference Manual


        4.4  Changing the Screen Colors



















                     Figure 4.4    Set System Colors Screen

             If you have a CGA, EGA or VGA display adapter and are using
        a color monitor you can customize the DMRpro Screen Colors to any
        of eight background colors (0 - 7) and any of sixteen foreground
        colors (0 - 15).

             NOTE: After changing the screen colors for some Items you
        will have to exit from the DMRpro System and re-start it to see
        the changes reflected in the active System. This is due to the
        fact that the DMRpro System saves various screens to memory when
        they are not currently active, and then restores them from memory
        once they become active again.

             Setting Screen Colors is not available for all display
        adapter/monitor combinations. You will receive a message to this
        effect if DMRpro cannot handle changing the screen colors for
        your particular system.

             The DMRpro System will check your colors prior to saving
        them, and if you have set equal background and foreground colors
        for the same Screen Item, the entire set of customized colors
        will NOT be saved.

             The Screen Display used for the customization of your Screen
        Colors is not an actual DMRpro Screen. Some of the window sizes
        have been reduced and you cannot use the MENU Screen or HELP
        Screen interactively. It does however reflect the actual colors
        which will be used.







        24


                                           Chapter 4  Customizing DMRpro


             To change the colors in the supplied default color configu-
        ration file, the following control keys are available:

              1. The UP and DOWN Arrow keys allow you to change from one
        Screen Item to the next or previous Screen Item. A brief descrip-
        tion of which part of the screen each Screen Item controls is
        displayed along with that Screen Item's color number.

              2. The LEFT and RIGHT Arrow Keys allow you to change the
        color of the selected Screen Item from color 0 to 7 for back-
        ground Items, and from 0 to 15 for foreground Items.

              3. At the color selection level two special keys may be
        used. The "/" (slash) key can be used to restore that Item's
        color to the original color as delivered, and the "*" (asterisk)
        can be used to reset that Item's color to the color that was used
        with the last SAVE operation.

              4. The "e" key is used to exit the Item level of color
        changes after you are sure that the colors shown are those that
        you want to use.

             NOTE: The "/" (slash) and "*" (asterisk) keys may also be
        used after entering "e" to exit, and before SAVING the Screen
        Colors to either restore or reset ALL colors to their delivered
        original state or to their state after the last SAVE operation.






























                                                                        25


        DMRpro Users Guide and Reference Manual


























































        26


                                           Chapter 4  Customizing DMRpro


























































                                                                        27


                                    Chapter 5  Establishing Your DATA Base


        5.1  Customer Master Screen



















                      Figure 5.1    Customer Master Screen

        Customer

        Format: 9 characters (0-9) or Search Mode

        Mode

        Format: 1 character (A, M, D)

             The Mode field is set automatically to either "A" for Add,
        or "M" for Maintenance depending on whether the Customer Record
        for the Customer Number entered or searched for already exists.

             If the Customer Record does exist, you can change the Mode
        from "M" to "D" to delete that Customer Record. If you try to
        delete a Customer Record for which there are still Discharge
        Points or Parameters, the DMRpro System will issue a message to
        that effect and will NOT delete the Customer Record.

        Type

        Format: 1 character (C,W,O)

             C = Coal Mine
             W = Water or Waste Water Treatment facility
             O = Other

             The Customer Type allows you to sub-divide your customers
        into one of several groups for reporting purposes. At the present
        time all Customer Types are treated identically, except for
        report selection.




                                                                        27


        DMRpro Users Guide and Reference Manual


        Report Code

        Format: 1 character (A,M,Q,S)

             'A' = Annual
             'M' = Monthly
             'Q' = Quarterly
             'S' = Semi-Annual

             The Report Code allows for further sub-division of Customers
        into groups according to their reporting frequency.

        NPDES Permit

        Format: 13 characters

             This is your National Pollutant Discharge Elimination System
        (NPDES) Permit Number. The first two characters of this should be
        your two character state abbreviation. The DMRpro System uses
        these two characters to determine any special editing which may
        be state specific.

        DSMRE Permit

        Format: 13 characters

             This is a special Permit Number for the Department of Sur-
        face Mining and Reclamation (DSMRE) which is used in some states.

        Name

        Format: 34 characters

             This is the Name which will be printed on the NAME line at
        the top of the EPA-3320 form for each Customer.

        Address 1

        Format: 25 characters

             The first address line (Address 1) should be used for the
        Street or Delivery Address. This address line WILL NOT be printed
        on the Mailing Labels UNLESS there is no second address line.

        Address 2

        Format: 25 characters

             The second address line (Address 2) should be used for the
        Mailing Address or P. O. Box if different from the Street Ad-
        dress. This address line WILL be printed on the Mailing Labels
        when present.




        28


                                    Chapter 5  Establishing Your DATA Base


        City

        Format: 26 characters

        State

        Format: 2 characters (A-Z, blank)

             Use the two character state abbreviation for the Customer's
        Mailing Address. This does not have to be the same state as the
        one used as part of the Permit Number. Permits can be issued for
        out of state facilities which have discharges within the issuing
        state.

        Zip

        Format: 10 characters

             The Customer Zip Code may be entered in either the 5 digit
        zip, or 9 digit zip+4 format.

             EXAMPLES: 12345  12345-1234

        Facility

        Format: 34 characters

        Location

        Format: 34 characters

        Attention

        Format: 34 characters

             The Attention Line will be printed on the EPA-3320 form
        beneath the Location line. If the state has authorized an agent
        other than the Executive Officer to manage the reporting for that
        Customer, their name should be used here.

             Example: JOHN DOE/ENGINEER

        Executive

        Format: 24 characters x 3 lines

             This should be the name of the person who will sign the
        completed EPA-3320 forms.

             Example: JOHN DOE/ENGINEER






                                                                        29


        DMRpro Users Guide and Reference Manual


        Phone

        Format: NNN-NNN-NNNN (12 characters)

             The Customer Phone Number should be entered in the format
        shown above (i.e. with dashes included).


        5.2  Customer Discharge Screen



















                     Figure 5.2    Customer Discharge Screen

        Customer

        Format: 9 characters (0-9) or Search Mode

             The Customer Name is displayed immediately to the right of
        the Customer Number for sight verification.

        Discharge

        Format: 3 characters (0-9) or Search Mode

             This is the Discharge Number for the Customer Number above.
        It is sometimes referred to as the "Discharge Point" or "Outfall
        Number". The Discharge Location is displayed on the line below
        for sight verification.











        30


                                    Chapter 5  Establishing Your DATA Base


        Mode

        Format: 1 character (A, M, D)

             The Mode field is set automatically to either "A" for Add,
        or "M" for Maintenance depending on whether the Discharge Record
        for the Customer Number entered or searched for already exists.

             If the Discharge Record does exist, you can change the Mode
        from "M" to "D" to delete that Discharge Record. If you try to
        delete a Discharge Record for which there are still Parameter
        Records, the DMRpro System will issue a message to that effect
        and will NOT delete the Discharge Record.

        Location Description

        Format: 34 characters

             The Location Description is not an EPA designated field. It
        will be printed on the internal DMRpro reports, but does NOT
        print on the EPA 3320 Report. It is provided to allow easy recog-
        nition of each Discharge Point.

        Reclaim #

        Format: 10 characters x 4 lines

             DMRpro provides the ability to enter and print up to four
        "Reclaim" numbers. These are usually DSMRE Mining Permit Numbers
        which are used in some states. If present, they are printed at
        the bottom of the EPA 3320 Report in the Comments section.

        Latitude and Longitude

             The Latitude and Longitude fields are also only used in some
        states (primarily for Surface Mines). If entered, they are edited
        as follows:

        Latitude      Format: 1 character  (N,S)
          Degrees     Format: 2 characters (0-90)
        Longitude     Format: 1 character  (E,W)
          Degrees     Format: 3 characters (0-180)
        Minutes       Format: 2 characters (0-59)
        Seconds       Format: 2 characters (0-59)

             If present, these fields print at the bottom of the EPA 3320
        Report in the Comments section to the right of the Comment Lines.









                                                                        31


        DMRpro Users Guide and Reference Manual


        DRID

        Format: 1 character (non-blank)

             The DRID (Discharge ID or Report Designator) is required by
        the EPA. The DRID is printed immediately to the right of the
        Discharge Number on the EPA 3320 Report.

             There are presently no characteristics given to this field
        by the EPA and therefore no editing is performed other than to
        insure that it is not blank.

        LTYP

        Format: 1 character (I, M, F)

             'I' = Initial Limits
             'M' = Interim Limits
             'F' = Final Limits

             The Limit Type and its description is printed on the EPA
        3320 Report in the upper right hand corner.

        RTYP

        Format: 1 character (N, W, E, R, blank)

             'N' = New source
             'W' = Water Quality Limited
             'E' = Existing Source, New Discharger
             'R' = Reclamation Area

             The Reporting Type is included for future use by Coal Mines.
        It presently is NOT printed on the EPA 3320 Report.

        COMMENTS Duration

        Format: 1 character (P, A, S, Q, M, blank)

             The Comment Duration Code is used to determine which Dis-
        charge Points will have the Comments cleared during the Reset
        Discharge Comments batch processing function. The Comments are
        cleared cumulatively depending on the contents of this field and
        the Duration Code selected in the Reset Discharge Comments func-
        tion. (i.e. when Annual Comments are cleared, the Semi-Annual,
        Quarterly, and Monthly Comments are also cleared.)

             'P' = Permanent Comment
             'A' = Annual
             'S' = Semi-Annual
             'Q' = Quarterly
             'M' = Monthly




        32


                                    Chapter 5  Establishing Your DATA Base


        COMMENTS

        Format: 72 characters x 3 lines

             The 1-3 COMMENT Lines, if entered, will be printed as en-
        tered on the EPA-3320 report in the COMMENTS section. Lines 1 and
        2 will automatically wrap to the next Line when they are com-
        pletely filled. Line 3 requires that you press the <ENTER> key to
        continue.


        5.3  Customer Parameter Screen

             Entering a Customer Parameter Record is probably the most
        complicated task in the DMRpro System. However, you should only
        have to do it once, unless changes in your Permit require it.

             NOTE: After entering your Customer Parameters it is recom-
        mended that you perform some testing and verification of the
        DMRpro System's Reported Results using minimal Test Results data.
        This will insure that your Parameters have been properly entered,
        and the calculation methods selected produce the expected Report
        Results.

        Use of the <F2> key

             You may notice that the Customer Parameter Screen is pic-
        tured in the manual twice. Looking carefully at the bottom of the
        two screens will show that the "QUALITY OR CONCENTRATION" portion
        of the Parameter DATA shown on the first screen has been replaced
        by the "SAMPLE & LINKAGE DATA" on the second screen, and that the
        DATA above these remains the same.

             After you have entered or searched for a STORET Code you can
        use the <F2> key to toggle back and forth between the two sepa-
        rate DATA displays. Also, just pressing the <ENTER> key at the
        end of the first screen will automatically toggle to the second
        screen.

             NOTE: If you are in the process of entering DATA into either
        section, using the <F2> key is equivalent to pressing the <ENTER)
        key for the current field and all remaining fields within that
        section.













                                                                        33


        DMRpro Users Guide and Reference Manual




















                    Figure 5.3    Customer Parameter Screen I

        5.3.1  PARAMETER KEYS

        Customer

        Format: 9 characters (0-9) or Search Mode

             The Customer Name is displayed immediately to the right of
        the Customer Number for sight verification.

        Discharge

        Format: 3 characters (0-9) or Search Mode

             This is the Discharge Number for the Customer Number above.
        It is sometimes referred to as the "Discharge Point" or "Outfall
        Number". The Discharge Location is displayed immediately to the
        right of the Discharge Number for sight verification.

        STORET

        Format: 5 characters or Search Mode

             The STORET Code is the EPA designated Code for a given
        Parameter, i.e. a specific laboratory test. If numeric, the
        STORET Code will be right justified and zero filled automatical-
        ly. The 2 line STORET Description and the STORET Code are also
        displayed in a block (the Parameter Description Block) on the
        right side of the screen in the same format that will be used on
        the EPA 3320 Report.







        34


                                    Chapter 5  Establishing Your DATA Base


        MLOC

        Format: 1 character (1-9, A-Z)

             The Monitoring Location Code is designated by the EPA. You
        will find it printed immediately to the right of the STORET
        Parameter Code on your EPA 3320 Pre-Print Forms. The MLOC and
        MLOC Description are also displayed in the Parameter Description
        Block for sight verification.

             NOTE: The Search Function associated with most key fields is
        not available for the Monitoring Location Code.

        Mode

        Format: 1 character (A, M, D)

             The Mode field is set automatically to either "A" for Add,
        or "M" for Maintenance depending on whether the Parameter Record
        for the Customer, Discharge, STORET, and MLOC Numbers or Codes
        entered or searched for already exists.

             If the Parameter Record does exist, you can change the Mode
        from "M" to "D" to delete that Parameter Record.

        SEAN

        Format: 1 character (0, 1, 2, S, W) DEFAULT = 0

             The Season Code is printed on the EPA-3320 report as en-
        tered. You will find it on your EPA 3320 Pre-Print Forms immedi-
        ately to the right of the Monitoring Location Code. It is not
        used in any calculations or program controlled determinations.
        The SEAN is also displayed in the Parameter Description Block for
        sight verification.

             '0' = No Limits
             '1' = All Year Limits
             '2' = General Limits
             'S' = Summer Limits
             'W' = Winter Limits

        MODN

        Format: 1 character (0-9) DEFAULT = 0

             The Modification Number is printed on the EPA-3320 report as
        entered. You will find it on your EPA 3320 Pre-Print Forms imme-
        diately to the right of the Season Code. It is not used in any
        calculations or program controlled determinations. The MODN is
        also displayed in the Parameter Description Block for sight
        verification.




                                                                        35


        DMRpro Users Guide and Reference Manual


        5.3.2  QUANTITY OR LOADING

             NOTE: The EPA Pre-Print Forms use a series of asterisks to
        fill fields for which there are no reporting Requirements. DO NOT
        attempt to enter these into the DMRpro Parameter fields. In most
        cases, they will be rejected by the editing process. Because the
        EPA does not require that these fields be duplicated as shown on
        the EPA Pre-Print Forms, they should be omitted. This allows for
        much easier data entry and faster report printing.

             The "Rqmt" line is where you will enter the EPA established
        Requirement Limits for a given Parameter. These will be the
        requirements that your Test Results will be compared against to
        determine whether an excursion or exception should be reported.

             The "Base" line is where you will enter the EPA Statistical
        Base Code as shown on your EPA 3320 Pre-Print Forms. The Statis-
        tical Base Codes determine what type or types of calculations are
        to be applied to your Test Results.

        "Rqmt" - Average, Maximum

        Format: 8 characters

             Enter the Requirement Limit just as it appears on your EPA
        3320 Pre-Print Form in the "Rqmt" field of the associated Average
        or Maximum Block. This will normally be a numeric value or blank,
        but may occasionally contain the word  "REPORT". This field will
        be edited for validity before being accepted.

             NOTE: Do NOT enter blanks (spaces) if the field is not shown
        on your EPA 3320 Pre-Print Form. Instead, just press the <ENTER>
        key. If blanks are entered, you can clear the field by pressing
        <CTRL-Y> and then pressing <ENTER>.

        "Base" - Average, Maximum

        Format: 8 characters

             Enter the Statistical Base Code EXACTLY as it appears on
        your EPA 3320 Pre-Print Form in the "Base" field of the associat-
        ed Average or Maximum Block. This normally will be a numeric
        value plus an abbreviation for the type of mathematical treatment
        to be used in calculating the Reported Results.

             NOTE: Although upper and lower case letters are treated the
        same, SPACING, SPECIAL SYMBOLS, and POSITION of the data within
        the field are critical. The data entered here is matched against
        tables provided by the EPA and exact matches are required to
        determine the calculation methods to be used in producing your
        Reported Results.

             NOTE: Do NOT enter blanks (spaces) if the field is not shown
        on your EPA 3320 Pre-Print Form. Instead, just press the <ENTER>


        36


                                    Chapter 5  Establishing Your DATA Base


        key. If blanks are entered, you can clear the field by pressing
        <CTRL-Y> and then pressing <ENTER>.

        Samp U/M

        Format: 7 characters x 2 lines

             The "Samp U/M" (Sample Units of Measure) IS NOT shown on
        your EPA 3320 Pre-Print Forms. It is placed on two separate lines
        for both the EPA 3320 Report and for editing against the EPA
        provided Units Table.

             If you wish to use the Units specified in your Permit, you
        do not have to enter them here. If not present, the DMRpro System
        will use the Units entered in the "Rqmt U/M" by default.

             If your SAMPLES were taken in Units different than those
        specified in the Permit Requirements, it is best to convert them
        to the Permit Requirement's Units before you enter the Test
        Results into the System.

             If you must enter the Units, be sure to use the same formats
        for values and abbreviations, and put them on the same "Line" as
        the Units shown on your EPA 3320 Pre-Print Form Requirements
        Line.

        Rqmt U/M

        Format: 7 characters x 2 lines

             The "Rqmt U/M" (Requirement Units of Measure) is shown on
        your EPA 3320 Pre-Print Forms. It is placed on two separate lines
        for both the EPA 3320 Report and for editing against the EPA
        provided Units Table.

             Enter the Units EXACTLY as shown on your EPA 3320 Pre-Print
        Form in the two separate fields for Requirements Units.

             NOTE: Although upper and lower case letters are treated the
        same, SPACING, SPECIAL SYMBOLS, and POSITION of the data within
        the two fields are critical. The data entered here is matched
        against tables provided by the EPA and exact matches are required
        to determine the calculation methods to be used in producing your
        Reported Results.












                                                                        37


        DMRpro Users Guide and Reference Manual


        Calc

        Format: 1 character (N, C, M, 0-6) DEFAULT = C

             The Calculation Codes determine how to calculate 7 day aver-
        ages.

             'N'   = No calculations to be performed.
             'C'   = Continuous
             'M'   = Month Days (1-7, 8-14, 15-21, 22-28)
             '0-6' = Week Days Starting With:

                      '0' = Sunday
                      '1' = Monday
                      '2' = Tuesday
                      '3' = Wednesday
                      '4' = Thursday
                      '5' = Friday
                      '6' = Saturday


        5.3.3  QUALITY OR CONCENTRATION

             The "QUALITY OR CONCENTRATION" specifications are identical
        to those of the "QUANTITY OR LOADING" except for the addition of
        the "Minimum" and "Excp" fields discussed below.

        "Rqmt" - Minimum, Average, Maximum

        "Base" - Minimum, Average, Maximum

             The "Minimum" field, in addition to the "Average" and "Maxi-
        mum" fields, are treated the same as their counterparts in the
        previous section on the "QUANTITY OR LOADING" data.

        Excp

        Format: 1 character (Y, N) DEFAULT = Y

             The Exception Calculations Indicator determines whether or
        not to calculate and print the number of excursions to the Permit
        Specifications. Although the default of "Y" is normally used
        (report excursions), you may disable the reporting of excursions
        by entering an "N".

             This can be helpful if the EPA has granted a waiver for a
        particular Parameter, but you still have Test Results for that
        Parameter. The Reported Results would still be printed, but no
        excursions would be reported.

             NOTE: Disabling excursion reporting will cause the DMRpro
        System to bypass the printing of the excursions for that Parame-
        ter. A "0" (zero) for the excursions will NOT be printed as is
        the normal case when no excursions have occurred.


        38


                                    Chapter 5  Establishing Your DATA Base




















                   Figure 5.3.3  Customer Parameter Screen II

        5.3.4  SAMPLE DATA

             The "SAMPLE & LINKAGE DATA" on Customer Parameter Screen II
        is accessed automatically by completing the entry of DATA for
        Customer Parameter Screen I, or by pressing the <F2> key from
        Customer Parameter Screen I.

        Frequency - Samp (Line 2)

        Format: 7 characters

             The Frequency of Analysis consists of two parts. The first
        part labeled "Samp (Line 2)" does NOT appear on your EPA Pre-
        Print Forms. It is a single line entry for the Frequency used to
        collect your Sample Data.

             This usually consists of two numbers separated by a "/"
        (slash), the first number being the number of days on which
        samples were collected, and the second number being the number of
        days in the sampling period.

             Example: 1/7 = one day per week

             NOTE: The EPA's Permit Compliance System (PCS) will only
        accept certain fixed combinations of days and periods.

             The usual procedure is that Permit holders report their
        ACTUAL Sampling Frequency, and the state EPA offices convert
        these to a Sample Frequency acceptable to the PCS before entering
        the data into the Federal System.

             Other Permit holders report only Sampling Frequencies which
        are already PCS compatible (nearest fit) as instructed by an EPA
        agent.


                                                                        39


        DMRpro Users Guide and Reference Manual



             Because of the inconsistent manner in which this data ele-
        ment is being handled by the different EPA offices, the DMRpro
        System DOES NOT edit this field at all.

        Frequency - Rqmt (Line 1) & (Line 2)

        Format: 7 characters x 2 lines

             These fields are the second part of The Frequency of Analy-
        sis and appear on your EPA Pre-Print Forms on the first and
        second line of the Requirements section. They represent the
        Frequency of Analysis as specified on your Permit.

             They have been placed on two separate lines, as was the case
        for the Units of Measurement, for both the EPA 3320 Report and
        for editing against the EPA provided Frequency Table.

             Enter the Permit Frequency of Analysis EXACTLY as shown on
        your EPA 3320 Pre-Print Form in the two separate fields - Rqmt
        (Line 1) & (Line 2).

             NOTE: Although upper and lower case letters are treated the
        same, SPACING, SPECIAL SYMBOLS, and POSITION of the data within
        the two fields are critical. The data entered here is matched
        against tables provided by the EPA and exact matches are re-
        quired.

        Sample Type - Samp (Line 2)

        Format: 6 characters

             This is the Type of Sampling technique which was used in the
        collection of your Samples. It DOES NOT appear on your EPA Pre-
        Print Form.

             Enter an abbreviation for the Type of Sampling actually
        used, or if you used the same method as that specified on your
        Permit, you may repeat that here. No editing is performed on this
        field as it does not involve any calculations, and abbreviations
        may vary.

        Sample Type - Rqmt (Line 1)

        Format: 6 characters

             This is the Type of Sampling technique specified on your
        Permit. It DOES appear on your EPA 3320 Pre-Print Form, and
        should be found on the second line of the Requirements section.

             Enter the Type of Sampling EXACTLY as shown on your EPA 3320
        Pre-Print Form.

             NOTE: Although upper and lower case letters are treated the


        40


                                    Chapter 5  Establishing Your DATA Base


        same, SPACING, SPECIAL SYMBOLS, and POSITION of the data within
        the two fields are critical. The data entered here is matched
        against tables provided by the EPA and exact matches are re-
        quired.


        5.3.5  LINKAGE DATA

             The LINKAGE DATA section of the Customer Parameter Screen II
        contains fields which are used to "LINK" two Parameters together
        when the Reported Results require Test Results from two different
        Parameters be used in the calculations.

             The EPA 3320 Pre-Print Form DOES SHOW the STORET, Influent
        MLOC, or Effluent MLOC codes for the Parameter that you are
        "LINKING TO", but they probably will NOT BE adjacent to the data
        for the Parameter that is to be reported. The Codes you are
        "LINKING TO" should be appear on the EPA 3320 Pre-Print Form as a
        separate Parameter, and in their own respective sequence. (The
        EPA Parameters are presented in EBCDIC sequence by STORET and
        MLOC.)

             NOTE: It is not necessary to enter ANY Linkage Data for a
        Parameter which does not require any supporting Test Results from
        another Parameter.

        STORET

        Format: 5 characters

             The Linkage STORET Code is used internally by the Report
        programs to locate an additional STORET Code which may be re-
        quired for some calculations.

             1. For PERCENT REMOVAL of BOD and SOLIDS, the STORET Code
        for the corresponding BOD or SOLIDS Parameter MUST be entered.

             2. For the conversion of Concentrations in MG/L to Quantity
        in LBS/DY, the STORET Code for FLOW should be entered if differ-
        ent from both of the default STORET Codes for FLOW.

             DEFAULT = 50050 FLOW, IN CONDUIT OR THRU TREATMENT PLANT
             DEFAULT = 74076 FLOW

             3. If no LINKAGE STORET Code is entered and FLOW is neces-
        sary for calculations, the above series of DEFAULT values will be
        tried for FLOW during Report Processing.

             NOTE: You cannot enter a STORET Linkage Code for both PER-
        CENT REMOVALS and FLOW.






                                                                        41


        DMRpro Users Guide and Reference Manual


        Influent MLOC, Effluent MLOC

        Format: 1 character (1-9, A-Z)

             The Linkage Monitoring Location Code is used internally by
        the Report programs to locate an additional Monitoring Location
        Code which may be required in some calculations.

             1. For PERCENT REMOVAL of BOD and SOLIDS, both the Influent
        and Effluent Monitoring Location Codes for the corresponding
        B.O.D. Parameter should be entered.

             DEFAULT: Influent = G RAW SEW/INFLUENT
             DEFAULT: Effluent = 1 EFFLUENT GROSS VALUE

             2. For the conversion of Concentrations in MG/L to Quantity
        in LBS/DY, the Monitoring Location Code for either the Influent
        or Effluent FLOW should be entered.

             DEFAULT = 1 EFFLUENT GROSS VALUE

             3. If no LINKAGE Monitoring Location Code is entered, a
        DEFAULT or series of DEFAULT values will be tried during Report
        Processing if necessary for calculations.


        5.4  STORET Table Screen



















                        Figure 5.4    STORET Table Screen

             The STORET Table provided should require little or no main-
        tenance on your part since it contains a full list of the EPA
        STORET Codes. Currently there is no way to determine which of
        these Codes are used in conjunction with the NPDES reporting,
        therefore the full list has been provided.



        42


                                    Chapter 5  Establishing Your DATA Base


             You will also be able to add new STORET Codes to the Table
        should the EPA designate new chemicals, etc. be monitored.

             NOTE: The simple presence of a STORET Code in this table,
        does not necessarily indicate that the DMRpro System can provide
        the required calculation methods to support it. Calculation
        methods are determined from several factors within the System.

        STORET

        Format: 5 characters or Search Mode

        Mode

        Format: 1 character (A, M, D)

             The Mode field is set automatically to either "A" for Add,
        or "M" for Maintenance depending on whether the STORET Record for
        the STORET Code entered or searched for already exists.

             If the STORET Record does exist, you can change the Mode
        from "M" to "D" to delete that STORET Record.

        Desc1, Desc2

        Format: 20 characters x 2 lines

             The STORET Code Descriptions provided were entered from
        Tables provided by the EPA. These Descriptions are limited to 20
        characters each, and printed on two separate lines. The EPA's
        Tables contain a significant number of Descriptions which do not
        match these requirements, and every attempt has been made to
        provide a suitable compromise.























                                                                        43


        DMRpro Users Guide and Reference Manual


        5.5  Resetting Discharge Comments



















                  Figure 5.5    Reset Discharge Comments Screen

             The Reset Discharge Comments function does not involve the
        adding or changing of single DATA Records as do the other Mainte-
        nance functions. Instead, you enter a range of Customer/Discharge
        Numbers to be processed, and a code designating which type or
        types of Comments that you wish to have cleared.

             NOTE: See the Chapter on Multi-User Applications for addi-
        tional information about this function when running DMRpro on a
        DOS Network or in a Multi-Tasking Environment.

        Beginning Customer, Beginning Discharge

        Format: 9 characters (0-9) or Search Mode (Customer)
        Format: 3 characters (0-9) or Search Mode (Discharge)

             The Customer/Discharge Number that you want processing to
        start with.

        Ending Customer, Ending Discharge

        Format: 9 characters (0-9) or Search Mode (Customer)
        Format: 3 characters (0-9) or Search Mode (Discharge)

             The Customer/Discharge Number that you want processing to
        end with.

        COMMENT DURATION

        Format: 1 character (X, P, A, S, Q, M)

             The COMMENT DURATION entered here will be used to determine
        whether or not to RESET a particular Discharge's Comments fields


        44


                                    Chapter 5  Establishing Your DATA Base


        during this function's processing. Also, the Annual, Semi-Annual,
        and Quarterly designations here are cleared cumulatively. That
        is, if you enter "S" to clear all Semi-Annual Comments, you will
        also be clearing all "Q" (Quarterly) and all "M" (Monthly) com-
        ments.

             'X' = All
             'P' = Permanent Only
             'A' = Annual + S + Q + M
             'S' = Semi-Annual + Q + M
             'Q' = Quarterly + M
             'M' = Monthly Only


        5.6  Resetting The Test Results File

             The Test Results DATA File (DMRTR.DAT) will most likely be
        the largest file that you will have for the DMRpro System. Its
        size depends on how many individual Test Results must be per-
        formed on a regular basis and how long those Test Results must
        remain online in order to produce your Reports.

             Each Customer's Permit (issued by the EPA) will determine
        which Tests must be performed and how frequently. The Permit's
        Reporting Requirements will determine how long those Test Results
        must remain online to the DMRpro System.

             Typically, the EPA Reporting Requirements are Monthly,
        Quarterly, or both. If this is the case for your Customers, you
        would want to maintain the Test Results DATA File for at least 90
        days before initializing a new Test Results DATA File and start-
        ing to enter a new batch of Test Results.

             NOTE: After ALL the required Reports have been produced for
        any given batch of Test Results, the entire Test Results DATA
        File should be Backed Up BEFORE initializing a new Test Results
        DATA File. (Making Backups is covered as a separate topic later
        in the manual.)

             You must delete the Test Results DATA File manually before
        you can initialize a new one. To delete the Test Results DATA
        File , use the DOS DEL command. Log on to the directory for the
        Company and DATA Path (C:\DMR or user specified) containing the
        Test Results DATA File that you wish to delete, and enter the DOS
        command DEL DMRTR.DAT.

             You can now initialize a new Test Results DATA File by
        starting DMRpro and using the File Initializations function of
        the Setup Menu. Be sure to use the Company Number and DATA Path
        for the Test Results DATA File which you wish to initialize. When
        the "Test Results Data" line is highlighted and the System
        prompts you with the "File Does Not Exist, Create? " message, you
        should respond with "Y".



                                                                        45


        DMRpro Users Guide and Reference Manual


        5.7  Data Entry Messages

             Most DMRpro Data Entry errors do not display any error
        message. They only produce a BEEP sound, which in most cases
        means that the field being entered did not pass an edit function,
        or that a Search function reached either the beginning or end of
        a file. The cursor will return to the field in error and you will
        be given a chance to correct the error.

             For the error conditions which do display a message, the
        messages are taken to be self explanatory within the context in
        which they occur.

             NOTE: See the Chapter on Multi-User Applications for addi-
        tional information about error messages when running DMRpro on a
        DOS Network or in a Multi-Tasking Environment.








































        46


                                    Chapter 5  Establishing Your DATA Base


























































                                                                        47


                                      Chapter 6  Entering Test Results Data


        6.1  Decimal Precision

             All calculations performed by the DMRpro System use floating
        point (real) numbers. This allows for up to 7 digits of accuracy
        to be used in producing the required EPA Reports. The number of
        actual decimal digits used when entering data usually will be
        determined by the accuracy of your sampling or laboratory test
        equipment.

             When entering Test Results DATA into the DMRpro System,
        special consideration should be given to the number of trailing
        decimal digits entered. The number of trailing digits entered is
        one of the factors which the DMRpro System uses in determining
        the number of significant decimal digits (precision) to be used
        in the rounding of calculated results when necessary, and the
        printing of those results on the EPA Reports.

             In most cases, the number of decimal digits in the most
        accurate individual Test Result will establish the precision to
        be used. However, if that precision is less than that of the
        associated Requirements for the Test Parameter, the precision of
        the associated Requirements will be used instead.

             NOTE: If the Requirement for a Test Parameter is "REPORT",
        no decimal digits are assumed for the Requirement. The precision
        of the Test Results alone will be used to determine the decimal
        digits reported.

             NOTE: Enter integer values without any decimal point. Enter-
        ing a value such as "6." is the same as entering "6.0", which
        will be interpreted as having one significant decimal digit.

        EXCEPTION

             When DMRpro converts a CONCENTRATION value (in MG/L) to a
        QUANTITY value (in LBS/DAY), the FLOW Results used in the calcu-
        lation are assumed to be measured in MGD (million gallons per
        day) with no decimal digit precision. Therefore, the resulting
        QUANTITIES will not reflect any decimal digits.


        6.2  Special Symbols

             Test Results which cannot be measured accurately can also be
        handled by the DMRpro System. If your laboratory equipment is
        only able to measure a particular type of sample within certain
        limits, or if the results of some laboratory procedure exceed the
        limits of the equipment, it might be necessary to report that
        measurement as a "fuzzy" number. This can be done by preceding
        the limits imposed by the equipment with either the ">" or "<"
        symbol.

             Examples: "> 1" or "< .001"



                                                                        47


        DMRpro Users Guide and Reference Manual


             While all calculations involving Test Results using these
        special symbols are performed using the numeric portion only, the
        symbol is carried through to the final result and reflected on
        the EPA Reports. This means that if any individual Test Result
        uses one of the special symbols, then the Reported Result will be
        preceded by that symbol.


        6.3  Test Results Screen



















                        Figure 6.3    Test Results Screen

             The DMRpro Test Results Screen contains some features which
        are not present in other DATA Entry/Maintenance functions. These
        additional features have been included to make the repetitive
        task of entering many Test Results as easy and fast as possible.

        Repeat

        Customer, Discharge, STORET, MLOC, Date

        Format: 1 character (Y, N)

             Each of the key DATA entry fields has an associated "Repeat"
        field defined to its immediate left. These fields are to be
        filled in when you begin a DATA entry session. They may be
        changed as desired later in the session by backing up to them
        using the <SHIFT-TAB> key function.

             Entering "Y" in any of these fields causes DMRpro to auto-
        matically repeat the last value entered into the corresponding
        DATA field to its right. When you want to change the value of a
        repeated DATA field you must use the <SHIFT-TAB> key function to
        backup to that field, and then enter the new value.




        48


                                      Chapter 6  Entering Test Results Data


        Repeat, Date

        Format: 1 character (Y, N, I)

             In addition to the "Y" or "N" Codes discussed above, the
        "Repeat" field for the Date will also accept one other Code. This
        is the "I" Code (for Increment).

             When an "I" is entered in the "Repeat" field, the last Date
        value entered is not repeated (except an original entry or a
        change), but instead is incremented by one day automatically.

             NOTE: Be careful when using the Repeat and Increment fea-
        tures until you get accustomed to them. If you forget to change a
        Date, etc. when necessary, you may find that you have entered a
        lot of DATA with an incorrect key value.

             NOTE: Also, it is recommended that you use these features
        only for DATA entry purposes. When using the Search features
        available for key fields during a "maintenance" session, it is
        easy to get confused while Searching for a particular record, and
        at the same time having one or more fields automatically Repeat-
        ing.

        Customer

        Format: 9 characters (0-9) or Search Mode

             The Customer Name is displayed immediately to the right of
        the Customer Number for sight verification.

        Discharge

        Format: 3 characters (0-9) or Search Mode

             This is the Discharge Number for the Customer Number above.
        It is sometimes referred to as the "Discharge Point" or "Outfall
        Number". The Discharge Location is displayed immediately to the
        right of the Discharge Number for sight verification.

        STORET

        Format: 5 characters or Search Mode

             The STORET Code is the EPA designated Code for a given
        Parameter, i.e. a specific laboratory test. If numeric, the
        STORET Code will be right justified and zero filled automatical-
        ly. The STORET Description Lines are also displayed immediately
        to the right of the STORET Code for sight verification.







                                                                        49


        DMRpro Users Guide and Reference Manual


        MLOC

        Format: 1 character (1-9, A-Z)

             The Monitoring Location Code is designated by the EPA. You
        will find it printed immediately to the right of the STORET
        Parameter Code on your EPA 3320 Pre-Print Forms. The MLOC De-
        scription is also displayed immediately to the right of the MLOC
        Code for sight verification.

             NOTE: The Search Function associated with most key fields is
        not available for the Monitoring Location Code.

        Date

        Format: MMDDYY or Search Mode

             The Date field should be used for the actual date on which
        the Sample Measurement was taken. This Date can be very important
        during the Report Processing functions. Some of the averaging
        methods use a date mechanism to determine the period to be aver-
        aged, and all conversions from Concentrations to Quantities must
        have a matching FLOW for a given date.

        Mode

        Format: 1 character (A, M, D)

             The Mode field is set automatically to either "A" for Add,
        or "M" for Maintenance depending on whether the Test Results
        Record for the Customer, Discharge, STORET, MLOC, and Date values
        Codes entered or searched for already exists.

             If the Test Results Record does exist, you can change the
        Mode from "M" to "D" to delete that Test Results Record.

        Result

        Format: 8 characters

             This is where you enter the actual Test Result, whether from
        a direct Sample Measurement or a Laboratory Result from some
        chemical, biological, or other testing process.

             Some special symbols such as "> or <" are also accepted in
        conjunction with valid data in this field, as are the codes "T"
        for TRUE and "F" for FALSE.









        50


                                      Chapter 6  Entering Test Results Data


























































                                                                        51


                                          Chapter 7  Producing File Listings


        7.1  Common Listing Parameters

             All of the DMRpro Listing and Reporting functions provide a
        common interface for printing options.

             All printing functions provide for Beginning and Ending
        Numbers (Company, Customer, Customer/Discharge, etc.) which are
        used in selecting Records to be reported. These Numbers can also
        be used to restart a printing function should you have a paper
        jam or other non-recoverable printer error while producing a long
        report.

             The following example demonstrates the details of entering
        these common listing parameters and printing the reports. Parame-
        ters specific to individual reports are discussed as each screen
        is presented.

        EXAMPLE:

        Beginning Customer

        Format: 9 characters (0-9) or Search Mode

             The Customer Number entered here will be the first Customer
        to be included on the report. The Customer Name is displayed
        immediately to the right of the Customer Number for sight verifi-
        cation.

        Beginning Discharge

        Format: 3 characters (0-9) or Search Mode

             The Discharge Number entered here will be the first Dis-
        charge for the above Customer to be included on the report. The
        Discharge Location is displayed immediately to the right of the
        Discharge Number for sight verification.

        Ending Customer

        Format: 9 characters (0-9) or Search Mode

             The Customer Number entered here will be the last Customer
        to be included on the report. The Customer Name is displayed
        immediately to the right of the Customer Number for sight verifi-
        cation.

        Ending Discharge

        Format: 3 characters (0-9) or Search Mode

             The Discharge Number entered here will be the last Discharge
        for the above Customer to be included on the report. The Dis-
        charge Location is displayed immediately to the right of the
        Discharge Number for sight verification.


                                                                        51


        DMRpro Users Guide and Reference Manual


        REPORT DATE (MMDDYY)

             This is the date which is printed in the heading of the
        internal DMRpro reports and at the bottom of the 3320 Form. You
        can use either the current system date (default), or override the
        system date with a user specified date. To select the default
        system date, just press the <ENTER> key. Dates are printed in
        MM/DD/YY format except for the 3320 Form.

        Output to (P)rinter, or (D)isk ?

              You are able to print all reports and listings directly to
        an attached printer, or optionally select to print them to disk
        with a user specified path/name for printing at another time. To
        select the direct to printer option, enter "P". To select the
        print to disk option, enter "D".

             NOTE: Selecting the print to disk option does NOT allow a
        report to be restarted during the subsequent printing of that
        report.

             Printer alignment for all Reports and Listings have been
        designed so that the paper position for the first page of print-
        ing should be set with the page perforation at, or just above the
        print head mechanism. Also the DMRpro System automatically sup-
        plies a page eject before the first, and after the last printed
        page.

             If you select the "P" option, your printing should start
        immediately, or if an error condition is detected with your
        printer, a message will be presented and you will be allowed to
        correct the condition.

             If you select the "D" option, the System will prompt you as
        follows:

        FILENAME: C:\DMR\

             The cursor will be positioned at the end of this prompt,
        indicating that the Filename you enter will be placed in the DATA
        directory by default.

             If you want to have the report file written to some other
        disk drive or directory, you should backspace over the portion of
        the PATH that you want to change, or clear the PATH entirely with
        <CTRL-Y>, and then enter your new PATH followed by a valid DOS
        Filename.

             If the Filename that you entered already exists in that
        PATH, the System will prompt you for permission to overwrite it.






        52


                                          Chapter 7  Producing File Listings


        7.2  Company Master Listing

             The Company Master Listing will provide you with a hard copy
        Report for a selected range of Companies detailing the customized
        printing parameters for each of the companies.



















                      Figure 7.2    Company Listing Screen


        7.3  Customer Master Listing

             The Customer Master Listing provides a hard copy Report for
        a selected range of Customers. The Report includes such items as
        Customer Type, Reporting Code, Name and Address information, etc.
        Discharge Numbers and associated Discharge information are NOT
        shown on this Report.



















                      Figure 7.3    Customer Listing Screen


                                                                        53


        DMRpro Users Guide and Reference Manual


        7.4  Customer Mailing Labels

             The DMRpro Mailing Labels are formatted to be printed on
        standard 3 1/2 x 15/16 1-up continuous labels. This provides for
        4 address lines per label in the following format:


                                 123456789  123
             Customer ATTN---------------------
             Customer Name---------------------
             Customer Mailing Address-
             Customer City-------------,  ST  12345-1234


             NOTE: The DMRpro Mailing Labels Report uses normal (10 cpi)
        print mode regardless of the settings in the Company Record.



















                  Figure 7.4    Customer Mailing Labels Screen

        Reporting Code

        Format: 1 character (A,M,Q,S,X)

             'A' = Annual
             'M' = Monthly
             'Q' = Quarterly
             'S' = Semi-Annual
             'X' = All

             The Reporting Code entered here determines which group of
        Customers will be selected for mailing labels.

             NOTE: It is not necessary for a Customer to have existing
        Discharge Numbers in order to print mailing labels for that
        Customer. Use the Search Mode (F)irst option to select the first
        existing Discharge Number for a given Customer. Then if no Dis-


        54


                                          Chapter 7  Producing File Listings


        charge Numbers for that Customer exist, mailing labels will be
        printed beginning with that Customer Number.


        7.5  Customer Discharge Listing

             The Discharge Listing provides you with a hard copy Report
        for a selected range of Customer/Discharges detailing each Dis-
        charge Point's DATA elements. This may be used to verify any Dis-
        charge information prior to printing the EPA Reports. Particular
        attention should be paid to the COMMENTS entries and their dura-
        tion prior to Resetting Discharge Comments.



















                     Figure 7.5    Discharge Listing Screen


        7.6  Customer Parameter Listing

             The Customer Parameter Listing provides a hard copy Report
        for a range of Customer/Discharges detailing each STORET/MLOC
        Code combination. Except for the EPA Reports, the Customer Param-
        eter Listing will probably be your most critical Report. It shows
        all Parameter DATA elements including Requirement Limits, Calcu-
        lation Codes, and Linkages used to produce the EPA Reports.














                                                                        55


        DMRpro Users Guide and Reference Manual




















                     Figure 7.6    Parameter Listing Screen


        7.7  Test Results Listing

             The Test Results Listing provides a hard copy Report for a
        range of Customer/Discharges. It details each Test Result showing
        the STORET Code and Description, the MLOC (Monitoring Location),
        Test Date, and the specific Test Result.



















                    Figure 7.7    Test Results Listing Screen









        56


                                          Chapter 7  Producing File Listings


























































                                                                        57


                                      Chapter 8  Producing the EPA Reports


        8.1  Program Limits

             As discussed below, the DMRpro System can process up to 93
        Test Results per Parameter before having to use temporary work
        files. Temporary work files will decrease the processing speed
        and therefore degrade performance of the Reporting functions.

             Also, there is an absolute MAXIMUM number of Test Results
        per Parameter of 9000. This could be changed in a future version
        of the product if such a need is found to exist.

             All DATA Files (Company File excluded) must reside on one
        logical disk volume, and in the same directory. Individual file
        sizes are limited to 4 billion bytes.


        8.2  Temporary Work Files

             The DMRpro EPA Report functions use RAM memory to hold all
        the data needed to process up to 93 Test Results per Parameter.
        This number should be adequate for most processing requirements.
        If you exceed this number, the DMRpro System will create either
        one or two (depending on the type of calculations) temporary work
        files with unique file name(s) such as DM19 and DM20, etc.

             These files are deleted automatically when processing com-
        pletes normally, but may be left on your disk in the event of an
        interruption in processing. They may be deleted manually with no
        problem.

             The DMRpro work files will be placed in your DATA directory
        by default. However, if you would like to have them placed some-
        where else, you can use a DOS environment variable of TMP, and
        set it to point to the drive/directory where you wish to have
        them created.

             EXAMPLE: SET TMP=C:\TEMPDIR

             NOTE: These files should not be confused with the BTRIEVE
        PRE-IMAGE work files discussed earlier. The BTRIEVE work files
        use a different naming convention and are only created during the
        DATA Entry or Maintenance functions.


        8.3  Common Report Parameters

             There are three EPA Reporting functions, the EPA Edit Re-
        port, the EPA Worksheet Report, and the EPA 3320 Forms.

             The EPA Edit Report should ALWAYS be run prior to either of
        the other two Reports in order to alert you of any missing,
        invalid, or improperly linked data elements.




                                                                        57


        DMRpro Users Guide and Reference Manual


             The EPA Worksheet Report can be used in place of the EPA
        3320 Form Report. It produces a complete DMR Report formatted for
        blank computer paper. This can then be used to fill out the
        actual 3320 forms manually. Also you may wish to preview the data
        which will be reported on the 3320 Forms prior to printing them.

             The EPA 3320 Forms Report produces the final 3320 Report on
        the blank 3320 template forms. These forms may be obtained from
        the EPA.

             All three EPA Reports have a common data entry screen for
        selecting the reporting criteria, i.e. Report Code, Period to be
        Reported, and beginning and ending Customer/Discharge Numbers.

             NOTE: When running these Reports be sure to select the same
        reporting criteria for each one. If the reporting requirements
        selected for the last two Reports are different from those used
        for the Edit Report, your results could contain serious errors.



















                       Figure 8.3    EPA Worksheet Screen

        Reporting Code

        Format: 1 character (A,M,Q,S,X)

             'A' = Annual
             'M' = Monthly
             'Q' = Quarterly
             'S' = Semi-Annual
             'X' = All

             The Reporting Code entered here determines which group of
        Customers will be selected for this reporting cycle.





        58


                                      Chapter 8  Producing the EPA Reports


        From Period, To Period

        Format: MMDDYY

             The From Period and To Period fields determine which Test
        Results are to be included in the calculations for this cycle.
        The dates are entered in MMDDYY format, and printed on the EPA
        3320 Report in YYMMDD format as per the forms requirement.

             NOTE: Test Results are selected INCLUSIVE of these two
        dates.

        Beginning Customer

        Format: 9 characters (0-9) or Search Mode

             The Customer Number entered here will be the first Customer
        to be included on the report. The Customer Name is displayed
        immediately to the right of the Customer Number for sight verifi-
        cation.

        Beginning Discharge

        Format: 3 characters (0-9) or Search Mode

             The Discharge Number entered here will be the first Dis-
        charge for the above Customer to be included on the report. The
        Discharge Location is displayed immediately to the right of the
        Discharge Number for sight verification.

        Ending Customer

        Format: 9 characters (0-9) or Search Mode

             The Customer Number entered here will be the last Customer
        to be included on the report. The Customer Name is displayed
        immediately to the right of the Customer Number for sight verifi-
        cation.

        Ending Discharge

        Format: 3 characters (0-9) or Search Mode

             The Discharge Number entered here will be the last Discharge
        for the above Customer to be included on the report. The Dis-
        charge Location is displayed immediately to the right of the
        Discharge Number for sight verification.









                                                                        59


        DMRpro Users Guide and Reference Manual


        8.4  The EPA Edit Report

             The EPA Edit Report should be run just prior to producing
        either a preliminary or final EPA Worksheet or 3320 Forms Report.
        This DMRpro function is designed to both alert you to any excur-
        sions to the EPA Requirements which will be Reported, and to spot
        any missing or incorrect DATA elements necessary for the Calcula-
        tions and Reporting functions of the Worksheet and/or EPA 3320
        Form Reports.

             NOTE: If any changes or corrections are made after reviewing
        any DMRpro preliminary Report, you should run the EPA Edit Report
        again to insure that your changes did not produce any unintended
        results or side effects.


        8.5  The EPA Worksheet Report

             The EPA Worksheet Report has been included to provide an
        alternative to printing the EPA 3320 Report on special forms. It
        can provide you with a preview of the Results to be printed on
        the actual EPA 3320 Forms without having to use the Forms them-
        selves. Also, if your computer system does not have a printer
        capable of handling the EPA 3320 forms, you can transfer the
        Results from the Worksheet Report to the EPA 3320 Forms manually.


        8.6  The EPA 3320 Form Report

             The EPA 3320 Form Report prints all the information for the
        EPA 3320 Report in the proper format for using the blank EPA 3320
        Forms template available from either your local or federal EPA
        office.

             In addition to the usual DMRpro prompts for producing re-
        ports, if you have selected to print directly to an attached
        printer, the DMRpro System provides a FORMS ALIGNMENT pattern to
        aide you in correctly loading and aligning the blank EPA 3320
        Forms. This pattern may be repeated until the forms are correctly
        aligned for printing.

             NOTE: The EPA 3320 Form Report uses normal (10 cpi) print
        mode regardless of the settings in the Company Record.













        60


                                      Chapter 8  Producing the EPA Reports


























































                                                                        61


                                                 Chapter 9  The DOS Shell


        9.1  The DOS Shell

             In order to use the DMRpro DOS Shell menu option, the de-
        fault environment must have a PATH set to your COMMAND.COM file.
        (see your DOS manual for information on how to use the DOS PATH
        command to set the default environment PATH.)

             This function also requires that at least 19 bytes of the
        DOS Environment Area be available. Also additional RAM memory may
        be required to use this option depending on what programs you
        will be executing while in the DOS Shell.

             After you have selected the DOS Shell from the Main Menu,
        the DMRpro System will be put on hold and you will be presented
        with the message "Type EXIT to return to DMRpro", followed by the
        DOS Command Prompt ">", or if enough memory was not available, a
        message to that effect followed by "Press any key to
        continue...".

             NOTE: You will be placed in your "current" DOS drive/direc-
        tory. This may, or may not, be the same as your "DATA" directory.

             At the DOS Command Prompt you can run any utilities or other
        programs that you wish to. If you make another directory the
        "current" directory, remember to change it back before you enter
        the EXIT command to return control to DMRpro.

             Also, you will have significantly less available memory than
        you normally have to work with. This is due to the fact that the
        DMRpro System is still in memory although not active, and you are
        running under a second copy of the DOS Command Interpreter which
        also requires some additional memor.                   É£1(|    ..                   É£1(     å                               å                           61
å

        DMRpro Users Guide ånd Reference Manual





å















å















å















å




        62


     å                               å           Chapter 9  The DOS Såell













å















å















å












      å                               å                               å 63


                     å                  Chapter 10  Målti-User Applications


        10.1  DOS Networks

      å      DMRpro is delivered with åhe "client-based" version of
 å      BTRIEVE. This allows DMRpåo to provide access by multipleåusers
        to the same DATAåFiles as long as those files arå placed on the
        NetworkåFile Server. In this environmenå, each workstation must
      å run it's own copy of BTRIEVE aåd DMRpro even though the serverå
        based DATA Files can bå shared by all workstations.
å             In order to prevenå the simultaneous update/deletiån of the
        same Record bå more than one user, DMRpro useå a "passive concur-
        reåcy" technique. This simply requåres determining whether a
    å   Record has been changed betwåen the time that a workstation åeads
        the Record and thå time that an update or deletioå attempt is
        made for tåat Record.

             A "cånflict" can occur when attemptiåg to update or delete a
      å Record and DMRpro is running iå a "Multi-User Mode" (i.e. DOSå        Network or Multi-Taskinå Environment). The error messagå "Record
        Update Confliåt" indicates that another worksåation has changed
        the åecord which you are currently aåcessing, between the time
    å   the Record was read at your åorkstation, and the time of youå
        "Update" or "Delete".åYou will be allowed to re-acceså the Record
        if you wiså to, and must then re-apply youå changes or try to
        "Deåete" the Record again.

     å       There is one DMRpro funcåion for which the "passive concår-
        rency" method is noå the optimal solution. That funåtion is the
        batch procåssing function that Clears Discåarge Comments. While
        håghly unlikely to occur, it is påssible to run this function
  å     from two workstations at tåe same time. To eliminate this åemote
        possibility, DOSåfile LOCKING has been included ån the Clear
        Discharge åomments function.

          å  NOTE: To enable the DOS file åOCKING mechanism in a Single-
å       User Multi-Tasking Envirånment, you must run the DOS SHAåE Com-
        mand (approximaåely 8K additional memory) beforå starting the
        DMRpro Såstem. Also, once SHARE is instaåled it cannot be removed
     å  without re-booting your compuåer.

        SHARE.EXE

   å         When DMRpro is runningåin a Multi-User Mode with SHAREå
        installed and you actiåate the Clear Discharge Commentå function
        from the SubåMenu, that function attempts toågain exclusive
        access åo the Customer Discharge File.å
             If exclusive accåss is obtained, the Customer Diåcharge File
        becomes unåvailable to any other DMRpro fuåctions which require
        aåcess to it (most of them) untilåthe update is completed. Any
 å      attempt to run another DMåpro function which requires accåss to
        the Customer Disåharge File will result in the eåror message
        "DischargeåUpdate in Progress" and "Abnormål Termination".



        å                               å                               å3


        DMRpro Users Guåde and Reference Manual


  å          If unable to obtain eåclusive access, DMRpro displaysåthe
        error message "Disåharge File Currently In Use" anå then returns
        to the Såb-Menu.


        10.2  Multå-Tasking Environments

      å      The information in the seåtion on DOS Networks and Multi-
        User Mode apply equally to Multi-Tasking Operating Environments,
        such as Quarterdeck's DESQview and Microsoft's Windows 3.0. The
        only differences are, there is only one user running DMRpro in
        multiple windows, and the DATA files are local to the workstation
        and not on a file server.

             Although some testing of the DMRpro System has been done
        under the most recent versions of each of these Operating Envi-
        ronments, the DMRpro System is NOT SUPPORTED for use with either
        one at the present time. Comments regarding the test setups used,
        and the resulting observations, are summarized below for the
        advanced computer user who wishes to try them.

        DESQview

             No problems were observed when running DMRpro under Quarter-
        decks' DESQview version 2.26 and the QEMM-386 version 5.00 ex-
        panded memory manager.

             1. BTRIEVE must be run in each DMRpro window rather than in
                high memory before starting DESQview.

             2. Writes text directly to screen = Y (DVP settings).

        Windows 3.0

             No problems were observed when running under Microsoft's
        Windows 3.0, except when running in 386 enhanced mode with SHARE
        loaded. If you wish to use 386 enhanced mode with SHARE, you
        should include the following line in the Windows SYSTEM.INI file,
        [386Enh] section: EMMExclude=A000-EFFF

             1. BTRIEVE was run in each DMRpro window.

             2. Standard Mode Options (PIF settings).
                Video Mode = Text.
                KB Required = 457 (this will not allow for the DOS
                Shell).

             3. 386 Enhanced Mode Options (PIF settings).
                KB Required = 457, KB Desired = 640.
                Video Mode = Text.
                Monitor Ports = High Graphics.
                Emulate Text Mode = ON.




        64


                                        Chapter 10  Multi-User Applications


























































                                                                        65


                                                 Chapter 11  Miscellaneous


        11.1  Making Backups

             DMRpro does not presently provide any internal functions to
        make Backup or Archive DATA Files. These functions are left up to
        each individual installation to provide the method, frequency,
        and software/hardware necessary to maintain a reasonable and
        timely Backup/Restore capability.

             There are several commercially available software products
        which can automate, compress, archive, and restore data both
        reliably and quickly. MS-DOS also provides a BACKUP and a RESTORE
        program with the operating system.


        11.2  Ordering Forms

             Blank forms for the EPA-3320 Report are available at no cost
        from either your state EPA office, or from your regional U.S. EPA
        office.

             Order EPA Form 3320-1.



































                                                                        65


        DMRpro Users Guide and Reference Manual


























































        66


                                                 Chapter 11  Miscellaneous


























































                                                                        67


                                                       (A) Sample Reports



        (A) Sample Reports

        A.1  Company Master Listing




















































                                                                        67


        DMRpro Users Guide and Reference Manual


        A.2  Customer Master Listing























































        68


                                                       (A) Sample Reports


        A.3  Customer Mailing Labels























































                                                                        69


        DMRpro Users Guide and Reference Manual


        A.4  Customer Discharges Listing























































        70


                                                       (A) Sample Reports


        A.5  Customer Parameters Listing























































                                                                        71


        DMRpro Users Guide and Reference Manual


        A.6  STORET Table Listing























































        72


                                                       (A) Sample Reports


        A.7  Test Results Data Listing























































                                                                        73


        DMRpro Users Guide and Reference Manual


        A.8  EPA 3320 Edit Report























































        74


                                                       (A) Sample Reports


        A.9  EPA 3320 Worksheet Report























































                                                                        75


        DMRpro Users Guide and Reference Manual


        A.10  EPA 3320 Forms Report























































        76


                                                       (A) Sample Reports


























































                                                                        77


                                                                    Index



        Index

        Abnormal Termination, 10
        Accuracy, 47
        Adapter
          display, 3, 24
        Address
          mailing, 28
          street, 28
        Alignment
          forms, 52, 60
        Analysis
          frequency of, 39, 40
        Archive, 65
        Arrow Keys, 15, 17, 25
        ASCII, 5, 10
        Assistance, 2
        Asterisks (*)
          on EPA pre-print forms, 36
        Authorized Agent, 29
        AUTOEXEC.BAT, 4, 9
        Averages
          7 day, 1, 38
          continuous, 1, 38
          month days, 1, 38
          week days, 1, 38

        Background, 1
        Backslash, 21
        BACKSPACE Key, 17
        Backup, 5, 45, 65
        Base
          see statistical base codes
        Basis
          see statistical base codes
        BEEP, 46
        BLANK FIELDS, 16
        BSTOP.EXE, 9
        BTRIEVE, 5, 6, 9, 10, 11, 57, 63, 64
        BTRIEVE.EXE, 6, 9, 10
        BUFFERS=, 3
        Buffer-full Print, 21

        Cache
          disk, 3, 11
        Calculations, 47
        Cancel, 16, 17, 22
        Clear, 16, 17, 32, 36, 37, 44, 45, 52
        Colors
          background, 24
          configuration file, 6, 25
          foreground, 24
          screen, 6, 13, 24, 25


                                                                        77


        DMRpro Users Guide and Reference Manual


        Comments
          discharge, 31, 32, 33, 44, 45, 55
        Common
          key functions, 16
          listing parameters, 51
          report parameters, 57
        Company
          default print mode, 21
          default printer, 20
          left print margin, 21
          name, 20
          number, 19
          printer setup strings, 21
        CONCENTRATION, 47
        Concentration Parameters, 1, 33, 38, 41, 42, 50
        Condensed
          print mode, 21, 22
        CONFIG.SYS, 3
        Continuous
          averages, 1, 38
        Conversion
          concentrations to quantities, 47
        Conversions, 41, 42, 50
        Convert, 37, 39
        CTRL-Y, 16, 17, 36, 37, 52
        Cursor, 16, 17, 52
        Customer
          attention, 54
          attention line, 29
          city, 29, 54
          DSMRE permit, 28
          executive officer, 29
          facility, 29
          location, 29
          mailing address, 28, 54
          name, 54
          NPDES permit, 28
          phone number, 30
          report code, 28
          reporting code, 54, 58
          state, 29, 54
          street address, 28
          type, 27
          zip code, 29, 54
        Customer Support, 2
        Customization, 24, 53
        Cycle
          reporting, 58, 59

        Data Entry Errors, 46
        Dates, 49, 50, 52, 56, 59
        Decimal precision, 47
        Defaults, 4, 6, 9, 10, 11, 13, 17, 19, 20, 21, 23, 25, 37, 38,
        41,  42, 52, 57, 61


        78


                                                                    Index


        DEL
          DOS command, 45
        DEL Key, 17
        Deleting
          characters, 17
          files, 10, 45, 57
        Deleting Records
          see update mode
        Descriptions, 1, 6, 25, 31, 32, 34, 35, 49, 50, 56
        Descriptions
          parameter, 43
        Dialogues
          question and answer, 18
        Directories (DOS), 6, 7, 9, 13, 20, 45, 52, 57, 61
        Discharge
          comment duration, 32, 44
          comments, 33
          comments, resetting, 44
          description, 31
          DRID, 32
          latitude, 31
          longitude, 31
          LTYP, 32
          reclaim #, 31
          RTYP, 32
        Discharge Point, 4, 5, 27, 30, 31, 32, 34, 49, 55
        DMnn
          temporary files, 57
        DMRINST.EXE, 4
        DMR.BAT, 9, 10
        DOS
          file locking, 63
        DOS Network, 63
        DOS Networks, 44, 46, 64
        Double Spaced
          printing problem, 21
        Duration
          discharge comments, 32, 44, 55

        EBCDIC, 41
        Effluent, 41, 42
        END Key, 17
        ENTER Key, 17
        Environment
          DOS, 4, 9, 57, 61
        EPA
          report preparation, 19, 45, 55, 57, 58, 59, 60, 65
        Error Messages, 63
        Errors, 6, 10, 16, 51, 52, 58
        Errors
          data entry, 46
        ESC Key, 16, 17, 18
        Estimating
          space requirements, 4, 6


                                                                        79


        DMRpro Users Guide and Reference Manual


        Exclusive Access, 63
        Exclusive Access
          see also SHARE
        Excursions, 36, 38, 60
        Expanded Memory, 11

        F1 Key, 17
        F2 Key, 17, 33
        Filename
          DOS, 52
        Files
          DATA, 5
          system, 5
        FILES=, 3
        FLOW, 41, 42, 47, 50
        Forms
          computer, 21, 22, 58, 65
          ordering, 65
        Frequency
          of analysis, 39, 40
          reporting, 28

        Hardware Requirements, 3
        Headings
          report, 20, 52
        Help
          online, 1, 6, 16, 17, 18, 24
        HOME Key, 17

        Increment
          automatic date, 49
        Influent, 41, 42
        Initialize
          printer, 21
        Initializing
          data files, 13, 19, 23, 45
        INSERT Key, 17
        Installing DMRpro, 5, 6, 7, 9, 20
        Integer values
          entering, 47

        KEY Fields, 16, 34, 35, 48, 49, 50

        Labels
          see mailing labels
        Limit Type, 32
        Limits
          equipment imposed, 47
          permit, 36, 55
          program, 1, 10, 57
          seasonal, 35
        Linkages
          parameter, 33, 39, 41, 42, 55, 57



        80


                                                                    Index


        Listings
          data, 51, 52, 53, 55, 56
        LOADING Parameters
          see quantity parameters

        Mailing Labels, 28, 29, 54
        Maintenance Mode, 27, 31, 35, 43, 44, 48, 49, 50
        Manual File Deletions, 45, 57
        Margins
          print, 21
        Memory
          expanded, 11
          requirements, 1, 3, 4, 11, 57, 61
        Mode
          print, 21, 22
          search, 16, 27
          update, 27, 31, 35, 43, 50
        Monitoring Location, 35, 41, 42, 48, 50, 55, 56
        Multiple Users, 63
        Multi-Company Option, 19, 20
        Multi-Tasking
          Microsoft Windows 3.0, 64
          Quarterdeck DESQview, 64
        Multi-Tasking Environment, 44, 46, 63
        Multi-User Applications, 44, 46
        Multi-User Mode, 64
        Multi-User Mode
          defined, 63

        Network, 63
        Network File Server, 63
        Network Version, 1, 11
        Networks, 44, 46, 64

        Outfall, 30, 34, 49

        Parameter
          base, average, 36, 38
          base, maximum, 36, 38
          base, minimum, 38
          exceptions indicator, 38
          linkage data, 41
          MLOC linkage, 42
          MODN, 35
          quantity calculation code, 38
          requirement, average, 36, 38
          requirement, frequency of analysis, 40
          requirement, maximum, 36, 38
          requirement, minimum, 38
          requirement, type sampling, 40
          requirement, units of measure, 37
          sample, frequency of analysis, 39
          sample, type sampling, 40



                                                                        81


        DMRpro Users Guide and Reference Manual


        Parameter (continued)
          sample, units of measure, 37
          SEAN, 35
          STORET linkage, 41
        Passive Concurrency, 63
        PATH
          command.com, 4, 61
          data files, 6, 20, 23, 45, 52
          system files, 9, 20
        PATH=, 4, 9
        Performance
          system, 57
        Period
          monitoring, 58, 59
          reporting, 50
          sampling, 39
        Permit
          DSMRE, 28
          mining, 31
          NPDES, 28, 29, 33, 45
        Permit Compliance System (PCS), 1, 39
        PgUp/PgDn Keys, 18
        Precision
          decimal, 47
        Pre-defined
          BTRIEVE parameters, 11
          company data, 19
        Pre-Image Files, 10, 11, 57
        Print Mode, 21, 22
        Print Modes, 21, 54, 60
        Program Level, 16, 25

        QUALITY Parameters
          see concentration parameters
        QUANTITY, 47
        Quantity Parameters, 1, 36, 38, 41, 42, 50

        RAM
          see memory requirements
        README.TXT Text File, 5
        Reclamation
          mining permit numbers, 28, 31
        Record Update Conflict
          error message, 63
        Removal
          percentages, 1, 41, 42
        Repeating
          automatic, 48, 49
        Resetting
          accumulated test data, 45
          discharge comments, 32, 44, 55
          screen colors, 25
        Rounding, 47



        82


                                                                    Index


        Search Mode, 16, 27
        SHARE
          DOS Command, 63
        Shell
          DOS, 4, 61
        SHIFT-TAB Key, 17
        Significant decimal digits, 47
        Special Symbols, 47
        Statistical Base Codes, 1, 36
        STORET
          EPA Codes, 1, 6, 34, 41, 42, 43, 48, 49, 50, 55, 56
        STORET Table
          parameter descriptions, 43

        TAB Key, 17
        Tables
          EPA, 1, 36, 37, 40, 41, 42, 43
        Temporary Files, 10, 57
        Termination
          abnormal, 10
        Test Results
          auto-repeating key fields, 48, 49
        TMP
          DOS environment variable, 57

        Update Mode, 27, 31, 35, 43, 50

        Waiver
          granted by EPA, 38
        Worksheet Report, 3, 57, 58, 60

        * (asterisks)
          on EPA pre-print forms, 36

        *.PRE files, 10

        < symbol, 47

        > symbol, 47

















                                                                        83

