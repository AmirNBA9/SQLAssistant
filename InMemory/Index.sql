
DROP TABLE IF EXISTS SupportEvent;  
go  

CREATE TABLE SupportEvent  
(  
    SupportEventId   int               not null   identity(1,1)  
    PRIMARY KEY NONCLUSTERED,  

    StartDateTime        datetime2     not null,  
    CustomerName         nvarchar(16)  not null,  
    SupportEngineerName  nvarchar(16)      null,  
    Priority             int               null,  
    Description          nvarchar(64)      null  
)  
    WITH (  
    MEMORY_OPTIMIZED = ON,  
    DURABILITY = SCHEMA_AND_DATA);  
go  

    --------------------  

ALTER TABLE SupportEvent  
    ADD CONSTRAINT constraintUnique_SDT_CN  
    UNIQUE NONCLUSTERED (StartDateTime DESC, CustomerName);  
go  

ALTER TABLE SupportEvent  
    ADD INDEX idx_hash_SupportEngineerName  
    HASH (SupportEngineerName) WITH (BUCKET_COUNT = 64);  -- Nonunique.  
go  

    --------------------  

INSERT INTO SupportEvent  
    (StartDateTime, CustomerName, SupportEngineerName, Priority, Description)  
    VALUES  
    ('2016-02-23 13:40:41:123', 'Abby', 'Zeke', 2, 'Display problem.'     ),  
    ('2016-02-24 13:40:41:323', 'Ben' , null  , 1, 'Cannot find help.'    ),  
    ('2016-02-25 13:40:41:523', 'Carl', 'Liz' , 2, 'Button is gray.'      ),  
    ('2016-02-26 13:40:41:723', 'Dave', 'Zeke', 2, 'Cannot unhide column.');  
go