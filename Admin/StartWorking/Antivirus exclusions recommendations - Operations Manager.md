# Antivirus exclusions recommendations - Operations Manager

This article introduces some recommendations for antivirus exclusions that relate to System Center 2012 Operations Manager, System Center 2012 R2 Operations Manager, and System Center 2016 Operations Manager. For later versions of Operations Manager, see <a href="/en-us/system-center/scom/plan-security-antivirus" data-linktype="absolute-path">Configuring antivirus exclusions for agent and components</a>.

<p><em>Original product version:</em>   Microsoft System Center 2012 Operations Manager, System Center 2012 R2 Operations Manager, System Center 2016 Operations Manager<br/>
<em>Original KB number:</em>   975931</p>
<h2 id="exclusions-by-process-executable">Exclusions by process executable</h2>
<p>You must be careful when you add exclusions that are based on executables as incorrect exclusions may prevent some potentially dangerous programs from being detected. Because of this, we do not recommend that you rely on exclusions that are based on any process executables for Operations Manager servers. However, if you have to make exclusions that are based on the process executables, use the following processes:</p>
<ul>
<li>Monitoringhost.exe (Operations Manager 2012)</li>
<li>Monitoringhost.exe (Operations Manager 2012 R2)</li>
<li>MonitoringHost.exe (Operations Manager 2016)</li>
</ul>
<h2 id="exclusions-by-directories">Exclusions by directories</h2>
<p>The following directory-specific exclusions for Operations Manager include real-time scans, scheduled scans, and local scans. The directories that are listed here are default application directories so you may have to modify these paths based on your specific environment. Only the following Operations Manager related directories should be excluded.</p>
<div class="IMPORTANT">
<p>Important</p>
<p>When a directory that is to be excluded has a directory name greater than 8 characters long, add both the short and long directory names of the directory to the exclusion list. These names are required by some antivirus programs to traverse the subdirectories.</p>
</div>
<h3 id="sql-server-database-servers">SQL Server database servers</h3>
<p>These exclusions include the SQL Server database files that are used by Operations Manager components and the system database files for the master database and for the tempdb database. To exclude these files by directory, exclude the directory for the .ldf and .mdf files.</p>
<p>For example:</p>
<ul>
<li>C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data</li>
<li>D:\MSSQL\DATA</li>
<li>E:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Log</li>
</ul>
<h3 id="operations-manager-management-servers-gateways-and-agents">Operations Manager (management servers, gateways, and agents)</h3>
<p>These exclusions include the Health Service cache, together with its queue and log files that are used by Operations Manager. Examples follow.</p>
<h4 id="for-operations-manager-2012">For Operations Manager 2012</h4>
<p><code>C:\Program Files\System Center Operations Manager\Agent\Health Service State</code><br/>
<code>C:\Program Files\System Center Operations Manager\Server\Health Service State</code></p>
<h4 id="for-operations-manager-2012-r2">For Operations Manager 2012 R2</h4>
<ul>
<li><p>For a management server: <code>C:\Program Files\Microsoft System Center 2012 R2\Operations Manager\Server\Health Service State</code></p>
</li>
<li><p>For a gateway server: <code>C:\Program Files\System Center Operations Manager\Gateway\Health Service State</code></p>
</li>
<li><p>For an agent: <code>C:\Program Files\Microsoft Monitoring Agent\Agent\Health Service State</code></p>
</li>
</ul>
<h4 id="for-operations-manager-2016">For Operations Manager 2016</h4>
<p>For the latest list of exclusions, see <a href="/en-us/system-center/scom/plan-security-antivirus" data-linktype="absolute-path">Configuring antivirus exclusions for agent and components</a>.</p>
<h2 id="exclusion-of-file-type-by-extensions">Exclusion of file type by extensions</h2>
<p>The following file name extension-specific exclusions for Operations Manager include real-time scans, scheduled scans, and local scans.</p>
<h3 id="sql-server-database-servers-1">SQL Server database servers</h3>
<p>These exclusions include the SQL Server database files that are used by Operations Manager components and the system database files for the master database and for the tempdb database.</p>
<p>For example:</p>
<ul>
<li>MDF</li>
<li>LDF</li>
</ul>
<h3 id="operations-manager-management-servers-gateways-and-agents-1">Operations Manager (management servers, gateways, and agents)</h3>
<p>These exclusions include the queue and log files that are used by Operations Manager.</p>
<p>For Example:</p>
<ul>
<li>EDB</li>
<li>CHK</li>
<li>LOG</li>
</ul>
<div class="NOTE">
<p>Note</p>
<p>Page files should also be excluded from any real-time scans.</p>
</div>
