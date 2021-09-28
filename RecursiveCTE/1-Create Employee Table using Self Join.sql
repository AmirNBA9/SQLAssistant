USE HR


DROP TABLE IF EXISTS Employees; 

CREATE TABLE Employees
(
   EmployeeID int NOT NULL PRIMARY KEY,
   EmpName Nvarchar(20) NOT NULL,
   Title Nvarchar(50) NULL,
   ManagerID INT NULL REFERENCES Employees(EmployeeID) 
) ;



INSERT INTO Employees (EmployeeID, EmpName, Title,ManagerID)
    VALUES (1 , N'علی', N'مدیر عامل',NULL) ,
	       (2, N'احمد', N'معاونت نرم افزار',1 ) ,
           (3, N'حسین', N'معاونت پشتیبانی سیستمها',1),
           (4, N'تقی', N'معاونت فروش',1),
           (5, N'جواد', N'معاونت اداری و مالی' ,1),
           (6, N'اکبر', N'مدیر تحلیل سیستمها',2),
           (7, N'زهرا', N'مدیر برنامه نویسی' ,2),
           (8, N'مریم', N'تحلیلگر سیستم',6) ,
           (9, N'کوروش', N'تحلیلگر سیستم',6),
           (10, N'شیرین', N'مستند ساز',6) , 
           (11, N'پیام', N'برنامه نویس' ,7),
           (12, N'پیمان', N'برنامه نویس',7),
           (13, N'رضا', N'برنامه نویس',7) ,
           (14, N'داریوش', N'مدیر شبکه',3),
           (15, N'کاوه', N'مدیر پشتیبانی',3),
           (16, N'پرستو', N'مدیر بانک اطلاعاتی',3),
           (17, N'اسد', N'تکنیسین شبکه' ,14),
           (18, N'ساسان', N'تکنیسین شبکه',14),
           (19, N'اکرم', N'پشتیبان سیستم فروش',15),
           (20, N'حمید', N'پشتیبان سیستم مالی' ,15),
           (21, N'محسن', N'پشتیبان سیستم تولید',15),
           (22, N'محمد', N'پشتیبان سیستم انبار' ,15);

GO

SELECT *
FROM Employees
ORDER BY EmployeeID
