USE Northwind
GO
--IOفعال سازي آمار
--مفاهيم زير شرح داده شود
--Phisical Read --دیسک ioهای انجام شده
--Logical Read	--تعداد صفحاتی که خوانده شده است
--Read Ahead	--خوندن جلوجلو --قرار دادن دیتاهای احتمالی در مموری
SET STATISTICS IO ON
GO
--تعداد صفحات واکشی شده بررسی گردد
SELECT * FROM Orders
GO
--خالی کردن محتوای حافظه تخصیص داده شده به ازای صفحات
DBCC DROPCLEANBUFFERS
GO
--تعداد صفحات واکشی شده بررسی گردد
SELECT OrderID,OrderDate FROM Orders
GO
SET STATISTICS IO OFF
GO
--خالی کردن محتوای حافظه تخصیص داده شده به ازای صفحات
DBCC DROPCLEANBUFFERS
GO
---------------------------
--فعال سازی آمار زمان اجرا
SET STATISTICS TIME ON
--تعداد صفحات واکشی شده بررسی گردد
SELECT * FROM Orders
GO
--خالی کردن محتوای حافظه تخصیص داده شده به ازای صفحات
DBCC DROPCLEANBUFFERS
GO
--تعداد صفحات واکشی شده بررسی گردد
SELECT OrderID,OrderDate FROM Orders
GO
SET STATISTICS TIME OFF
GO
---------------------------------
--Execution Plane مشاهده 
--نقشه اجرایی در واقع نحوه اجرا شدن یک کوئری را مشخص می کند
--به این موضوع اصطلاحا ترتیب اجرای فیزیکی کوئری می گویند
GO
--Execution Plane بررسی 
SELECT * FROM Orders
GO
--Execution Plane بررسی انواع
SELECT * FROM Orders
GO
--Execution Plane بررسی نحوه خواندن
SELECT * FROM Orders
	INNER JOIN [Order Details] ON Orders.OrderID=[Order Details].OrderID
GO

/*
انواع Plan:
estimated plan: ارزیابی اجرای پرس و جو قبل از اجرا و برآورد وضعیت اجرا را که توسط Optimizer بدست می آید نشان می دهد و به یکی از روشهای زیر قابل دسترسی می باشد:
با کلیک روی آیکن Display Estimated Execution Plan روی نوار ابزار.
 با راست کلیلک روی پنجره query و انتخاب same option.
 با کلیک روی Query option روی نوار menu bar و انتخاب same choice.
 کلیدهای CTRL+L.
actual plan: پلان واقعی اجرای query را نشان می دهد و به یکی از روشهای زیر قابل دسترسی می باشد:
کلیک روی آیکن Include Actual Execution Plan در نوار ابزار.
کلیک راست روی پنجرهquery و انتخاب Include Actual Execution Plan از منو.

انتخاب same option در منوی Query.
کلیدهای CTRL+M.
*/

/*
اطلاعات کسب شده از Execution Plan:
با کمک ToolTip های موجود در Execution Plan می توانیم به مطالب زیادی دسترسی پیدا کنیم. هر شکل موجود در این پلان گویای یک حقیقت است و ما برای تحلیل بهتر یک query و استفاده مناسب از Execution Plan در راستای بهینه کردن query باید به تمامی این اطلاعات و اشکال اشراف کامل داشته باشیم.

در ادامه به تعدادی از این موارد اشاره می کنیم و برای آشنایی کامل با Execution Plan پیشنهاد می کنیم جلسه سوم مجموعه افزایش کارآیی و سرعت بانک اطلاعاتی را خریداری نمایید:

Cached plan size: مقداری از حافظه که توسط این پلان در حین کش پلان مورد استفاده قرار می گیرد.
Degree of Parallelism: تعداد پردازنده ای که توسط این پلان مورد استفاده قرار می گیرد.
Estimated Operator Cost: هزینه اجرای پرس و جو را ارزیابی می نماید.
Estimated Subtree Cost: هزینه اجرای این قسمت از query را نسبت به کل آن بیان می کند و از راست به چپ این مراحل دنبال می شوند.
Estimated Number of Rows: ارزیابی تعداد ردیف انتخاب شده توسط query را نشان می دهد و توسط Optimizer محاسبه می شود.
Actual Number of Rows: تعداد واقعی ردیف انتخاب شده توسط query را نشان می دهد
*/

/*
index seek بر روی جدول اشخاص و 
clustered index seek بر روی جدول ایمیل‌ها صورت می‌گیرد. 
nested loop بیانگر جوین بین جداول است.
--این عملگرها بیانگر اعمال فیزیکی هستند که رخ داده‌اند
*/