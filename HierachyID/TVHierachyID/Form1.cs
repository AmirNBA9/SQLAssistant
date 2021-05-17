//using System;
//using System.Collections.Generic;
//using System.ComponentModel;
//using System.Data;
//using System.Drawing;
//using System.Linq;
//using System.Text;
//using System.Windows.Forms;
//using System.Data.SqlClient;
//using Microsoft.SqlServer.Types;
//using System.IO;

//namespace TVHierachyID
//{
//	public partial class Form1 : Form
//	{
//		public Form1()
//		{
//			InitializeComponent();
//		}

//		private clsData oData = new clsData();

//		private DataTable dtData;
//		private BindingSource oBS = new BindingSource();

//		private void btnGetData_Click(object sender, EventArgs e)
//		{
//			dtData = oData.GetData();
//			oBS.DataSource = dtData;
//			dgData.DataSource = oBS;
//			lblCount.Text = string.Format("{0} records loaded", oBS.Count);

//		}

//		private void btnClose_Click(object sender, EventArgs e)
//		{
//			this.Close();
//		}

//		private void doTV_Click(object sender, EventArgs e)
//		{
//			//column ordinals can be used instead of strings.
//			string sKeyField = "NodeKey", sTextField = "Element";

//			LoadTreeSQLHierarchy(this.tvData, dtData,sKeyField,sTextField);
//		}

//		/// <summary>
//		/// Uses Linq to filter the table
//		/// additional info from: http://nesteruk.org/blog/post/Working-with-SQL-Server-hierarchical-data-and-Silverlight.aspx#Reference6
//		/// </summary>
//		/// <param name="oTV">Treeview to load</param>
//		/// <param name="oTable">datatable with the nodekey</param>
//		private void LoadTreeSQLHierarchy(TreeView oTV, DataTable oTable, string sKeyField, string sTextField)
//		{
//			oTV.Nodes.Clear();

//			TreeNode oNode;

//			//get an empty id to get the top node
//			SqlHierarchyId iID = new SqlHierarchyId();

//			//filter the table using linq. See blog for equals()/== issue
//			EnumerableRowCollection<DataRow> query = from TNodes in oTable.AsEnumerable()
//																							 where TNodes.Field<SqlHierarchyId>(sKeyField).GetAncestor(1).Equals(iID)
//													 select TNodes;

//			//convert to a dataview because I am comfortable with a dataview.
//			DataView oDV = query.AsDataView();
//			if (oDV.Count == 1)
//			{
//				//load up a node
//				oNode = new TreeNode(oDV[0][sTextField].ToString());

//				//put the datarow into the tag property
//				oNode.Tag = oDV[0].Row;

//				//load up the children
//				LoadNodeSQLHierarchy(oNode, oTable);

//				//add the node hierarchy to the tree
//				oTV.Nodes.Add(oNode);
//			}
//		}

//		/// <summary>
//		/// Load up the children 
//		/// </summary>
//		/// <param name="oParent">parent node</param>
//		/// <param name="oTable">datatable with the nodekey</param>
//		private void LoadNodeSQLHierarchy(TreeNode oParent, DataTable oTable)
//		{

//			// make sure there are no existing nodes in case this is a reload of the node
//			oParent.Nodes.Clear();

//			//get the nodekey from the tag property of the parent node
//			SqlHierarchyId iID = new SqlHierarchyId();
//			DataRow oRow = (DataRow)oParent.Tag;
//			iID = (SqlHierarchyId)oRow["NodeKey"];

//			//filter the datatable on for the children
//			EnumerableRowCollection<DataRow> query = from order in oTable.AsEnumerable()
//													 where order.Field<SqlHierarchyId>("NodeKey").GetAncestor(1).Equals(iID)
//													 select order;

//			//add the nodes to the tree
//			DataView oDV = query.AsDataView();
//			foreach (DataRowView oDR in oDV)
//			{
//				TreeNode oNode = new TreeNode(oDR["Element"].ToString());
//				oNode.Tag = oDR.Row;

//				LoadNodeSQLHierarchy(oNode, oTable);
//				oParent.Nodes.Add(oNode);
//			}

//		}
//	}
//}
