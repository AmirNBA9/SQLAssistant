USE CRM_MSCRM;

SET ANSI_NULLS OFF;

SELECT S.uid, S.name, S.roles, S.createdate, S.updatedate, S.gid, S.hasdbaccess, S.islogin, S.isntname, S.isntgroup, S.isntuser, S.issqluser, S.issqlrole, S.isapprole
  FROM sys.sysusers AS S
 WHERE S.altuid = NULL;
