-- Union and union all
SELECT  SubjectCode, SubjectName, MarksObtained
  FROM  Marksheet1
UNION
SELECT  CourseCode, CourseName, MarksObtained
  FROM  Marksheet2;

/*
Note: The output for union of the three tables will also be same as union on Marksheet1 and Marksheet2 because
union operation does not take duplicate values.
*/
SELECT  SubjectCode, SubjectName, MarksObtained
  FROM  Marksheet1
UNION
SELECT  CourseCode, CourseName, MarksObtained
  FROM  Marksheet2
UNION
SELECT  SubjectCode, SubjectName, MarksObtained
  FROM  Marksheet3;