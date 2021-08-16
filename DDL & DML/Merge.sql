Declare  @JsonContact			Nvarchar(max)	= '[{"id":"2","type":1,"province":28,"city":233,"mainstreet":"beheshti","bystreet":"ghasir","alley":"chaharom","plaque":"A32","floor":"2","num":3,"zipcode":"12-335-1-175","lat":"32.842674","long":"55.467689","pretel1":21,"tel1":8822352,"pretel2":313,"tel2":8822352,"tel3":8822352,"precell1":912,"cell1":9121122333,"precell2":911,"cell2":9121122333,"precell3":913,"cell3":9121122333}]'

  
MERGE INTO Business.Contacts  AS Target  
USING (Select	ContactID, AddressType, Province, City, MainStreet, ByStreet, Alley, Plaque, FloorNumber, Num, ZipCode, Latitude, Longitude, NationalDialCode1	
						,DialNumber1, NationalDialCode2, DialNumber2, NationalDialCode3, DialNumber3, NationalMobileCode1, MobileNumber1, NationalMobileCode2, MobileNumber2, NationalMobileCode3, MobileNumber3		
				From OpenJson(@JsonContact) 
				With(	ContactID			bigint			'$.id',
						AddressType			int				'$.type',
						Province			smallint		'$.province',
						City				int				'$.city',
						MainStreet			nvarchar(50)	'$.mainstreet',
						ByStreet			nvarchar(50)	'$.bystreet',
						Alley				nvarchar(50)	'$.alley',
						Plaque				nvarchar(10)	'$.plaque',
						FloorNumber			smallint		'$.floor',
						Num					tinyint			'$.num',
						ZipCode				nvarchar(20)	'$.zipcode',
						Latitude			decimal(10, 7)	'$.lat',
						Longitude			decimal(10, 7)	'$.long',
						NationalDialCode1	nvarchar(5)		'$.pretel1',
						DialNumber1			bigint			'$.tel1',
						NationalDialCode2	nvarchar(5)		'$.pretel2',
						DialNumber2			bigint			'$.tel2',
						NationalDialCode3	nvarchar(5)		'$.pretel3',
						DialNumber3			bigint			'$.tel3',
						NationalMobileCode1 nvarchar(5)		'$.precell1',
						MobileNumber1		bigint			'$.cell1',
						NationalMobileCode2 nvarchar(5)		'$.precell2',
						MobileNumber2		bigint			'$.cell2',
						NationalMobileCode3 nvarchar(5)		'$.precell3',
						MobileNumber3		bigint			'$.cell3'
					)
)  AS Source (ContactID, AddressType,Province,City, MainStreet,ByStreet,Alley,Plaque,FloorNumber,Num,ZipCode,Latitude,Longitude,NationalDialCode1,DialNumber1			
			  ,NationalDialCode2,DialNumber2,NationalDialCode3,DialNumber3,NationalMobileCode1,MobileNumber1,NationalMobileCode2,MobileNumber2,NationalMobileCode3,MobileNumber3
			  )  
ON Target.ContactID = Source.ContactID
WHEN MATCHED THEN  
	UPDATE 	Set  AddressType= Source.AddressType
				,Province	= Source.Province
				,City		= Source.City
				,MainStreet	= Source.MainStreet
				,ByStreet	= Source.ByStreet
				,Alley		= Source.Alley
				,Plaque		= Source.Plaque
				,FloorNumber= Source.FloorNumber
				,Num		= Source.Num
				,ZipCode	= Source.ZipCode
				,Latitude	= Source.Latitude
				,Longitude	= Source.Longitude
				,NationalDialCode1	= Source.NationalDialCode1
				,DialNumber1		= Source.DialNumber1
				,NationalDialCode2	= Source.NationalDialCode2
				,DialNumber2		= Source.DialNumber2
				,NationalDialCode3	= Source.NationalDialCode3
				,DialNumber3		= Source.DialNumber3
				,NationalMobileCode1= Source.NationalMobileCode1
				,MobileNumber1		= Source.MobileNumber1
				,NationalMobileCode2= Source.NationalMobileCode2
				,MobileNumber2		= Source.MobileNumber2
				,NationalMobileCode3= Source.NationalMobileCode3
				,MobileNumber3		= Source.MobileNumber3
WHEN NOT MATCHED BY TARGET THEN  
	INSERT (AddressType,Province,City, MainStreet,ByStreet,Alley,Plaque,FloorNumber,Num,ZipCode,Latitude,Longitude,NationalDialCode1,DialNumber1			
			  ,NationalDialCode2,DialNumber2,NationalDialCode3,DialNumber3,NationalMobileCode1,MobileNumber1,NationalMobileCode2,MobileNumber2,NationalMobileCode3,MobileNumber3
			  ) 
	Select	AddressType, Province, City, MainStreet, ByStreet, Alley, Plaque, FloorNumber, Num, ZipCode, Latitude, Longitude, NationalDialCode1	
			,DialNumber1, NationalDialCode2, DialNumber2, NationalDialCode3, DialNumber3, NationalMobileCode1, MobileNumber1, NationalMobileCode2, MobileNumber2, NationalMobileCode3, MobileNumber3		
	From OpenJson(@JsonContact) 
	With(	AddressType			int				'$.type',
			Province			smallint		'$.province',
			City				int				'$.city',
			MainStreet			nvarchar(50)	'$.mainstreet',
			ByStreet			nvarchar(50)	'$.bystreet',
			Alley				nvarchar(50)	'$.alley',
			Plaque				nvarchar(10)	'$.plaque',
			FloorNumber			smallint		'$.floor',
			Num					tinyint			'$.num',
			ZipCode				nvarchar(20)	'$.zipcode',
			Latitude			decimal(10, 7)	'$.lat',
			Longitude			decimal(10, 7)	'$.long',
			NationalDialCode1	nvarchar(5)		'$.pretel1',
			DialNumber1			bigint			'$.tel1',
			NationalDialCode2	nvarchar(5)		'$.pretel2',
			DialNumber2			bigint			'$.tel2',
			NationalDialCode3	nvarchar(5)		'$.pretel3',
			DialNumber3			bigint			'$.tel3',
			NationalMobileCode1 nvarchar(5)		'$.precell1',
			MobileNumber1		bigint			'$.cell1',
			NationalMobileCode2 nvarchar(5)		'$.precell2',
			MobileNumber2		bigint			'$.cell2',
			NationalMobileCode3 nvarchar(5)		'$.precell3',
			MobileNumber3		bigint			'$.cell3'
		) 