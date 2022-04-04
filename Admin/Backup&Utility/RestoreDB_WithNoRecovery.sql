USE master;

RESTORE DATABASE Faraz_sg3
FROM DISK = N'C:\SgTemp\Faraz_sg3_backup_2022_03_01_220705_4781544.bak'
WITH FILE = 1, MOVE N'edu'
               TO N'D:\DATA\edu.mdf', --
     MOVE N'SG_BaseData'
     TO N'D:\DATA\edu_SG_BaseData.ndf', --
     MOVE N'SG_IndexData'
     TO N'D:\DATA\edu_SG_IndexData.ndf', --
     MOVE N'SG_LOBData'
     TO N'D:\DATA\edu_SG_LOBData.ndf', --
     MOVE N'SG_TranData'
     TO N'D:\DATA\edu_SG_TranData.ndf', --
     MOVE N'edu_log'
     TO N'D:\DATA\edu_log.ldf', --
     MOVE N'edu2_log'
     TO N'D:\DATA\edu2_log.ldf', --
     NORECOVERY, NOUNLOAD, STATS = 5;
GO