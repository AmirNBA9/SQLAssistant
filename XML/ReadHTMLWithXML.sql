DECLARE @HtmlTbl TABLE (ID INT IDENTITY, Html XML);
INSERT INTO @HtmlTbl(Html) VALUES('<div class="accordion-tabbed__tab-mobile accordion__closed">
        <a href="http://185.141.105.238/action/doSearch?ContribAuthorStored=PRICE%2C+M+A"
           class="author-name accordion-tabbed__control" data-id="a1"
           data-db-target-for="a1" aria-controls="a1" aria-haspopup="true"
           id="a1_Ctrl" role="button">
            <span>M. A. PRICE</span>
            <i aria-hidden="true" class="icon-section_arrow_d"></i>
        </a>
        <div class="author-info accordion-tabbed__content"
             data-db-target-of="a1" aria-labelledby="a1_Ctrl" role="region"
             id="a1">
            <p>Department of Mechanical and Manufacturing Engineering, The Queen''s University of Belfast, Belfast BT95AH, U.K.</p>
            <a class="moreInfoLink"
               href="http://185.141.105.238/action/doSearch?ContribAuthorStored=PRICE%2C+M+A">Search for more papers by this author</a>
        </div>
    </div>
    <div class="accordion-tabbed__tab-mobile accordion__closed">
        <a href="http://185.141.105.238/action/doSearch?ContribAuthorStored=ARMSTRONG%2C+C+G"
           class="author-name accordion-tabbed__control" data-id="a2"
           data-db-target-for="a2" aria-controls="a2" aria-haspopup="true"
           id="a2_Ctrl" role="button">
            <span>C. G. ARMSTRONG</span>
            <i aria-hidden="true" class="icon-section_arrow_d"></i>
        </a>
        <div class="author-info accordion-tabbed__content"
             data-db-target-of="a2" aria-labelledby="a2_Ctrl" role="region"
             id="a2">
            <p>Department of Mechanical and Manufacturing Engineering, The Queen''s University of Belfast, Belfast BT95AH, U.K.</p>
            <a class="moreInfoLink"
               href="http://185.141.105.238/action/doSearch?ContribAuthorStored=ARMSTRONG%2C+C+G">Search for more papers by this author</a>
        </div>
    </div>');

-- INSERT INTO dbo.Researcher (Full_Name, [URL], [Address], University, Country) -- uncommemnt when you are ready
SELECT ID
    , c.value('(a/span/text())[1]', 'nvarchar(50)') AS Full_Name
    , c.value('(div/a/@href)[1]', 'nvarchar(max)') AS [URL]
    , c.value('(div/p/text())[1]', 'nvarchar(max)') AS [Address]
    , JSON_VALUE(x,'$[1]') AS University
    , JSON_VALUE(x,'$[3]') AS Country
    -- continue with the rest
FROM @HtmlTbl
CROSS APPLY Html.nodes('/div') AS t(c)
CROSS APPLY (VALUES ('["' + REPLACE(c.value('(div/p/text())[1]', 'nvarchar(max)'),',','","') + '"]')) AS t2(x);