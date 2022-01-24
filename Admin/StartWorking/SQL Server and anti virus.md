# SQL Server and anti virus
How to choose antivirus software to run on computers that are running SQL Server
Microsoft SQL Server

## Summary
This article contains general guidelines to help you decide which antivirus software to run on computers that are running SQL Server in your environment.

## More Information
We strongly recommend that you individually assess the security risk for each computer that is running SQL Server in your environment and that you select the tools that are appropriate for the security risk level of each computer that is running SQL Server.

Additionally, we recommend that before you roll out any virus-protection project, you test the whole system under a full load to measure any changes in stability and performance.

Virus protection software requires some system resources to execute. You must perform testing before and after you install your antivirus software to determine whether there is any performance effect on the computer that is running SQL Server.

### Security risk factors
* The value to your business of the information that is stored on the computer
* The required security level for that information
* The cost of losing access to that information
* The risk of either virus or bad information propagating from that computer

## High-risk servers
Any server is at some risk of infection. The highest-risk servers generally meet one or more of the following criteria:

* The servers are on the public Internet.
* The servers have open ports to servers that are not behind a firewall.
* The servers read or execute files from other servers.
* The servers run HTTP servers, such as Internet Information Services (IIS) or Apache (for example, SQL XML for SQL Server 2000).
* The servers also host file shares.
* The servers use SQL Mail or Database Mail to handle incoming or outgoing email messages.

Servers that do not meet the criteria for a high-risk server are generally at a lower risk, although not always.

## Virus tool types
* Active virus scanning: This kind of scanning checks incoming and outgoing files for viruses.

* Virus sweep software: Virus sweep software scans existing files for file infection. It detects files after they are infected by a virus. This kind of scanning may cause the following SQL Server database recovery and SQL Server full-text catalog file issues:

    * If the virus sweep has opened a database file and still has it open when SQL Server tries to open the database (such as when SQL Server starts or opens a database that AutoClose has closed), the database to which the file belongs might be marked as suspect. SQL Server database files typically have the .mdf, .ldf, or .ndf file name extensions.

    * If the virus sweep software has a SQL Server full-text catalog file open when the Microsoft Search service (MSSearch) tries to access the file, you may have problems with the full text catalog.

* Vulnerability scanning software: The Microsoft Security Compliance Toolkit includes a set of tools that enables enterprise security administrators to download, analyze, test, edit, and store Microsoft-recommended security configuration baselines for Windows and other Microsoft products and compare them against other security configurations. To download it, go to Microsoft Security Compliance Toolkit 1.0.

Additionally, Microsoft released the Microsoft Windows Malicious Software Removal Tool to help remove specific, prevalent malicious software from computers. For more information about the Microsoft Windows Malicious Software Removal Tool, see the following article in the Microsoft Knowledge Base:

890830 Remove specific prevalent malware with Windows Malicious Software Removal Tool

> Note: Windows Server 2016 automatically enables Windows Defender. Make sure that Windows Defender is configured to exclude Filestream files. Failure to do this can result in decreased performance for backup and restore operations.

For more information, see Configure and validate exclusions for Windows Defender Antivirus scans.

### Directories and file name extensions to exclude from virus scanning
When you configure your antivirus software settings, make sure that you exclude the following files or directories (as applicable) from virus scanning. This improves the performance of the files and helps make sure that the files are not locked when the SQL Server service must use them. However, if these files become infected, your antivirus software cannot detect the infection.

> Note: For more information about the default file locations for SQL Server, go to the File Locations for Default and Named Instances of SQL Server topic on the Microsoft Docs website.

* SQL Server data files

    These files usually have one of the following file name extensions:
    * .mdf
    * .ldf
    * .ndf

* SQL Server backup files
    
    These files frequently have one of the following file name extensions:
    * .bak
    * .trn

* Full-Text catalog files
    * Default instance: Program Files\Microsoft SQL Server\MSSQL\FTDATA
    * Named instance: Program Files\Microsoft SQL Server\MSSQL$instancename\FTDATA

* Trace files
    
    These files usually have the .trc file name extension. These files can be generated either when you configure profiler tracing manually or when you enable C2 auditing for the server.

* SQL audit files (for SQL Server 2008 or later versions)
    
    These files have the .sqlaudit file name extension. For more information, see the following Microsoft Docs SQL Server page:

* SQL query files
  
  These files typically have the .sql file name extension and contain Transact-SQL statements.

* The directory that holds Analysis Services data

> Notes: The directory that holds all Analysis Services data is specified by the DataDir property of the instance of Analysis Services. By default, the path of this directory is C:\Program Files\Microsoft SQL Server\MSSQL.X\OLAP\Data. If you use Analysis Services 2000, you can view and change the data directory by using Analysis Manager. To do this, follow these steps:
> 
> a. In Analysis Manager, right-click the server, and then select Properties.
> a. In the Properties dialog box, select the General tab. The directory appears under Data folder.


* The directory that holds Analysis Services temporary files that are used during Analysis Services processing

> **Notes**: 
> 
> * For Analysis Services 2005 and later versions, temporary files during processing are specified by the TempDir property of the instance of Analysis Services. By default, this property is empty. When this property is empty, the default directory is used. This directory is C:\Program Files\Microsoft SQL Server\MSSQL.X\OLAP\Data. If you use Analysis Services 2000, you can view and change the directory that holds temporary files in Analysis Manager. To do this, follow these steps:</br>
> Optionally, you can add a second temporary directory for Analysis Services 2000 by using the TempDirectory2 registry entry. If you use this registry entry, consider excluding from virus scanning the directory to which this registry entry points. For more information about the TempDirecotry2 registry entry, see the "TempDirectory2" section of the following Microsoft Developer Network (MSDN) website:
> 
> * SQL Server 2000 Retired Technical documentation
>   a. In Analysis Manager, right-click the server, and then select **Properties**.
>   a. In the Properties dialog box, click the **General** tab.
>   a. On the **General** tab, notice the directory under **Temporary file folder**.


* Analysis Services backup files

> Note: By default, in Analysis Services 2005 and later versions, the backup file location is the location that is specified by the BackupDir property. By default, this directory is C:\Program Files\Microsoft SQL Server\MSSQL.X\OLAP\Backup. You can change this directory in the properties of the instance of Analysis Services. Any backup command can point to a different location. Or, the backup files can be copied elsewhere.

* The directory that holds Analysis Services log files

> Note: By default, in Analysis Services 2005 and later versions, the log file location is the location that is specified by the LogDir property. By default, this directory is C:\Program Files\Microsoft SQL Server\MSSQL.X\OLAP\Log.

* Directories for any Analysis Services 2005 and later-version partitions that are not stored in the default data directory

> Note: When you create the partitions, these locations are defined in the Storage location section of the Processing and Storage Locations page of the Partition Wizard.

* Filestream data files (SQL 2008 and later versions)
    * No specific file extension for the files.
    * Files are present under the folder structure identified by the container of type FILE_STREAM from sys.database_files.

* Remote Blob Storage files (SQL 2008 and later versions)

* The directory that holds Reporting Services temporary files and Logs (RSTempFiles and LogFiles)

* Extended Event file targets

    *  Typically saved as .xel or .xem.

    * System generated files are saved in the LOG folder for that instance.

* Exception dump files
    * Typically use the .mdmp file name extension.
    * System generated files are saved in the LOG folder for that instance.

* In-memory OLTP files
    * Native procedure and in-memory table definition-related files.
        * Present in a xtp sub-folder under the DATA directory for the instance.
        * File formats include the following:
            * xtp_<t/p>_<dbid>_<objid>.c
            * xtp_<t/p>_<dbid>_<objid>.dll
            * xtp_<t/p>_<dbid>_<objid>.obj
            * xtp_<t/p>_<dbid>_<objid>.out
            * xtp_<t/p>_<dbid>_<objid>.pdb
            * xtp_<t/p>_<dbid>_<objid>.xml

* Checkpoint and delta files
    * No specific file extension for the files.
    * Files are present under the folder structure identified by the container of type FILE_STREAM from sys.database_files.

* DBCC CHECKDB files
    * Files will be of the format <Database_data_filename.extension>_MSSQL_DBCC<database_id_of_snapshot>.
    * These are temporary files.
    * For more information, see the following article:
    
      2974455 DBCC CHECKDB behavior when the SQL Server database is located on an ReFS volume

* Replication
    * Replication executables and server-side COM objects.
        * x86 default location: <drive>:\Program Files (x86)\Microsoft SQL Server\<VN>\COM\
        * x64 default location: <drive>:\Program Files\Microsoft SQL Server\<VN>\COM\

> Note: The <VN> place holder is for version-specific information. To specify the correct value, check your installation or search for “Replication and server-side COM objects” in the Specifying File Paths table in the File Locations for Default and Named Instances of SQL Server topic in Books Online.

For example, the full path for SQL Server 2014 would be <drive>:\Program Files\Microsoft SQL Server\120\COM\.

* Files in Replication Snapshot folder

```note
The default path for the snapshot files is \Microsoft SQL Server\MSSQLxx.MSSQLSERVER\MSSQL\ReplData. 
These files typically have file name extensions of .sch, .idx, .bcp, .pre, .cft, .dri, .trg or .prc.
```
### Processes to exclude from virus scanning
* %ProgramFiles%\Microsoft SQL Server\<Instance_ID>.<Instance Name>\MSSQL\Binn\SQLServr.exe

* %ProgramFiles%\Microsoft SQL Server\<Instance_ID>.<Instance Name>\Reporting Services\ReportServer\Bin\ReportingServicesService.exe

* %ProgramFiles%\Microsoft SQL Server\<Instance_ID>.<Instance Name>\OLAP\Bin\MSMDSrv.exe

* %ProgramFiles%\Microsoft SQL Server\1xx\Shared\SQLDumper.exe

Considerations for clustering
You can run antivirus software on a SQL Server cluster. However, you must make sure that the antivirus software is a cluster-aware version. Contact your antivirus vendor about cluster-aware versions and interoperability.

If you are running antivirus software on a cluster, make sure that you also exclude these locations from virus scanning:

* Q:\ (Quorum drive)
* C:\Windows\Cluster
* MSDTC directory in the MSDTC drive

If you back up the database to a disk or if you back up the transaction log to a disk, you can exclude the backup files from the virus scanning.

<a href="https://support.microsoft.com/en-us/topic/how-to-choose-antivirus-software-to-run-on-computers-that-are-running-sql-server-feda079b-3e24-186b-945a-3051f6f3a95b" target="_blank">Online References</a>
