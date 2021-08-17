using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Globalization;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction]
    public static SqlString ConvertToShamsi(SqlDateTime m)
    {
        PersianCalendar pc = new PersianCalendar();

        DateTime miladi = (DateTime)m;

        int year = pc.GetYear(miladi);
        int month = pc.GetMonth(miladi);
        int day = pc.GetDayOfMonth(miladi);

        string shamsi = year.ToString() + "/" + month.ToString().PadLeft(2, '0') + "/" + day.ToString().PadLeft(2, '0');
        return shamsi;
    }
}
