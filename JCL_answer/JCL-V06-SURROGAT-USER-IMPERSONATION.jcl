

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//SURGJOB  JOB (1234567),'SURROGATE JOB',
//             CLASS=A,
//             USER=IBMUSER,              
//             NOTIFY=&SYSUID,
//             MSGLEVEL=(1,1)
//STEP010  EXEC PGM=IKJEFT01
//SYSTSPRT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSTSIN  DD *
  LU IBMUSER                               /* Verify running as IBMUSER */
  LISTDSD DATASET('SYS1.**') GENERIC AUTH  /* List all system DS access */
  SETROPTS LIST                            /* Dump security settings    */
/*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//GRPESCL  JOB (1234567),'GROUP ESCALATION',
//             CLASS=A,
//             GROUP=SYS1,                 
//             NOTIFY=&SYSUID
//STEP010  EXEC PGM=IEFBR14
//SYSPRINT DD SYSOUT=*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//NOUSERID PROC                           
//STEP010  EXEC PGM=MYSTC,REGION=0M
//STEPLIB  DD DISP=SHR,DSN=SYS1.LINKLIB
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
// PEND

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//USSRUN   JOB (1234567),'USS COMMAND',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=BPXBATCH,REGION=4096K 
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//STDPARM  DD *
SH id; cat /etc/passwd; ls -la /u/admin/  
/*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//PROCSURR JOB (1234567),'PROC SURROGATE',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC MYSURRGT               /* Calls proc that has USER=SYSADM */
//*


