ALTER TABLE [Business].[Setting]
    ADD CONSTRAINT [Log record should be formatted as JSON]
                   CHECK (ISJSON(log)=1)