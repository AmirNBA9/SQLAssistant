//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
//using System.Data;
//using System.Data.SqlClient;
//using System.IO;

//namespace TVHierachyID
//{
//    class clsData
//    {
//        /// <summary>
//        /// connection string to the database of your choice
//        /// </summary>
//        private const string sConnection = "Data Source=Server;Initial Catalog=Database;Integrated Security=True;Pooling=True;Min Pool Size=1;Max Pool Size=10";

//        /// <summary>
//        /// Get the data from the database or the XML string
//        /// </summary>
//        /// <returns></returns>
//        public DataTable GetData()
//        {
//            DataTable oTable = new DataTable();
//            FileInfo oFI = new FileInfo("SampleData.xml");

//            //test for the existing sample data xml
//            if (!oFI.Exists)
//            {
//                //get the data from the database
//                oTable = GetTableSQL();

//                //you need to write out the schema with the data to read it into the table.
//                oTable.WriteXml(oFI.FullName, XmlWriteMode.WriteSchema);
//            }

//            //read in the data from the xml file
//            oTable.ReadXml(oFI.FullName);

//            //anonomise the data
//            foreach (DataRow oRow in oTable.Rows)
//            {
//                oRow["Element"] = string.Format("Element{0}", oRow["ElementID"]);

//                //convert the string back into a hierarchyid
//                oRow["NodeKey"] = SqlHierarchyId.Parse((string)oRow["NodeString"]);
//            }
//            return oTable;

//        }


//        /// <summary>
//        /// Get the data from the SQL database the first time or of the XML is missing
//        /// </summary>
//        /// <param name="sSQL">Select statement</param>
//        /// <returns>sample datatable</returns>
//        private DataTable GetTableSQL()
//        {

//            SqlCommand oCmd = new SqlCommand();
//            SqlDataAdapter oDA = new SqlDataAdapter();
//            DataSet oDS = new DataSet();
//            SqlParameter oParam = new SqlParameter();
//            oParam.ParameterName = "TreeID";
//            oParam.Value = 30;
//            oParam.SqlDbType = SqlDbType.Int;
//            oParam.Direction = oParam.Direction;
//            oCmd.Parameters.Add(oParam);
//            oCmd.Connection = new SqlConnection(sConnection);
//            oCmd.CommandType = CommandType.StoredProcedure;
//            oCmd.CommandText = "TreeNodeGetTree";

//            oDA.SelectCommand = oCmd;
//            oDA.Fill(oDS);

//            //anonomise the data
//            foreach (DataRow oRow in oDS.Tables[0].Rows)
//            {
//                oRow["Element"] = string.Format("Element{0}", oRow["ElementID"]);
//            }
//            oDS.Tables[0].AcceptChanges();

//            return oDS.Tables[0];
//        }
//    }
//}
