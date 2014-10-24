package com.ibm.asset.trails.batch.swkbt;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Value;
 
public class DB2Connect {
  public static void main(String[] argv) {
    try {
   Class.forName("COM.ibm.db2.jdbc.app.DB2Driver");
     } catch (ClassNotFoundException e) {
      System.out.println("Please include Classpath  Where your DB2 Driver is located");
      e.printStackTrace();
      return;
      }
  System.out.println("DB2 driver is loaded successfully");
  Connection conn = null;
 PreparedStatement pstmt = null;
 ResultSet rset=null;
 boolean found=false;
    try {
   conn = DriverManager.getConnection("jdbc:db2:trails", "eaadmin", "nov2011a");
         if (conn != null)
  {
    System.out.println("DB2 Database Connected");
  }
        else
  {
           System.out.println("Db2 connection Failed ");
        }
  pstmt=conn.prepareStatement("Select count(*) as mycount from kb_definition");
  rset=pstmt.executeQuery();
       if(rset!=null)
  {
 
  while(rset.next())
   {
   found=true;
   System.out.println("Count: "+rset.getString("mycount"));
   }
   }
  if (found ==false)
  {
   System.out.println("No Information Found");
  }
   } catch (SQLException e) {
     System.out.println("DB2 Database connection Failed");
     e.printStackTrace();
     return;
     }
}
}

